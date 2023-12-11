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
    func getAPIKey() -> String? {
        return Bundle.main.object(forInfoDictionaryKey: "NINJA_API_KEY") as? String
    }
    @State private var dogData : [DogApi] = []

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
                    
                    ForEach(dogData){ dog in
                        Text("dog.name\(dog.name)") //THIS IS

//                        AsyncImage(url: dog.image.url)
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
            await callApi()
        }
        
    }
    
    private func callApi() async {
        
        guard let apiKey = getAPIKey() else {
            return
        }
            let parameters = [
                "page": 0,
                "limit": 5
            ] as [String : Any]
        let headers = ["x-api-key": apiKey]
            var urlComponents = URLComponents(string: "https://api.thedogapi.com/v1/breeds?limit=100&page=0")!


            var request = URLRequest(url: (urlComponents.url)!)
            request.httpMethod = "GET"

            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        
            do {
                let (data,_) = try await URLSession.shared.data(for: request)
                
                let dogs = try JSONDecoder().decode([DogApi].self, from: data)
                dogData = dogs
            } catch {
                print(error)
            }
    }
    
}

#Preview {
    SearchView(backroundLogic: BackgroundLogic())
}

