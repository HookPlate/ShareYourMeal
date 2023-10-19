//
//  ShareYourMealApp.swift
//  ShareYourMeal
//
//  Created by robin tetley on 16/10/2023.
//

import SwiftUI

@main
struct ShareYourMealApp: App {
    @State private var dataController = DataController()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(dataController)
        }
    }
}
