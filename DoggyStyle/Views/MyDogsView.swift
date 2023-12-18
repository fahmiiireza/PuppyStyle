//
//  MyDogsView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 06/12/23.
//

import SwiftUI
import SwiftData
import FirebaseFirestore

struct MyDogsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Bindable var backgroundLogic: BackgroundLogic
    @StateObject private var dogsViewModel = DogsViewModel()
    
    func deleteDogFromFirestore(documentId: String) {
        let db = Firestore.firestore()
        db.collection("dog").document(documentId).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Dog removed")
            }
        }
    }

    var body: some View {
        NavigationStack(path: $backgroundLogic.path) {
            ScrollView{
                
                if !dogsViewModel.dogs.isEmpty{
                    ForEach(dogsViewModel.dogs, id: \.self){ dog in
                        NavigationLink {
                            OwnDogView(backgroundLogic: backgroundLogic, dog: dog)
                        } label: {
                            DogCardView(dog: dog)
                                .contextMenu{
                                    Button("Remove Dog", role: .destructive){
                                        withAnimation(.linear){
                                            if let documentId = dog.documentId {
                                                   deleteDogFromFirestore(documentId: documentId)
                                               }                                        }                                    }
                                }
                                .padding(.bottom)
                        }
                        
                    }
                }else{
                    Text("No Dogs yet")
                }


            }.onAppear(perform: dogsViewModel.fetchDogs)
            .contentMargins(20, for: .scrollContent)
            .sheet(isPresented: $backgroundLogic.addDogSheetPresented, content: {
                CreateNewDogView(dog: Dog(documentId: "", imageNames: [""], name: "", gender: "", breed: "", age: "", weight: "", size: "", allergies: "", vaccination: "", chronicdeseases: "", lastvetvisit: "", lenth: "", energylevel: "", friendliness: "", travelinglevel: ""))
            })
            .toolbar(content: {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        backgroundLogic.addDogSheetPresented = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            })
            .navigationTitle(Text(dogsViewModel.dogs.count > 1 ? "My Dogs" : "My Dog"))
        }
    }
}

#Preview {
    MyDogsView(backgroundLogic: BackgroundLogic())
}
