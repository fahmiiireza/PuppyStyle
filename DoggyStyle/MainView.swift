//
//  MainView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 06/12/23.
//

import SwiftUI

struct MainView: View {
    
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    
    var body: some View {
        if horizontalSizeClass == .compact {
            ///IPHONE SECTION
            TabView{
                MyDogsView()
                    .tabItem { Label("My Dogs", systemImage: "dog.fill") }
                MyDogsView()
                    .tabItem { Label("Search", systemImage: "magnifyingglass") }
            }
        }else{
            ///IPAD SECTION
            NavigationSplitView {
                NavigationStack{
                    List{
                        NavigationLink {
                            MyDogsView()
                        } label: {
                            Label("My Dogs", systemImage: "dog")
                        }
                    }
                    .navigationTitle("Sidebar")
                }
            } detail: {
                MyDogsView()
            }
        }
    }
}

#Preview {
    MainView()
}
