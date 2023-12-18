//
//  Item.swift
//  DoggyStyle
//
//  Created by Fahmi Fahreza on 05/12/23.
//

import Foundation
import SwiftData
import FirebaseFirestore
import FirebaseAuth

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}

@Model
class Dog: Hashable{
    
    @Attribute(.externalStorage) var imageData: [Data] = []
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

class DogsViewModel: ObservableObject {
    @Published var dogs: [Dog] = []
    let currentUserId = Auth.auth().currentUser?.uid

    private let db = Firestore.firestore()

    func fetchDogs() {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("No current user found")
            return
        }
        db.collection("dog")
            .whereField("user_id", isEqualTo: currentUserId)
            .getDocuments { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
            print("ahaa", currentUserId)
                var fetchedDogs: [Dog] = []
                for document in querySnapshot!.documents {
                    let data = document.data()

                    let dog = Dog(
                        imageNames: data["imageURLs"] as? [String] ?? [],
                        name: data["name"] as? String ?? "",
                        gender: data["gender"] as? String ?? "",
                        breed: data["breed"] as? String ?? "",
                        age: data["age"] as? String ?? "",
                        weight: data["weight"] as? String ?? "",
                        size: data["size"] as? String ?? "",
                        allergies: data["allergies"] as? String ?? "",
                        vaccination: data["vaccination"] as? String ?? "",
                        chronicdeseases: data["chronicdeseases"] as? String ?? "",
                        lastvetvisit: data["lastvetvisit"] as? String ?? "",
                        lenth: data["length"] as? String ?? "",
                        energylevel: data["energylevel"] as? String ?? "",
                        friendliness: data["friendliness"] as? String ?? "",
                        travelinglevel: data["travelinglevel"] as? String ?? ""
                    )
                    fetchedDogs.append(dog)
                }
                DispatchQueue.main.async {
                    self.dogs = fetchedDogs
                                }
            }
        }
    }
}
