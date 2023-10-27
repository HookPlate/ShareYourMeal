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
        case name, slug, phone, email, address, distance = "distance_m", items = "needs"
    }
    
    var id: String { slug }
    var name: String
    var slug: String
    var phone: String
    var email: String
    var address: String
    //the below property doesn't exist on the JSON - codingkeys
    var distance: Int
    //in the JSON the below is called needs, hence another Coding Key
    var items: Items
    
    var distanceFormatted: String {
        let measurement = Measurement(value: Double(distance), unit: UnitLength.meters)
        //makes a string from the above formatted correctly. This automatically takes into account the users local settings for us.
        let measurementString = measurement.formatted(.measurement(width: .wide))
        return "\(measurementString) from you"
    }
    //takes the items object, pull its needs out, break it up by line breaks, remove duplicates and sort the result.
    var neededItems: [String] {
        //give me this thing as a array of strings
        let baseList = items.needs.components(separatedBy: .newlines)
        //set removes duplicates
        return Set(baseList).sorted()
    }
}

extension Foodbank {
    struct Items: Codable, Identifiable {
        var id: String
        var needs: String
        var excess: String?
        
        static let example = Items(id: "Example ID", needs: "Example Needed item", excess: "Example Excess item.")
    }
}
