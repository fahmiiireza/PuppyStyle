//
//  StrangerDogView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 16/12/23.
//

import SwiftUI
import PhotosUI
import FirebaseFirestore
import FirebaseAuth

struct StrangerDogView: View {
    
    @Environment(\.dismiss) private var dismiss
    @StateObject private var userDataViewModel = UserDataViewModel()
    @State private var profilePicture: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @Binding var user: User?
    var dog: Dog
    
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
                    HStack(){
                            Image(uiImage: profilePicture ?? .placeholderDog)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                            
                            
                        
                        VStack(alignment: .leading, spacing: 0){
                            Text(userDataViewModel.currentUser?.firstName ?? "")
                                .font(.title2)
                                .bold()
//                            Text("📍\(userDataViewModel.currentUser?.location ?? "No Location Found")")
                        }
                        Spacer()
                    }
                    .padding()
                }
                
                VStack(alignment: .leading){
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
            }
            .ignoresSafeArea(edges: .top)
            .toolbar{
                ToolbarItem(placement: .cancellationAction) {
                    Button("Back"){
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    StrangerDogView(user: .constant(.none), dog: Dog(documentId: "", imageNames: ["String"], name: "Nalu", gender: "", breed: "", age: "12", weight: "", size: "", allergies: "", vaccination: "", chronicdeseases: "", lastvetvisit: "", lenth: "", energylevel: "", friendliness: "", travelinglevel: ""))
}
