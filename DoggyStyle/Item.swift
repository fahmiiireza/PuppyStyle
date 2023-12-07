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
