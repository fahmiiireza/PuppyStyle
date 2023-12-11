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
    
    @Environment(\.dismiss) private var dismiss
    @Environment(DummyDogData.self) private var dummyDog
    @Bindable var dummyDoggy: DummyDogData
    
    var body: some View {
        NavigationStack {
//                if dummyDog.images.isEmpty{
//                    Divider()
//                    ImageCropperView()
//                        .containerRelativeFrame(.vertical){ size, _ in
//                            size * 0.2
//                        }
//                    
//                }else{
//                    TabView{
//                        ForEach(dummyDog.images, id: \.self){ image in
//                            Image(uiImage: image)
//                                .resizable()
//                                .aspectRatio(contentMode: .fill)
//                        }
//                    }
//                    .containerRelativeFrame(.vertical){ size, _ in
//                        size * 0.2
//                    }
//                    .clipped()
//                    .tabViewStyle(.page)
//                }
                List {
                    Section {
                        if dummyDog.images.isEmpty{
                            ImageCropperView()
                        }else{
                            Text("Images uploaded: \(dummyDog.images.count)")
                        }
                    }
                    Section(header: Text("General Information")) {
                        TextField("Name", text: $dummyDoggy.name)
                        TextField("Gender", text: $dummyDoggy.gender)
                        TextField("Breed", text: $dummyDoggy.breed)
                        TextField("Age", text: $dummyDoggy.age)
                            .keyboardType(.decimalPad)
                        TextField("Weight", text: $dummyDoggy.weight)
                            .keyboardType(.numberPad)
                        TextField("Size", text: $dummyDoggy.size)
                            .keyboardType(.numberPad)
                        TextField("Lenth", text: $dummyDoggy.lenth)
                            .keyboardType(.numberPad)
                    }
                    
                    
                    Section(header: Text("Medical Information")) {
                        TextField("Allergies", text: $dummyDoggy.allergies )
                        TextField("Vaccination", text: $dummyDoggy.vaccination )
                        TextField("Chronic deseases", text: $dummyDoggy.chronicdeseases )
                        TextField("Last vet visit", text: $dummyDoggy.lastvetvisit)
                            .datePickerStyle(GraphicalDatePickerStyle())
                    }
                    Section(header: Text("Сharacter")) {
                        TextField("Energy level", text: $dummyDoggy.energylevel)
                        TextField("Friendliness", text: $dummyDoggy.friendliness)
                        TextField("Traveling level", text: $dummyDoggy.travelinglevel)
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


#Preview {
    CreateNewDogView(dummyDoggy: DummyDogData())
        .environment(DummyDogData())
}
