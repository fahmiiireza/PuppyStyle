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
    @Environment(BackgroundLogic.self) private var backgroundLogic
    @Bindable var dummyDoggy: DummyDogData
    @State var dog: Dog
    
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
                        TextField("Name", text: $dog.name)
                        TextField("Gender", text: $dog.gender)
                        TextField("Breed", text: $dog.breed)
                        TextField("Age", text: $dog.age)
                            .keyboardType(.decimalPad)
                        TextField("Weight", text: $dog.weight)
                            .keyboardType(.numberPad)
                        TextField("Size", text: $dog.size)
                            .keyboardType(.numberPad)
                        TextField("Lenth", text: $dog.length)
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
    }
}


//#Preview {
//    CreateNewDogView(dummyDoggy: DummyDogData())
//        .environment(DummyDogData())
//}
