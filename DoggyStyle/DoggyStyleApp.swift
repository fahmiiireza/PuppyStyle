//
//  DoggyStyleApp.swift
//  DoggyStyle
//
//  Created by Fahmi Fahreza on 05/12/23.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseCore
import FirebaseAuth
import GoogleSignIn

// AppDelegate is used for Firebase setup
class AppDelegate: NSObject, UIApplicationDelegate {
    // Configure Firebase when the application finishes launching
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }

    // Handle URL opening, particularly for Google Sign-In
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

// DoggyStyleApp is the main structure defining the app
@main
struct DoggyStyleApp: App {
    // Create an instance of AuthenticationViewModel as a shared state object
    @StateObject private var authenticationViewModel = AuthenticationViewModel()

    // Register the AppDelegate to set up Firebase configurations
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate

    // Create a shared ModelContainer with a specified schema and configuration
    var sharedModelContainer: ModelContainer = {
        // Define the schema for the data models used in the app
        let schema = Schema([Item.self])
        // Configure a ModelConfiguration with the defined schema and storage settings
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            // Create a ModelContainer with the specified schema and configuration
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            // Handle any errors that might occur during ModelContainer creation
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    // Define the main SwiftUI view hierarchy for the app
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        // Attach the shared ModelContainer to the main window group
        .modelContainer(sharedModelContainer)
        // Inject the AuthenticationViewModel as an environment object
        .environmentObject(authenticationViewModel)
    }
}
