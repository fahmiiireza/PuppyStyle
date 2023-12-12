//
//  BreedSearchingListView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 12/12/23.
//

import SwiftUI

struct BreedSearchingListView: View {
    
    @State private var searchText = ""
    var dog: DogApi // needs to be changed with breed
    var body: some View {
        
        List{
            Text("Hund")
            Text("Hund")
            Text("Hund")
            Text("Hund")
            Text("Hund")
            Text("Hund")
        }
        .searchable(text: $searchText)
            .navigationTitle(Text("\(dog.name)"))
            .navigationBarTitleDisplayMode(.large)
            
    }
}

//#Preview {
//    BreedSearchingListView(dog: )
//}
