//
//  CreateNewDogView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 06/12/23.
//
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

struct CreateNewDogView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(BackgroundLogic.self) private var backgroundLogic
    @State var dog: Dog
    
    func saveDogToFirestore(dog: Dog) {
        let db = Firestore.firestore()
        let dogData: [String: Any] = [
            "name": dog.name,
            "gender": dog.gender,
            "breed": dog.breed,
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
                        TextField("Image URLS", text: $dog.imageURLs.first!)
                        TextField("Name", text: $dog.name)
                        Picker("Gender", selection: $dog.gender) {
                            Text("Male").tag("Male")
                            Text("Female").tag("Female")
                        }
                            
                        TextField("Breed", text: $dog.breed)
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
                            saveDogToFirestore(dog: dog)
                            dog.imageData = backgroundLogic.imageDataArray
                            modelContext.insert(dog)
                            backgroundLogic.imageDataArray = []
                            dismiss()
                        }
                    }
                }
                .navigationTitle("Create New Dog")
                .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear{
            dog.gender = "male"
        }
    }
}


#Preview {
    CreateNewDogView(dog: Dog(documentId: "", imageNames: [""], name: "", gender: "", breed: "", age: "", weight: "", size: "", allergies: "", vaccination: "", chronicdeseases: "", lastvetvisit: "", lenth: "", energylevel: "", friendliness: "", travelinglevel: ""))
        .environment(BackgroundLogic())
}
