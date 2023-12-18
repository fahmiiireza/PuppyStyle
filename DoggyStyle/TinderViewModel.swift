//
//  TinderViewModel.swift
//  DoggyStyle
//
//  Created by Sandro Beburishvili on 18/12/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class TinderViewModel: ObservableObject {
    @Published var dogs: [Dog] = []
    private let db = Firestore.firestore()

    func fetchOtherUsersDogs() {
        print("Fetching other users dogs")
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("No current user found")
            return
        }

        db.collection("dog")
          .whereField("user_id", isNotEqualTo: currentUserId)
          .getDocuments { [weak self] (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                var fetchedDogs: [Dog] = []
                for document in querySnapshot!.documents {
                    let data = document.data()
                    let dog = Dog(
                        documentId: data["documentId"] as? String ?? "",
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
                    self?.dogs = fetchedDogs
                }
            }
        }
    }
}
