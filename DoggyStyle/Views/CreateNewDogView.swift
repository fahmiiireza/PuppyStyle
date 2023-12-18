//
//  CreateNewDogView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 06/12/23.
//
//

import SwiftUI
import Firebase
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

struct CreateNewDogView: View {
    @Binding var newlyCreated: Bool
    @State private var breeds: [String] = []
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(BackgroundLogic.self) private var backgroundLogic
    @State var dog: Dog
    @State private var createDisabled = true
    
    
    func uploadImages(_ imageDataArray: [Data], completion: @escaping ([String]) -> Void) {
        let storageRef = Storage.storage().reference()
        var uploadedUrls: [String] = []
        let uploadGroup = DispatchGroup()

        for imageData in imageDataArray {
            uploadGroup.enter()
            let imageName = UUID().uuidString
            let imageRef = storageRef.child("dog_images/\(imageName).jpg")

            imageRef.putData(imageData, metadata: nil) { metadata, error in
                guard error == nil else {
                    print("Failed to upload image: \(error!.localizedDescription)")
                    uploadGroup.leave()
                    return
                }
                imageRef.downloadURL { url, error in
                    guard let downloadURL = url else {
                        print("Download URL not found")
                        uploadGroup.leave()
                        return
                    }
                    uploadedUrls.append(downloadURL.absoluteString)
                    uploadGroup.leave()
                }
            }
        }

        uploadGroup.notify(queue: .main) {
            completion(uploadedUrls)
        }
    }
    
    func saveDogToFirestore(dog: Dog) {
        let db = Firestore.firestore()
        var dogData: [String: Any] = [
            "name": dog.name,
            "gender": dog.gender,
            "breed": breeds.joined(separator: " ‧ "),
            "age": dog.age,
            "weight": dog.weight,
            "size": dog.size,
            "length": dog.length,
            "allergies": dog.allergies,
            "vaccination": dog.vaccination,
            "chronicdeseases": dog.chronicdeseases,
            "lastvetvisit": dog.lastvetvisit,
            "energylevel": dog.energylevel,
            "friendliness": dog.friendliness,
            "travelinglevel": dog.travelinglevel,
            "imageURLs": dog.imageURLs, // Assuming these are URLs of uploaded images
            "user_id": Auth.auth().currentUser?.uid ?? "" // Set the user ID
        ]

        if !dog.imageURLs.isEmpty {
            dogData["imageURLs"] = dog.imageURLs
        }

        // Handle image uploading if necessary, then get URLs to store in Firestore

        db.collection("dog").addDocument(data: dogData) { error in
            if let error = error {
                print("Error adding document: \(error)")
            } else {
                print("Document added with ID: \(dogData)")
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if backgroundLogic.imageDataArray.isEmpty{
                        ImageCropperView(dog: dog)
                    }else{
                        Text("Images uploaded: \(backgroundLogic.imageDataArray.count)")
                    }
                }
                
                Section(header: Text("General Information")) {
                   // TextField("Image URLS", text: $dog.imageURLs.first!)
                    TextField("Name", text: $dog.name)
                    Picker("Gender", selection: $dog.gender) {
                        Text("Male").tag("Male")
                        Text("Female").tag("Female")
                    }
                    
                    NavigationLink {
                        BreedSelectionView(selectedBreeds: $breeds)
                    } label: {
                        Text(breeds.isEmpty ? "Choose Breeds" : breeds.joined(separator: " ‧ "))
                            .foregroundStyle(breeds.isEmpty ? .accent : .primary)
                    }

                    TextField("Age", text: $dog.age)
                        .keyboardType(.numberPad)
                    TextField("Weight", text: $dog.weight)
                        .keyboardType(.decimalPad)
                    TextField("Size", text: $dog.size)
                        .keyboardType(.decimalPad)
                    TextField("Lenth", text: $dog.length)
                        .keyboardType(.decimalPad)
                }
                
                
                Section(header: Text("Medical Information")) {
                    TextField("Allergies", text: $dog.allergies )
                    TextField("Vaccination", text: $dog.vaccination )
                    TextField("Chronic deseases", text: $dog.chronicdeseases )
                    TextField("Last vet visit", text: $dog.lastvetvisit)
                        .datePickerStyle(GraphicalDatePickerStyle())
                }
                Section(header: Text("Сharacter")) {
                    TextField("Energy level", text: $dog.energylevel)
                    TextField("Friendliness", text: $dog.friendliness)
                    TextField("Traveling level", text: $dog.travelinglevel)
                }
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss.callAsFunction()
                    }
                    
                }
                
                ToolbarItem(placement: .primaryAction) {
                    Button("Done") {
                        //                            saveDogToFirestore(dog: dog)
                        //                            dog.imageData = backgroundLogic.imageDataArray
                        //                            modelContext.insert(dog)
                        //                            backgroundLogic.imageDataArray = []
                        //                            dismiss()
                        uploadImages(backgroundLogic.imageDataArray) { uploadedUrls in
                            var updatedDog = dog
                            updatedDog.imageURLs = uploadedUrls
                            saveDogToFirestore(dog: updatedDog)
                            backgroundLogic.imageDataArray.removeAll()
                            dismiss()
                            newlyCreated = true
                            
                        }
                    }
                    .disabled(dog.allergies.isEmpty || dog.gender.isEmpty || dog.name.isEmpty || dog.lastvetvisit.isEmpty || dog.vaccination.isEmpty || dog.age.isEmpty || dog.length.isEmpty || dog.size.isEmpty || dog.weight.isEmpty || dog.breed.isEmpty)
//                    .onChange(of: dog) {
//                        if dog.allergies.isEmpty || dog.gender.isEmpty || dog.name.isEmpty || dog.lastvetvisit.isEmpty || dog.vaccination.isEmpty || dog.age.isEmpty || dog.length.isEmpty || dog.size.isEmpty || dog.weight.isEmpty || dog.breed.isEmpty {
//                            
//                            createDisabled = true
//                        }else{
//                            createDisabled = false
//                        }
//                    }
                }
                
            }
            .navigationTitle("Create New Dog")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear{
            dog.gender = "male"
        }
        .onChange(of: breeds) {
            dog.breed = breeds.joined(separator: " ‧ ")
        }
    }
}


//#Preview {
//    CreateNewDogView(dog: Dog(documentId: "", imageNames: [""], name: "", gender: "", breed: "", age: "", weight: "", size: "", allergies: "", vaccination: "", chronicdeseases: "", lastvetvisit: "", lenth: "", energylevel: "", friendliness: "", travelinglevel: ""))
//        .environment(BackgroundLogic())
//}
