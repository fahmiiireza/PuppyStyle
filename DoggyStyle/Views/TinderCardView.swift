//
//  TinderCardView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 13/12/23.
//

import SwiftUI

struct TinderCardView: View {
    
    @Environment(BackgroundLogic.self) private var backgroundLogic
    var dog: Dog
   var breeds = ["Golden Retriever", "Border Collie", "Boxer"]
    
    var body: some View {
        
        ZStack(){
            
            VStack(alignment: .leading, spacing: 0){
                    Text(dog.name)
                        .font(.title)
                    .bold()
                       
                    AsyncImage(url: URL(string: "https://hips.hearstapps.com/hmg-prod/images/dog-puppy-on-garden-royalty-free-image-1586966191.jpg?crop=0.752xw:1.00xh;0.175xw,0&resize=1200:*")) { Image in
                        Image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .containerRelativeFrame(.vertical, { size, _ in
                                size * 0.6
                            })
                            .containerRelativeFrame(.horizontal, { size, _ in
                                size * 0.8
                            })
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                            .onAppear(perform: {
                                withAnimation {
                                    backgroundLogic.backgroundImage = Image
                                }
                                
                            })
                            
                            
                        
                    } placeholder: {
                        ProgressView("Loading")
                    }
                Text(breeds.joined(separator: " ‧ "))
                    .foregroundStyle(.white.opacity(0.8))
                    .font(.headline)
                    .padding()
                }
                
            Spacer()
        }
        
        
        
        

    }
}

#Preview {
    TinderCardView(dog: Dog(imageNames: ["String"], name: "Nalu", gender: "", breed: "", age: "12", weight: "", size: "", allergies: "", vaccination: "", chronicdeseases: "", lastvetvisit: "", lenth: "", energylevel: "", friendliness: "", travelinglevel: ""))
}
