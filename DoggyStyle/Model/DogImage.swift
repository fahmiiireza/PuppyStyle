//
//  DogImage.swift
//  DoggyStyle
//
//  Created by Fahmi Fahreza on 11/12/23.
//

import SwiftUI


// MARK: - DogImageElement
struct DogImage: Codable {
    var breeds: [Breed]?
    var id: String?
    let url: String
    var width, height: Int?
}

// MARK: - Breed
struct Breed: Codable {
    var weight, height: Eight?
    var id: Int?
    var name, bredFor, breedGroup, lifeSpan: String?
    var temperament, referenceImageID: String?

    enum CodingKeys: String, CodingKey {
        case weight, height, id, name
        case bredFor = "bred_for"
        case breedGroup = "breed_group"
        case lifeSpan = "life_span"
        case temperament
        case referenceImageID = "reference_image_id"
    }
}

// MARK: - Eight
struct Eight: Codable {
    var imperial, metric: String?
}
