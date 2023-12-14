//
//  SearchView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 07/12/23.
//

import SwiftUI
import FirebaseAuth

struct SearchView: View {
    
    @Environment(\.dismiss) private var dismiss
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @State private var handle: AuthStateDidChangeListenerHandle?
    @State private var user: User?
    @State private var dogData : [DogApi] = []
    @FocusState private var focused: FocusedField?
    @Bindable var backgroundLogic: BackgroundLogic
    @State private var isSearching = false
    @State private var searchText = ""
    @Namespace private var searchAnimation
    
    
    
    var body: some View {
        
        let layout = horizontalSizeClass == .compact ? [GridItem(.flexible()), GridItem(.flexible())] : [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
        
        NavigationStack(path: $backgroundLogic.path){
            ScrollView{
                VStack{
                    HStack() {
                        
                        Text("Search")
                            .font(.largeTitle)
                            .bold()
                        
                        Spacer()
                        
                        Button(action: {
                            backgroundLogic.profileSheetPresented = true
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
                            HStack{
                                Image(systemName: "magnifyingglass")
                                    .foregroundStyle(.secondary)
                                TextField(text: $searchText) {
                                    
                                }
                                .autocorrectionDisabled()
                                .focused($focused, equals: .searchfield)
                                .matchedGeometryEffect(id: "SearchBar", in: searchAnimation)
                            }
                            
                            .padding(10)
                            .background(.ultraThickMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .padding(.horizontal)
                            .overlay(alignment: .leading) {
                                if searchText.isEmpty{
                                    Label(
                                        title: { Text("Search breeds") },
                                        icon: { Image(systemName: "magnifyingglass").opacity(0.0) }
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
                HStack{
                    Button(action: {
                        backgroundLogic.tinderPresented = true
                    }, label: {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.green.gradient)
                            .containerRelativeFrame(.vertical){size, _ in
                                horizontalSizeClass == .compact ? size * 0.2 : size * 0.25
                            }
                            .containerRelativeFrame(.horizontal){size, _ in
                                horizontalSizeClass == .compact ? size * 0.45 : size * 0.235
                            }
                            .overlay{
                                Image(systemName: "shuffle")
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundStyle(.white)
                                    .shadow(radius: 10)
                            }
                            .padding(.leading)
                    })
                    Button(action: {
                        backgroundLogic.mapPresented = true
                    }, label: {
                        Image(.maps)
                            .resizable()
                            .containerRelativeFrame(.vertical){size, _ in
                                horizontalSizeClass == .compact ? size * 0.2 : size * 0.25
                            }
                            .containerRelativeFrame(.horizontal){size, _ in
                                horizontalSizeClass == .compact ? size * 0.45 : size * 0.235
                            }
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .overlay{
                                Image(systemName: "map")
                                    .font(.largeTitle)
                                    .bold()
                                    .foregroundStyle(.white)
                                    .shadow(radius: 10)
                            }
                            .padding(.trailing)
                    })
                }
                LazyVGrid(columns: layout, content: {
                    
                    ForEach(dogData.filter({"\($0)".localizedCaseInsensitiveContains(searchText.replacingOccurrences(of: "_", with: " ")) || searchText.isEmpty})){ dog in
                        
                        //   AsyncImage(url: dog.image.url)
                        
                        Button(action: {backgroundLogic.tinderPresented = true}, label: {
                            ZStack(alignment: .bottomLeading){
                                
                                Image("\(dog.name)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .containerRelativeFrame(.horizontal){size, _ in
                                        horizontalSizeClass == .compact ? size * 0.45 : size * 0.235
                                    }
                                    .containerRelativeFrame(.vertical){size, _ in
                                        horizontalSizeClass == .compact ? size * 0.2 : size * 0.25
                                    }
                                    
                                    
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    
                                    
                                Text(dog.name)
                                    .font(.title3)
                                    .bold()
                                    .foregroundStyle(.white)
                                    .shadow(color: .black, radius: 10)
                                    .padding(7)
                                    .multilineTextAlignment(.leading)
                            }
                            .onAppear{
                                print(dog.name)
                            }
                                       
                        })
                       
                    }
                })
                .padding(.horizontal)
            }
            .navigationDestination(for: DogApi.self, destination: { dog in
                BreedSearchingListView(dog: dog)
            })
            
            .fullScreenCover(isPresented: $backgroundLogic.mapPresented, content: {
                Text("MapView")
                    .overlay {
                        Button {
                            backgroundLogic.mapPresented = false
                        } label: {
                            Text("Dismiss")
                        }

                    }
            })
            .fullScreenCover(isPresented: $backgroundLogic.tinderPresented, content: {
                TinderView()
            })
            .fullScreenCover(isPresented: $backgroundLogic.profileSheetPresented, content: {
                
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
    SearchView(backgroundLogic: BackgroundLogic())
}

