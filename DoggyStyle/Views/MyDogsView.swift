//
//  MyDogsView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 06/12/23.
//

import SwiftUI

struct MyDogsView: View {
    
    @Bindable var backgroundLogic: BackgroundLogic
    @Environment(DummyDogData.self) private var dummyDogData
    
    var body: some View {
        NavigationStack {
            ScrollView{
                NavigationLink {
                    OwnDogView(backgroundLogic: backgroundLogic, dog: Dog(name: "Nalu"))
                } label: {
                    DogCardView()
                }

            }
            .sheet(isPresented: $backgroundLogic.addDogSheetPresented, content: {
                CreateNewDogView(dummyDoggy: dummyDogData)
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
        .environment(BackgroundLogic())
}
