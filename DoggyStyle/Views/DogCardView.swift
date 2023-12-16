//
//  DogCardView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 06/12/23.
//

import SwiftUI

struct DogCardView: View {
    
    var dog: Dog
    
    var body: some View {
        
            ZStack(alignment: .bottomLeading){

                if dog.imageData.isEmpty == false{
                    
                    Image(uiImage: UIImage(data: dog.imageData.first!)!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .containerRelativeFrame(.vertical) { size, _ in
                            size * 0.4
                        }
                    
                }else{
                    Image(.placeholderDog)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 200)
                    
                }
                //Image(uiImage: UIImage(data: dog.imageData![0]) ?? UIImage(resource: .placeholderDog))
                
///               AsyncImage(url: URL(string: "https://i.ibb.co/JckmsK9/IMG-6035.jpg")) { image in
//                    image.resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(height: 200)
//                        
//                        
//                } placeholder: {
//                    Image("PlaceholderDog")
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(height: 200)
//                        .overlay{
//                            ZStack{
//                                Color.black.opacity(0.4)
//                                ProgressView()
//                                    .foregroundColor(.white)
//                            }
//                        }
//                }

                
//                Image(dog.imageURLs.first ?? "PlaceholderDog")
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(height: 200)
                    
                Text(dog.name)
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)
                    .shadow(radius: 10)
                    .padding(5)
                    .multilineTextAlignment(.leading)
                
            }
            .clipShape(RoundedRectangle(cornerRadius: 20))
            
            
            
        
    }
}

//#Preview {
//    DogCardView(dog: Dog(backingData: <#BackingData<Dog>#>))
//}
