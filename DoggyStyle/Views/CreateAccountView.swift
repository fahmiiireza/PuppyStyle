//
//  CreateAccountView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 16/12/23.
//

import SwiftUI
import FirebaseFirestore
import SwiftData
import FirebaseAuth
import PhotosUI
import FirebaseStorage

struct CreateAccountView: View {
    
    enum ImageUploadError: Error {
        case imageConversionFailed
        case uploadFailed
        case urlRetrievalFailed
    }
    
    var locationViewModel = MapViewModel()
    @State private var profilePicture: UIImage = .placeholderProfile
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var location: Location?
    @State private var telNr = ""
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var profilePictureUrl: String = ""
    @StateObject private var userDataViewModel = UserDataViewModel()


    var body: some View {
        NavigationStack{
            Form{
                PhotosPicker(selection: $photosPickerItem, matching: .images) {
                    Image(uiImage: profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                }
                
                TextField("First Name", text: $firstName)
                    .textContentType(.givenName)
                TextField("Last Name", text: $lastName)
                    .textContentType(.familyName)
                TextField("Tel. Number", text: $telNr)
                Button("Save") {
                    saveUserData(firstName: firstName, lastName: lastName, telNr: telNr, profilePictureUrl: profilePictureUrl)
                }
                .onChange(of: photosPickerItem) { _, _ in
                    Task {
                        if let photosPickerItem = photosPickerItem,
                           let data = try? await photosPickerItem.loadTransferable(type: Data.self),
                           let image = UIImage(data: data),
                           let email = Auth.auth().currentUser?.email {
                            uploadProfileImage(image, forUser: email) { result in
                                switch result {
                                case .success(let url):
                                    updateUserProfilePictureUrl(url, forEmail: email) { result in
                                        switch result {
                                        case .success():
                                            print("Profile picture updated successfully")
                                        case .failure(let error):
                                            print("Error updating profile picture URL: \(error.localizedDescription)")
                                        }
                                    }
                                case .failure(let error):
                                    print("Error uploading profile picture: \(error.localizedDescription)")
                                }
                            }
                        }
                    }
                }
            }
        }
        .task {
            await locationViewModel.checkIfLocationServiceIsEnabled()
        }
    }
    
    func uploadProfileImage(_ image: UIImage, forUser userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(ImageUploadError.imageConversionFailed))
            return
        }

        let storageRef = Storage.storage().reference().child("profile_images/\(userId).jpg")

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard metadata != nil else {
                completion(.failure(error ?? ImageUploadError.uploadFailed))
                return
            }

            storageRef.downloadURL { url, error in
                if let url = url {
                    completion(.success(url.absoluteString))
                } else {
                    completion(.failure(error ?? ImageUploadError.urlRetrievalFailed))
                }
            }
        }
    }
    
    func updateUserProfilePictureUrl(_ url: String, forEmail: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("user").document(forEmail).updateData(["profilePictureUrl": url]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }

    
    func saveUserData(firstName: String, lastName: String, telNr: String, profilePictureUrl: String) {
         let userId = Auth.auth().currentUser?.email ?? ""

        
        let userData: [String: Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "telNumber": telNr,
            "profilePictureUrl": profilePictureUrl
        ]


        let db = Firestore.firestore()
        db.collection("user").document(userId).setData(userData) { error in
            if let error = error {
                print("Error writing document: \(error)")
            } else {
                print("aeee")
            }
        }
    }
    
}

#Preview {
    CreateAccountView()
}
