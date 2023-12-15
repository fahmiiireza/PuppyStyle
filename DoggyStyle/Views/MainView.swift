//
//  MainView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 06/12/23.
//

import SwiftUI
import SwiftData

struct MainView: View {
    
    @EnvironmentObject var networkMonitor: NetworkMonitor
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(BackgroundLogic.self) private var backgroundLogic
    @Query private var dogs: [Dog]
    @State private var selection = "Dogs"
    
    var body: some View {
        if horizontalSizeClass == .compact {
            ///IPHONE SECTION
            TabView(selection: $selection){
                MyDogsView(backgroundLogic: backgroundLogic)
                    .tag("Dogs")
                    .tabItem { Label(dogs.count > 1 ? "My Dogs" : "My Dog", systemImage: "dog.fill") }
                
                if networkMonitor.isConnected {
                    SearchView(backgroundLogic: backgroundLogic)
                        .tabItem { Label("Search", systemImage: "magnifyingglass") }
                        .tag("Search")
                }else{
                    NoNetworkView()
                        .tag("FYF")
                        .tabItem { Label("Search", systemImage: "magnifyingglass") }
                }
                
                
            }
            .onChange(of: networkMonitor.isConnected) { oldValue, newValue in
                if selection == "Search"{
                    selection = "FYF"
                }else if selection == "FYF"{
                    selection = "Search"
                }else{
                    selection = "Dogs"
                }
            }
        }else{
            ///IPAD SECTION
            NavigationSplitView {
                NavigationStack{
                    List{
                        NavigationLink {
                            MyDogsView(backgroundLogic: backgroundLogic)
                        } label: {
                            Label("My Dogs", systemImage: "dog")
                        }
                        NavigationLink {
                            SearchView(backgroundLogic: backgroundLogic)
                        } label: {
                            Label("Search", systemImage: "magnifyingglass")
                        }
                    }
                    .navigationTitle("Doggy Style")
                }
            } detail: {
                MyDogsView(backgroundLogic: backgroundLogic)
            }
        }
    }
}

#Preview {
    MainView()
        .environment(BackgroundLogic())
}

#if os(iOS)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
