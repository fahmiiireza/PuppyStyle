//
//  SearchView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 07/12/23.
//

import SwiftUI

struct SearchView: View {
    
    let layout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        NavigationStack{
            ScrollView{
                RoundedRectangle(cornerRadius: 20)
                    .frame(height: 100)
                    .padding(.horizontal)
                    .foregroundStyle(.accent)
                    .overlay(alignment: .center) {
                        Text("Search on map")
                            .font(.title2)
                            .bold()
                            .foregroundStyle(.white)
                    }
                
                LazyVGrid(columns: layout, content: {
                    
                    ForEach(0..<100){ _ in
                        RoundedRectangle(cornerRadius: 20)
                            .frame(height: 100)
                            .foregroundStyle(.gray)
                    }
                    
                    
                        
                })
                .padding(.horizontal)
            }
            .toolbar(content: {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {}, label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    })
                }
            })
            .navigationTitle("Search")
        }
        
    }
}

#Preview {
    SearchView()
}
