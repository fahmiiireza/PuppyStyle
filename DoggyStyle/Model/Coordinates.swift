//
//  Coordinates.swift
//  DoggyStyle
//
//  Created by Fahmi Fahreza on 12/12/23.
//

import Foundation
import MapKit
// Define a Coordinate structure
struct Coordinate {
    let latitude: Double
    let longitude: Double
}

// Coordinates for Rome
let romeCoordinates: [Coordinate] = [
    Coordinate(latitude: 41.9028, longitude: 12.4964),
    Coordinate(latitude: 41.9022, longitude: 12.4534),
    Coordinate(latitude: 41.8902, longitude: 12.4922),
    Coordinate(latitude: 41.9124, longitude: 12.4934),
    Coordinate(latitude: 41.9101, longitude: 12.4818),
    Coordinate(latitude: 41.8933, longitude: 12.4826),
    Coordinate(latitude: 41.8908, longitude: 12.5024),
    Coordinate(latitude: 41.8992, longitude: 12.4733),
    Coordinate(latitude: 41.8955, longitude: 12.4984),
    Coordinate(latitude: 41.8957, longitude: 12.5113)
]

// Coordinates for Milan
let milanCoordinates: [Coordinate] = [
    Coordinate(latitude: 45.4642, longitude: 9.1900),
    Coordinate(latitude: 45.4675, longitude: 9.1865),
    Coordinate(latitude: 45.4700, longitude: 9.2059),
    Coordinate(latitude: 45.4585, longitude: 9.1726),
    Coordinate(latitude: 45.4800, longitude: 9.2042),
    Coordinate(latitude: 45.4753, longitude: 9.1503),
    Coordinate(latitude: 45.4640, longitude: 9.1761),
    Coordinate(latitude: 45.4782, longitude: 9.2382),
    Coordinate(latitude: 45.4668, longitude: 9.2095),
    Coordinate(latitude: 45.4534, longitude: 9.1717)
]

// Coordinates for Florence
let florenceCoordinates: [Coordinate] = [
    Coordinate(latitude: 43.7696, longitude: 11.2558),
    Coordinate(latitude: 43.7777, longitude: 11.2573),
    Coordinate(latitude: 43.7723, longitude: 11.2519),
    Coordinate(latitude: 43.7706, longitude: 11.2658),
    Coordinate(latitude: 43.7761, longitude: 11.2485),
    Coordinate(latitude: 43.7744, longitude: 11.2707),
    Coordinate(latitude: 43.7792, longitude: 11.2550),
    Coordinate(latitude: 43.7656, longitude: 11.2685),
    Coordinate(latitude: 43.7715, longitude: 11.2650),
    Coordinate(latitude: 43.7770, longitude: 11.2569)
]


// Coordinates for Naples
let naplesCoordinates: [CLLocationCoordinate2D] = [
    CLLocationCoordinate2D(latitude: 40.8522, longitude: 14.2681),
    CLLocationCoordinate2D(latitude: 40.8528, longitude: 14.2689),
//    Coordinate(latitude: 40.8535, longitude: 14.2697),
//    Coordinate(latitude: 40.8542, longitude: 14.2705),
//    Coordinate(latitude: 40.8549, longitude: 14.2713),
//    Coordinate(latitude: 40.8556, longitude: 14.2721),
//    Coordinate(latitude: 40.8563, longitude: 14.2729),
//    Coordinate(latitude: 40.8570, longitude: 14.2737),
//    Coordinate(latitude: 40.8577, longitude: 14.2745),
//    Coordinate(latitude: 40.8584, longitude: 14.2753)
]

struct Place: Hashable{
    let city: String
    let longitude: Double
    let latitude: Double
    let img: String
}

class PlaceList{
    var places: [Place] = [
        Place(city:"Napoli", longitude: 14.30614, latitude: 40.83661, img: "Google" ),
        Place(city:"Napoli", longitude: 14.308761, latitude: 40.837115,img: "PlaceholderDog" ),
        Place(city:"Napoli", longitude: 14.299792, latitude: 40.838223 ,img: "PlaceholderProfile" ),
        Place(city:"New York", longitude: -74.051406, latitude: 40.730671,img: "Google" ),
        Place(city:"New York", longitude: -74.088864, latitude: 40.706522, img: "PlaceholderDog" ),
    ]
}
