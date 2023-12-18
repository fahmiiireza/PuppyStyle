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
//class AppDelegate: NSObject, UIApplicationDelegate {
//    func application(
//        _ application: UIApplication,
//        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
//    ) -> Bool {
//
//        return true
//    }
//}

@main
struct DoggyStyleApp: App {
    
    init(){
        FirebaseApp.configure()
    }
    @StateObject private var authenticationViewModel = AuthenticationViewModel()
    @StateObject var networkMonitor = NetworkMonitor()

    // register app delegate for Firebase setup
//    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
//    var sharedModelContainer: ModelContainer = {
//        let schema = Schema([
//            Item.self,
//            Dog.self,
//            UserData.self
//        ])
//        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
//        
//        do {
//            return try ModelContainer(for: schema, configurations: [modelConfiguration])
//        } catch {
//            fatalError("Could not create ModelContainer: \(error)")
//        }
//    }()
    
    @State private var backgroundLogic = BackgroundLogic()
    
    var body: some Scene {
        
        WindowGroup {
            MainView()
        }
        .environment(backgroundLogic)
        .environmentObject(authenticationViewModel)
        .environmentObject(networkMonitor)
      //  .modelContainer(sharedModelContainer)
        .modelContainer(for: [Dog.self, UserData.self])
//       .modelContainer(for: Dog.self)
    }
}
