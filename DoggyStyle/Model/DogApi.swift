//
//  Dog.swift
//  DoggyStyle
//
//  Created by Fahmi Fahreza on 11/12/23.
//
import SwiftUI

struct DogApi: Codable, Identifiable {
    struct Size: Codable {
        let imperial: String
        let metric: String
    }

    struct Height: Codable {
        let imperial: String
        let metric: String
    }

    let weight: Size
    let height: Height
    let id: Int
    let name: String
    let bred_for: String?
    let breed_group: String?
    let life_span: String?
    let temperament: String?
    let origin: String?
    let reference_image_id: String
    var img: String?
    enum CodingKeys: String, CodingKey {
        case weight, height, id, name, bred_for, breed_group, life_span, temperament, origin, reference_image_id
    }
}
