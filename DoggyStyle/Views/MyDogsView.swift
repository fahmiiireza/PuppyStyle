//
//  MyDogsView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 06/12/23.
//

import SwiftUI

struct MyDogsView: View {
    
    @Bindable var backgroundLogic: BackgroundLogic
    
    var body: some View {
        NavigationStack(path: $backgroundLogic.path) {
            ScrollView{
                
                Button(action: {
                    
                }, label: {
                    DogCardView()
                })
                
                    
            }
            .sheet(isPresented: $backgroundLogic.sheetPresented, content: {
                CreateNewDogView()
            })
            .toolbar(content: {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        backgroundLogic.sheetPresented = true
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
