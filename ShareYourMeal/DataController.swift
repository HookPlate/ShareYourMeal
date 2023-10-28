//
//  DataController.swift
//  ShareYourMeal
//
//  Created by robin tetley on 16/10/2023.
//

import Foundation

enum LoadState {
    case loading, failed, loaded([Foodbank])
}
 
@Observable
class DataController {
    //can't modify it directly, only read from it. To change it we add a dedicated option just to set this thing (hence private set.)
    private(set) var selectedFoodbank: Foodbank?
    //where we want to write the file on disk
    private let savePath = URL.documentsDirectory.appending(path: "SelectedFoodBank")
    
    init() {
        //loads the value from disk if there did happen to be a saved foodbank previously.
        do {
            let data = try Data(contentsOf: savePath)
            let savedFoodBank = try JSONDecoder().decode(Foodbank.self, from: data)
            select(savedFoodBank)
        } catch {
            
        }
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(selectedFoodbank)
            try  data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data")
        }
    }
    
    func loadFoodbanks(near postCode: String) async -> LoadState {
        // return.failed - used to test the ContentUnavailableView()
        let fullURl = "https://www.givefood.org.uk/api/2/foodbanks/search/?address=\(postCode)"
        
        guard let url = URL(string: fullURl) else {
            return .failed
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            //it provides a data object, we want the actual Foodbanks instead:
            let foodbanks = try JSONDecoder().decode([Foodbank].self, from: data)
            return .loaded(foodbanks)
        } catch {
            return .failed
        }
    }
    
    //to change selectedFoodbank they can't just overwrite it, they must call this function automatically.
    func select(_ foodbank: Foodbank?) {
        selectedFoodbank = foodbank
        save()
        //apparently will load a cached version if they're offline
        //form the doc: And now we can add a call to that in our select() method, so that every time a food bank is selected we also fetch its full details:
        Task {
            await upadateSelected()
        }
    }
    //has the job of handling that secondary url and handling it somehow on the screen.
    private func upadateSelected() async {
        //if not bail out since there's nothing to update.
        guard let current = selectedFoodbank else { return }
        //if we do have one do the same as before with a few changes
        let fullURl = "https://www.givefood.org.uk/api/2/foodbanks/\(current.slug)"
        //if we can't make a url out of the above bail out.
        guard let url = URL(string: fullURl) else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            //it provides a data object, we want the actual Foodbank (this time not an array of) instead:
            selectedFoodbank = try JSONDecoder().decode(Foodbank.self, from: data)
        } catch {
            print("failed to update foodbank \(error.localizedDescription)")
        }
    }
}
