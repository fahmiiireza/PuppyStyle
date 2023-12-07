//
//  MyDogsView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 06/12/23.
//

import SwiftUI

struct OwnDogView: View {
    
    @Bindable var backgroundLogic: BackgroundLogic
    var dog : Dog
    
    var body: some View {
            ScrollView{
                GeometryReader{ geometry in
                    
                    ZStack(alignment: .bottom){
                        if geometry.frame(in: .global).minY <= 0{
                            
                            Image("PlaceholderDog")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: getHeaderHeight(for: geometry))
                                .clipped()
                                .offset(y: getHeaderOffset(for: geometry))
                                .overlay(alignment: .bottomLeading) {
                                    Text(dog.name)
                                        .foregroundStyle(.white)
                                        .font(.largeTitle)
                                        .bold()
                                        .shadow(color: .black, radius: 10)
                                        .padding()
                                        
                                }
                            
                            
                        }else{
                            
                            Image("PlaceholderDog")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: geometry.size.width, height: getHeaderHeight(for: geometry))
                                .clipped()
                                .offset(y: getHeaderOffset(for: geometry))
                                
                            
                            
                        }
                    }
                    
                }.frame(height: 500)
                
                VStack{
                    ForEach(1..<100){ i in
                        Text("Hello \(i)")
                    }
                }
                
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(content: {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        
                    } label: {
                        ZStack{
                            Circle()
                                .foregroundStyle(.ultraThickMaterial)
                                .frame(width: 25)
                            Image(systemName: "plus")
                                .font(.caption)
                                .bold()
                        }
                    }

                }
                ToolbarItem(placement: .navigation) {
                    Button {
                        backgroundLogic.path.removeLast()
                    } label: {
                        ZStack{
                            Circle()
                                .foregroundStyle(.ultraThickMaterial)
                                .frame(width: 25)
                            Image(systemName: "chevron.backward")
                                .font(.caption)
                                .bold()
                        }
                    }

                }
                
        })
        
       // .ignoresSafeArea()
    }
    
    private func getHeaderHeight(for geometry: GeometryProxy) -> CGFloat {
            let offset = geometry.frame(in: .global).minY
            return offset <= 0 ? 500 : 500 + abs(offset)
        }

        private func getHeaderOffset(for geometry: GeometryProxy) -> CGFloat {
            let offset = geometry.frame(in: .global).minY
            return offset <= 0 ? 0 : -offset
        }
}

#Preview {
    OwnDogView(backgroundLogic: BackgroundLogic(), dog: Dog(name: "Nalu"))
}
