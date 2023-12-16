//
//  TinderCardView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 13/12/23.
//

import SwiftUI

struct TinderCardView: View {
    
    var dog: Dog
    @State private var image = Image(.placeholderProfile)
    let urls = [URL(string: "https://hips.hearstapps.com/hmg-prod/images/dog-puppy-on-garden-royalty-free-image-1586966191.jpg?crop=0.752xw:1.00xh;0.175xw,0&resize=1200:*")!, URL(string: "https://www.thesprucepets.com/thmb/y4YEErOurgco9QQO-zJ6Ld1yVkQ=/3000x0/filters:no_upscale():strip_icc()/english-dog-breeds-4788340-hero-14a64cf053ca40f78e5bd078b052d97f.jpg")!, URL(string: "https://hips.hearstapps.com/hmg-prod/images/closeup-of-a-black-russian-tsvetnaya-bolonka-royalty-free-image-1681161235.jpg?crop=0.563xw:1.00xh;0.204xw,0&resize=1200:*")!]
    
    var body: some View {
        
        AsyncImage(url: URL(string: dog.imageURLs.first ?? "https://wiki.dave.eu/images/4/47/Placeholder.png")) { phase in
            if let image = phase.image {
                image
                    .resizable()
                        .aspectRatio(contentMode: .fill)
                        .containerRelativeFrame(.vertical, { size, _ in
                            size * 0.6
                        })
                        .containerRelativeFrame(.horizontal, { size, _ in
                            size * 0.8
                        })
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                
                // Displays the loaded image.
            } else if phase.error != nil {
                EmptyView() // Indicates an error.
            } else {
                EmptyView() // Acts as a placeholder.
            }
        }
        
        
//                AsyncImage(url: urls.randomElement()) { image in
//                        image.resizable()
//                            .aspectRatio(contentMode: .fill)
//                            .containerRelativeFrame(.vertical, { size, _ in
//                                size * 0.6
//                            })
//                            .containerRelativeFrame(.horizontal, { size, _ in
//                                size * 0.8
//                            })
//                            .clipShape(RoundedRectangle(cornerRadius: 20))
//                            
////                            .onChange(of: backgroundLogic.scrollPosition?.name, {
////                                print(backgroundLogic.scrollPosition?.name)
//////                                withAnimation(.linear(duration: 0.2)) {
////                                    backgroundLogic.backgroundImage = imageBG
//////                                }
////                            })
//
//                            
//                        
//                    } placeholder: {
//                        EmptyView()
//                    }
    }
}

#Preview {
    TinderCardView(dog: Dog(imageNames: ["String"], name: "Nalu", gender: "", breed: "", age: "12", weight: "", size: "", allergies: "", vaccination: "", chronicdeseases: "", lastvetvisit: "", lenth: "", energylevel: "", friendliness: "", travelinglevel: ""))
}
