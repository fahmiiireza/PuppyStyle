//
//  DogCardView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 06/12/23.
//

import SwiftUI

struct DogCardView: View {
    var body: some View {
        
            ZStack(alignment: .bottomLeading){
                
                Image("PlaceholderDog")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 200)
                    
                Text("Name")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)
                    .shadow(radius: 10)
                    .padding(5)
                
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding()
            
        
    }
}

#Preview {
    DogCardView()
}
