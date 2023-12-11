//
//  MyDogsView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 06/12/23.
//

import SwiftUI

struct OwnDogView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(DummyDogData.self) private var dummyDogData
    @Bindable var backgroundLogic: BackgroundLogic
    var dog : Dog
    
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
                    .overlay(alignment: .bottomLeading, content: {
                        Text(dummyDogData.name)
                            .foregroundStyle(.white)
                            .font(.largeTitle)
                            .bold()
                            .shadow(radius: 10)
                            .padding(.horizontal)
                            
                    })
                    .containerRelativeFrame(.vertical){ size, _  in
                        size * 0.45
                    }
                    .clipped()
                    .tabViewStyle(.page)
                    
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
                        NavigationLink(dummyDogData.breed){
                            CreateNewDogView(dummyDoggy: dummyDogData, dog: Dog(imageNames: [""], name: "", gender: "", breed: "", age: "", weight: "", size: "", allergies: "", vaccination: "", chronicdeseases: "", lastvetvisit: "", lenth: "", energylevel: "", friendliness: "", travelinglevel: ""))
                        }
                        Text("Age")
                            .font(.headline)
                        Text(dummyDogData.age)
                            .foregroundStyle(.secondary)
                            .font(.callout)
                        Text("Gender")
                            .font(.headline)
                        Text(dummyDogData.gender)
                            .foregroundStyle(.secondary)
                            .font(.callout)
                        Text("Weith & size & lenth")
                            .font(.headline)
                        Text("\(dummyDogData.weight), \(dummyDogData.size) + \(dummyDogData.lenth)")
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
                        Text(dummyDogData.allergies)
                            .foregroundStyle(.secondary)
                            .font(.callout)
                        Text("Last Vet Visit")
                            .font(.headline)
                        Text(dummyDogData.lastvetvisit)
                            .foregroundStyle(.secondary)
                            .font(.callout)
                        Text("Vaccinations")
                            .font(.headline)
                        Text(dummyDogData.vaccination)
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
            .ignoresSafeArea()
        }
        
        
        }
}

//#Preview {
//    OwnDogView(backgroundLogic: BackgroundLogic(), dog: Dog(name: "Nalu"))
//        .environment(DummyDogData())
//}
