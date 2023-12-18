//
//  MyDogsView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 06/12/23.
//

import SwiftUI
import FirebaseFirestore

struct OwnDogView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Bindable var backgroundLogic: BackgroundLogic
    
    var dog : Dog
    
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
        
       
        NavigationStack{
            ScrollView {
                LazyVStack(spacing: 0){
                    TabView {
                            if (dog.imageData.isEmpty){
                                Text("NO IMAGES")
                                    .bold()
                            }else{
                                ForEach(dog.imageData, id: \.self){ image in
                                    
                                    Image(uiImage: UIImage(data: image)!)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                    
                                }
                            }
                    }
                    .containerRelativeFrame(.vertical){ size, _  in
                        size * 0.45
                    }
                    .clipped()
                    .tabViewStyle(.page(indexDisplayMode: .automatic))
                    .overlay(alignment: .bottomLeading, content: {
                        Text(dog.name)
                            .foregroundStyle(.white)
                            .font(.largeTitle)
                            .bold()
                            .shadow(radius: 10)
                            .padding(.horizontal)
                            
                    })
                    
                }
                
                LazyVStack(alignment: .leading){
                    HStack{
                        Image(systemName: "pawprint")
                        Text("General Information")
                    }
                    .font(.title2)
                    .bold()
                    
                    
                    VStack(alignment: .leading){
                        Text("Breed")
                            .font(.headline)
                        NavigationLink("Breed"){
                            CreateNewDogView(dog: Dog(documentId: "", imageNames: [""], name: "", gender: "", breed: "", age: "", weight: "", size: "", allergies: "", vaccination: "", chronicdeseases: "", lastvetvisit: "", lenth: "", energylevel: "", friendliness: "", travelinglevel: ""))
                        }
                        Text("Age")
                            .font(.headline)
                        Text(dog.age)
                            .foregroundStyle(.secondary)
                            .font(.callout)
                        Text("Gender")
                            .font(.headline)
                        Text(dog.gender)
                            .foregroundStyle(.secondary)
                            .font(.callout)
                        Text("Weith & size & lenth")
                            .font(.headline)
                        Text("\(dog.weight), \(dog.size) + \(dog.length)")
                            .foregroundStyle(.secondary)
                            .font(.callout)
                        
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 10).foregroundStyle(.thickMaterial))

                    HStack{
                        Image(systemName: "stethoscope")
                        Text("Medical Information")
                    }
                    .font(.title2)
                    .bold()
                    
                    
                    VStack(alignment: .leading){
                        Text("Allergies")
                            .font(.headline)
                        Text(dog.allergies)
                            .foregroundStyle(.secondary)
                            .font(.callout)
                        Text("Last Vet Visit")
                            .font(.headline)
                        Text(dog.lastvetvisit)
                            .foregroundStyle(.secondary)
                            .font(.callout)
                        Text("Vaccinations")
                            .font(.headline)
                        Text(dog.vaccination)
                            .foregroundStyle(.secondary)
                            .font(.callout)
                        
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background( RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(.thickMaterial))
                    }
                .padding()
                Button("Remove this Dog"){
                    if let documentId = dog.documentId {
                           deleteDogFromFirestore(documentId: documentId)
                       }
                    dismiss()
                }
            }
            .ignoresSafeArea(edges: .top)
        }
    }
}


//#Preview {
//    OwnDogView(backgroundLogic: BackgroundLogic(), dog: Dog(name: "Nalu"))
//        .environment(DummyDogData())
//}
