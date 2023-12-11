//
//  MyDogsView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 06/12/23.
//

import SwiftUI
import SwiftData

struct MyDogsView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Bindable var backgroundLogic: BackgroundLogic
    @Environment(DummyDogData.self) private var dummyDogData
    @Query private var dogs: [Dog]
    
    var body: some View {
        NavigationStack(path: $backgroundLogic.path) {
            ScrollView{
                
                if !dogs.isEmpty{
                    ForEach(dogs){ dog in
                        NavigationLink {
                            OwnDogView(backgroundLogic: backgroundLogic, dog: dog)
                        } label: {
                            DogCardView(dog: dog)
                                .contextMenu{
                                    Button("Remove Dog", role: .destructive){
                                        withAnimation(.linear){
                                            try? modelContext.delete(dog)
                                        }                                    }
                                }
                        }
                        
                    }
                }else{
                    Text("No Dogs yet")
                }

            }
            .contentMargins(20, for: .scrollContent)
            .sheet(isPresented: $backgroundLogic.addDogSheetPresented, content: {
                CreateNewDogView(dummyDoggy: dummyDogData, dog: Dog(imageNames: [""], name: "", gender: "", breed: "", age: "", weight: "", size: "", allergies: "", vaccination: "", chronicdeseases: "", lastvetvisit: "", lenth: "", energylevel: "", friendliness: "", travelinglevel: ""))
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
            .navigationTitle("My Dogs")
        }
    }
}

#Preview {
    MyDogsView(backgroundLogic: BackgroundLogic())
        .environment(DummyDogData())
}
