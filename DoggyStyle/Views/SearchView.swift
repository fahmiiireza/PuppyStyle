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
    @State private var dogData : [DogApi] = []
    @FocusState private var focused: FocusedField?
    @Bindable var backroundLogic: BackgroundLogic
    @State private var isSearching = false
    @State private var searchText = ""
    @Namespace private var searchAnimation
    
    let layout = [GridItem(.flexible()), GridItem(.flexible())]
    
    var body: some View {
        
        NavigationStack(path: $backroundLogic.path){
            ScrollView{
                VStack{
                    HStack(alignment: .bottom) {
                        
                        Text("Search")
                            .font(.largeTitle)
                            .bold()
                        
                        Spacer()
                        
                        Button(action: {
                            backroundLogic.profileSheetPresented = true
                        }, label: {
                            Image(.placeholderProfile)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .clipShape(Circle())
                                .frame(height: 35)
                        })
                        
                        
                    }
                    .padding([.horizontal, .top])
                    
                    ///SearchBar
                    
                    if isSearching{
                        HStack(spacing: 0){
                            TextField(text: $searchText) {
                                
                            }
                            .autocorrectionDisabled()
                            .focused($focused, equals: .searchfield)
                            .matchedGeometryEffect(id: "SearchBar", in: searchAnimation)
                            .padding(10)
                            .background(.ultraThickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal)
                            .overlay(alignment: .leading) {
                                if searchText.isEmpty{
                                    Label(
                                        title: { Text("Search breeds") },
                                        icon: { Image(systemName: "magnifyingglass") }
                                    )
                                    .foregroundStyle(.secondary)
                                    .padding(.horizontal, 25)
                                    .allowsHitTesting(false)
                                }
                            }
                            Button(action: {
                                withAnimation(.spring) {
                                    isSearching = false
                                }
                                searchText = ""
                                hideKeyboard()
                            }, label: {
                                Text("Cancel")
                                    .font(.callout)
                            })
                            .padding(.trailing)
                        }
                        
                    }else{
                        TextField(text: $searchText) {
                            
                        }
                        .autocorrectionDisabled()
                        .matchedGeometryEffect(id: "SearchBar", in: searchAnimation)
                        .padding(10)
                        .background(.ultraThickMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .padding(.horizontal)
                        .overlay(alignment: .leading) {
                            if searchText.isEmpty{
                                Label(
                                    title: { Text("Search breeds") },
                                    icon: { Image(systemName: "magnifyingglass") }
                                )
                                .foregroundStyle(.secondary)
                                .padding(.horizontal, 25)
                                .allowsHitTesting(false)
                            }
                        }
                        .onTapGesture {
                            withAnimation(.smooth) {
                                isSearching = true
                            }
                            focused = .searchfield
                            
                        }
                    }
                    
                    
                    
                }
                
                LazyVGrid(columns: layout, content: {
                    
                    ForEach(dogData.filter({"\($0)".contains(searchText.replacingOccurrences(of: "_", with: " ")) || searchText.isEmpty})){ dog in
                        
                        //   AsyncImage(url: dog.image.url)
                        
                        NavigationLink(value: dog) {
                            ZStack{
                                
                                RoundedRectangle(cornerRadius: 20)
                                    .frame(height: 100)
                                    .foregroundStyle(.gray)
                                Text(dog.name)
                                    .foregroundStyle(.white)
                            }
                            .onAppear{
                                print(dog.name)
                            }
                        }
                       
                    }
                })
                .padding(.horizontal)
            }
            .navigationDestination(for: DogApi.self, destination: { dog in
                BreedSearchingListView(dog: dog)
            })
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
//        let parameters = [
//            "page": 0,
//            "limit": 5
//        ] as [String : Any]
        let headers = ["x-api-key": apiKey]
        let urlComponents = URLComponents(string: "https://api.thedogapi.com/v1/breeds?limit=100&page=0")!
        
        
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
    
    func getAPIKey() -> String? {
        return Bundle.main.object(forInfoDictionaryKey: "NINJA_API_KEY") as? String
    }
}

#Preview {
    SearchView(backroundLogic: BackgroundLogic())
}

