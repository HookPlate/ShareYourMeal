//
//  EnterLocationView.swift
//  ShareYourMeal
//
//  Created by robin tetley on 17/10/2023.
//

import SwiftUI

struct EnterLocationView: View {
    @State private var postCode = "BA2 1QW"
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Welcome")
                    .font(.largeTitle)
                Text("To get started, please tell us your postcode.")
                
                HStack {
                    TextField("Your Postcode", text: $postCode)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 200)
                    
                    NavigationLink("Go") {
                        SelectFoodbankView(postCode: postCode)
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
    }
}

#Preview {
    EnterLocationView()
}
