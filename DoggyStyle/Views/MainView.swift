//
//  MainView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 06/12/23.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @Environment(BackgroundLogic.self) private var backgroundLogic
    
    var body: some View {
        if horizontalSizeClass == .compact {
            ///IPHONE SECTION
            TabView{
                MyDogsView(backgroundLogic: backgroundLogic)
                    .tabItem { Label("My Dogs", systemImage: "dog.fill") }
                SearchView()
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
                    }
                    .navigationTitle("Sidebar")
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