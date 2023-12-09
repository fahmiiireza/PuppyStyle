//
//  Item.swift
//  DoggyStyle
//
//  Created by Fahmi Fahreza on 05/12/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

//Just for UI testing purposes
struct Dog: Hashable{
    
    var name = "bello"
    
}

@Model
class UserData{
    
    var firstName: String?
    var LastName: String?
    var location: String?
    var email: String?
    var telNumber: String?
    var withGoogle: Bool?
    
    init(firstName: String? = nil, LastName: String? = nil, location: String? = nil, email: String? = nil, telNumber: String? = nil, withGoogle: Bool? = nil) {
        self.firstName = firstName
        self.LastName = LastName
        self.location = location
        self.email = email
        self.telNumber = telNumber
        self.withGoogle = withGoogle
    }
}
