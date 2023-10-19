//
//  ContentView.swift
//  ShareYourMeal
//
//  Created by robin tetley on 16/10/2023.
//

import SwiftUI

struct ContentView: View {
    @Environment(DataController.self) var dataController
    
    var body: some View {
        
        if let selectedFoodbank = dataController.selectedFoodbank {
            TabView {
                Text("Home")
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                
                Text("My Foodbank")
                    .tabItem {
                        Label("My Foodbank", systemImage: "building.2")
                    }
                
                Text("Drop-off Points")
                    .tabItem {
                        Label("Drop-off Points", systemImage: "basket ")
                    }
            }
        } else {
              
            EnterLocationView()
        }
        
    }
}

//#Preview {
//    ContentView()
//}
