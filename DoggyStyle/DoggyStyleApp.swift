//
//  DoggyStyleApp.swift
//  DoggyStyle
//
//  Created by Fahmi Fahreza on 05/12/23.
//

import SwiftUI
import SwiftData
import FirebaseCore

// Needed for Firebase
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
}

@main
struct DoggyStyleApp: App {
    @StateObject private var authenticationViewModel = AuthenticationViewModel()
    
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
            Dog.self,
            UserData.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @State private var backgroundLogic = BackgroundLogic()
    @State private var dummyDogData = DummyDogData()
    
    var body: some Scene {
        
        
        WindowGroup {
            MainView(position: .userLocation(fallback: .automatic))
        }
        .environment(dummyDogData)
        .environment(backgroundLogic)
        .environmentObject(authenticationViewModel)
        .modelContainer(sharedModelContainer)
//       .modelContainer(for: Dog.self)
    }
}
