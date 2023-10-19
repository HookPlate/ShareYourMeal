//
//  SelectFoodbankView.swift
//  ShareYourMeal
//
//  Created by robin tetley on 17/10/2023.
//

import SwiftUI

struct SelectFoodbankView: View {
    @Environment(DataController.self) var dataController
    @State private var state = LoadState.loading
    
    var postCode: String
    
    var body: some View {
        //using a group because we're going to show one of 3 loading states but all 3 need the same navigation title.
        Group {
            switch state {
            case .loading:
                ProgressView("Loading...")
            case .failed:
                ContentUnavailableView {
                    Label("Load Failed", systemImage: "exclamationmark.triangle")
                } description: {
                    Text("Loading failed, please try again.")
                } actions: {
                    Button("Retry", systemImage: "arrow.circlepath", action: fetchFoodbanks)
                        .buttonStyle(.borderedProminent)
                }
            case .loaded(let foodbanks):
                List {
                    ForEach(foodbanks) { foodbank in
                        Section(foodbank.distanceFormatted) {
                            VStack(alignment: .leading) {
                                Text(foodbank.name)
                                    .font(.title)
                                
                                Text(foodbank.address)
                                
                                Button("Select this foodbank") {
                                    //does all the work of showing or hiding the main app for us. no need for bools etc.
                                    withAnimation {
                                        dataController.select(foodbank)
                                    }
                                }
                                .buttonStyle(.borderless)
                                .frame(maxWidth: .infinity, alignment: .center)
                                .padding(.top, 5)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
            }
        }
        .navigationTitle("Nearby Foodbanks")
        .task {
            fetchFoodbanks()
        }
    }
    
    func fetchFoodbanks() {
        state = .loading
        
        Task {
            try await  Task.sleep(for: .seconds(0.5))
            state = await dataController.loadFoodbanks(near: postCode)
        }
    }
}

#Preview {
    SelectFoodbankView(postCode: "BA2 1QW")
        .environment(DataController())
}
