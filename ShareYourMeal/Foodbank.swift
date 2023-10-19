//
//  Foodbank.swift
//  ShareYourMeal
//
//  Created by robin tetley on 16/10/2023.
//

import Foundation

struct Foodbank: Codable, Identifiable {
    
    enum CodingKeys: String, CodingKey {
        //list the coding keys we care about, also where we tell it that the distance property is mapped to a different name on the JSON, if you don't specify a raw value it'll become that thing.
        case name, slug, phone, email, address, distance = "distance_m"
    }
    
    var id: String { slug }
    var name: String
    var slug: String
    var phone: String
    var email: String
    var address: String
    //the below property doesn't exist on the JSON - codingkeys
    var distance: Int
    
    var distanceFormatted: String {
        let measurement = Measurement(value: Double(distance), unit: UnitLength.meters)
        //makes a string from the above formatted correctly. This automatically takes into account the users local settings for us.
        let measurementString = measurement.formatted(.measurement(width: .wide))
        return "\(measurementString) from you"
    }
}
