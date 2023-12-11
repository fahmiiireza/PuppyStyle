//
//  CreateNewDogView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 06/12/23.
//
//

import SwiftUI
import FirebaseAuth


struct CreateNewDogView: View {
    @State private var handle: AuthStateDidChangeListenerHandle?
    @State private var user: User?
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(DummyDogData.self) private var dummyDog
    @Bindable var dummyDoggy: DummyDogData
    @State var dog: Dog
    
    var body: some View {
        NavigationStack {
                List {
                    Section {
                        if dog.imageData.isEmpty{
                            ImageCropperView(dog: dog)
                        }else{
                            Text("Images uploaded: \(dog.imageData.count)")
                        }
                    }
                    Section(header: Text("General Information")) {
                        TextField("Name", text: $dog.name)
                        TextField("Gender", text: $dog.gender)
                        TextField("Breed", text: $dog.breed)
                        TextField("Age", text: $dog.age)
                            .keyboardType(.decimalPad)
                        TextField("Weight", text: $dog.weight)
                            .keyboardType(.numberPad)
                        TextField("Size", text: $dog.size)
                            .keyboardType(.numberPad)
                        TextField("Lenth", text: $dog.lenth)
                            .keyboardType(.numberPad)
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
                            modelContext.insert(dog)
                            // Handle the creation of the new dog with the entered information
                            //                        _ = Dog(name: name, breed: breed, age: age, weight: weight, size: size)
                            // Add logic to handle the new dog data!!
                            
                            // Dismiss the sheet after handling the data
                            dismiss.callAsFunction()
                        }
                    }
                }
                .navigationTitle("Create New Dog")
                .navigationBarTitleDisplayMode(.inline)
            
            .task {
                print(handle ?? "tset")
                handle = Auth.auth().addStateDidChangeListener { auth, user in
                    if let user = user {
                        // User is signed in
                        self.user = user
                        
                        print("User is signed in: \(user.email ?? "email")")
                    } else {
                        // User is signed out
                        print("User is signed out")
                    }            }
                print(handle!)
            }
        }
    }
}


//#Preview {
//    CreateNewDogView(dummyDoggy: DummyDogData())
//        .environment(DummyDogData())
//}
