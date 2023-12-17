//
//  UserDataViewModel.swift
//  DoggyStyle
//
//  Created by Sandro Beburishvili on 11/12/23.
//

import Foundation
import FirebaseFirestore
import SwiftData
import FirebaseAuth

struct Location: Hashable {
    let city: String
    let longitude: Double
    let latitude: Double
}
struct Usert: Hashable {
    var id: String?
    var firstName: String?
    var LastName: String?
    var location: Location?
    var email: String?
    var telNumber: String?
    var withGoogle: Bool?
}
@Model
class UserData {
    var id: String?
    var firstName: String?
    var LastName: String?
//    var location: Location
    var email: String?
    var telNumber: String?
    var withGoogle: Bool?
    
    init(id: String? = nil, firstName: String? = nil, LastName: String? = nil, email: String? = nil, telNumber: String? = nil, withGoogle: Bool? = nil) {
        self.id = id
        self.firstName = firstName
        self.LastName = LastName
//        self.location = location
        self.email = email
        self.telNumber = telNumber
        self.withGoogle = withGoogle
    }
}
class UserDataViewModel: ObservableObject {
    @Published var currentUser: UserData?

    private let db = Firestore.firestore()

    func fetchUserData(forUser user: User?) {
        guard let user = user else {
            return
        }

        db.collection("user").whereField("email", isEqualTo: user.email!).getDocuments { snapshot, error in
            if let error = error {
                print("Error fetching user data: \(error.localizedDescription)")
                return
            }

            if let document = snapshot?.documents.first {
                let userID = document.documentID
                print("User ID: \(userID)")
                self.currentUser = UserData(
                    id: userID,
                    firstName: document["firstName"] as? String,
                    LastName: document["LastName"] as? String,
//                    location: document["location"] as? Location,
                    email: document["email"] as? String,
                    telNumber: document["telNumber"] as? String,
                    withGoogle: document["withGoogle"] as? Bool
                )
            }
        }
    }
}
