//
//  HomeView.swift
//  ShareYourMeal
//
//  Created by robin tetley on 27/10/2023.
//

import SwiftUI

struct HomeView: View {
    @Environment(DataController.self) var dataController
    var foodBank: Foodbank
    
    var body: some View {
        NavigationStack {
            List {
                Section("\(foodBank.name) foodbank needs...") {
                    ForEach(foodBank.neededItems, id: \.self) { item in
                        Text(item)
                        
                    }
                }
            }
            .navigationTitle("Share your Meal")
            .toolbar {
                Button("Change Location") {
                    withAnimation {
                        //clear their selection and in doing so bring up the original
                        dataController.select(nil)
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView(foodBank: .example)
}
