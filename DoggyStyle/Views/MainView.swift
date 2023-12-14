//
//  MainView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 06/12/23.
//

import SwiftUI
import SwiftData
import MapKit
struct MainView: View {
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(BackgroundLogic.self) private var backgroundLogic
    @Query private var dogs: [Dog]
    @State var position: MapCameraPosition

    var body: some View {
        if horizontalSizeClass == .compact {
            ///IPHONE SECTION
            TabView{
                MapView()
                MyDogsView(backgroundLogic: backgroundLogic)
                    .tabItem { Label(dogs.count > 1 ? "My Dogs" : "My Dog", systemImage: "dog.fill") }
                SearchView(backroundLogic: backgroundLogic)
                    .tabItem { Label("Search", systemImage: "magnifyingglass") }
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
                            SearchView(backroundLogic: backgroundLogic)
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

//#Preview {
//    MainView()
//        .environment(BackgroundLogic())
//}

#if os(iOS)
extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
#endif
