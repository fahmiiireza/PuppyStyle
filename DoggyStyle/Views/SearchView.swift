//
//  SearchView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 07/12/23.
//

import SwiftUI
import FirebaseAuth

struct SearchView: View {
    
    @State private var handle: AuthStateDidChangeListenerHandle?
    @State private var user: User?
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
            .fullScreenCover(isPresented: $backroundLogic.profileSheetPresented, content: {
                
                //handle if User is signed in
                if (user != nil) {
                    //if user is Signed in:
                    OwnAccountView(user: $user)
                    
                } else {
                    //if user not signed in:
                    SignUpView()
                    
                }
                
                

                
                
                
                
            })
            .toolbar(content: {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {}, label: {
                        Image(systemName: "line.3.horizontal.decrease.circle")
                    })
                }
                
            })
            
            
        }
        .task {
            print(handle ?? "tset")
            handle = Auth.auth().addStateDidChangeListener { auth, user in
                if let user = user {
                    // User is signed in
                    self.user = user

                    print("User is signed in: \(user.email ?? "email")")
                } else {
                    // User is signed out
                    print("User is signed out")
                    self.user = nil
                }            }
            print(handle!)
        }
        
    }
}

#Preview {
    SearchView(backroundLogic: BackgroundLogic())
}
