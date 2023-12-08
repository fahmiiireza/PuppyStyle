//
//  SearchView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 07/12/23.
//

import SwiftUI

struct SearchView: View {
    
    @Bindable var backroundLogic: BackgroundLogic
    let layout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        NavigationStack{
            ScrollView{
                HStack(alignment: .bottom) {
                    
                    Text("Search")
                        .font(.largeTitle)
                        .bold()
                        
                    Spacer()
                    
                    Button(action: {
                        backroundLogic.profileSheetPresented = true
                    }, label: {
                        Image("Appicon")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .clipShape(Circle())
                            .frame(height: 40)
                    })
                    
                        
                }
                .padding([.horizontal, .top])
                
                
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
            .sheet(isPresented: $backroundLogic.profileSheetPresented, content: {
                
                //Later handle if User is signed in
                
                //if user not signed in:
                SignUpView()
                
                //if user is Signed in:
                
            })
            .toolbar(content: {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {}, label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    })
                }
                
            })
            
            
        }
        
    }
}

#Preview {
    SearchView(backroundLogic: BackgroundLogic())
}
