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

@Model
class Dog{
    
    var imageData: [Data] = []
    var imageURLs: [String] = []
    var name: String = "Test"
    var gender: String = "Male"
    var breed: String = "Golden Retriever"
    var age: String = "12"
    var weight: String = "34.56"
    var size: String = "23.45"
    var allergies: String = "none"
    var vaccination: String = "none"
    var chronicdeseases: String = "none"
    var lastvetvisit: String = "none"
    var length: String = "wtf"
    var energylevel: String = "G+"
    var friendliness: String = "not friendly"
    var travelinglevel: String = "what even is this?"
    
    init(imageNames: [String], name: String, gender: String, breed: String, age: String, weight: String, size: String, allergies: String, vaccination: String, chronicdeseases: String, lastvetvisit: String, lenth: String, energylevel: String, friendliness: String, travelinglevel: String) {
        self.imageURLs = imageNames
        self.name = name
        self.gender = gender
        self.breed = breed
        self.age = age
        self.weight = weight
        self.size = size
        self.allergies = allergies
        self.vaccination = vaccination
        self.chronicdeseases = chronicdeseases
        self.lastvetvisit = lastvetvisit
        self.length = lenth
        self.energylevel = energylevel
        self.friendliness = friendliness
        self.travelinglevel = travelinglevel
    }
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
