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

    @State private var name: String = ""
    @State private var gender: String = ""
    @State private var breed: String = ""
    @State private var age: String = ""
    @State private var weight: String = ""
    @State private var size: String = ""
    @State private var allergies: String = ""
    @State private var vaccination: String = ""
    @State private var chronicdeseases: String = ""
    @State private var lastvetvisit: String = ""
    @State private var lenth: String = ""
    @State private var energylevel: String = ""
    @State private var friendliness: String = ""
    @State private var travelinglevel: String = ""

 
    
    var body: some View {
        NavigationStack {
            VStack {
                if let user = user {
                    Text("User ID: \(user.uid)")
                    Text("Email: \(user.email ?? "N/A")")
                    Text("phone: \(user.phoneNumber ?? "N/A")")
                    AsyncImage(url: user.photoURL)
                    
                } else {
                    Text("User not signed in")
                }
            }
            Form {
                Section(header: Text("General Information")) {
                    TextField("Name", text: $name)
                    TextField("Gender", text: $gender)
                    TextField("Breed", text: $breed)
                    TextField("Age", text: $age)
                        .keyboardType(.decimalPad)
                    TextField("Weight", text: $weight)
                        .keyboardType(.numberPad)
                    TextField("Size", text: $size)
                        .keyboardType(.numberPad)
                    TextField("Lenth", text: $lenth)
                        .keyboardType(.numberPad)
                }
                
                
                Section(header: Text("Medical Information")) {
                    TextField("Allergies", text: $allergies )
                    TextField("Vaccination", text: $vaccination )
                    TextField("Chronic deseases", text: $chronicdeseases )
                    TextField("Last vet visit", text: $lastvetvisit )
                        .datePickerStyle(GraphicalDatePickerStyle())
                }
                Section(header: Text("Сharacter")) {
                    TextField("Energy level", text: $energylevel)
                    TextField("Friendliness", text: $friendliness)
                    TextField("Traveling level", text: $travelinglevel)
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
                    .disabled(name.isEmpty || breed.isEmpty || age.isEmpty || weight.isEmpty || size.isEmpty)
                }
            }
            .navigationTitle("Create New Dog")
            .navigationBarTitleDisplayMode(.inline)
        }
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


#Preview {
    CreateNewDogView()
}
