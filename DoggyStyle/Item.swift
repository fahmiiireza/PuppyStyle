//
//  Item.swift
//  DoggyStyle
//
//  Created by Fahmi Fahreza on 05/12/23.
//

import Foundation
import SwiftData

// Item class annotated with @Model to make it storable
@Model
final class Item {
    var timestamp: Date

    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
