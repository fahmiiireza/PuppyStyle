//
//  ContentView.swift
//  DoggyStyle
//
//  Created by Fahmi Fahreza on 05/12/23.
//

import SwiftUI
import SwiftData
import FirebaseCore
import FirebaseFirestore // Import FirebaseFirestore
import GoogleSignIn
import GoogleSignInSwift
import FirebaseAuth


// ContentView is the main view for the app
struct ContentView: View {
    // Inject the AuthenticationViewModel as an environment object
    @EnvironmentObject var viewModel: AuthenticationViewModel
    // Access the model context from the environment
    @Environment(\.modelContext) private var modelContext
    // Access the dismiss function from the environment
    @Environment(\.dismiss) var dismiss

    // Query to retrieve items from the data store
    @Query private var items: [Item]

    // Perform Google Sign-In when the corresponding button is tapped
    private func signInWithGoogle() {
        Task {
            if await viewModel.signInWithGoogle() == true {
                dismiss()
            }
        }
    }

    // Firestore reference for adding items
    let db = Firestore.firestore()

    var body: some View {
        // NavigationSplitView is used to create a split view with a master and detail view
        NavigationSplitView {
            // List displays a list of items with the ability to delete them
            List {
                ForEach(items) { item in
                    NavigationLink {
                        // Display details of the selected item
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                .onDelete(perform: deleteItems)
            }
            // Toolbar with Edit button and Add Item button
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            // Detail view displays "Select an item"
            Text("Select an item")
        }
        // Button to sign in with Google
        Button(action: signInWithGoogle, label: {
            Text("Sign in with Google")
                .foregroundStyle(.primary)
        })
        .buttonStyle(.bordered)
    }

    // Function to add a new item
    private func addItem() {
        withAnimation {
            let newItem = Item(timestamp: Date())
            modelContext.insert(newItem)

            // Add the item to Firestore
            db.collection("items").addDocument(data: [
                "timestamp": "nfelix"
            ]) { err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added with ID: \(newItem.timestamp)")
                }
            }
        }
    }

    // Function to delete items
    private func deleteItems(offsets: IndexSet) {
        // ... your existing code
    }

    // Function to perform Google Sign-In
//    func signInWithGoogle() async -> Bool {
//        // Obtain the root view controller for Google Sign-In
//        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
//              let window = windowScene.windows.first,
//              let rootViewController = window.rootViewController else {
//            print("no root view")
//            return false
//        }
//        do {
//            // Perform Google Sign-In and obtain user information
//            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
//            let user = userAuthentication.user
//            guard let idToken = user.idToken else {
//                print("ID Token is missing")
//                fatalError()
//            }
//            let accessToken = user.accessToken
//            // Create Firebase credential with Google Sign-In tokens
//            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString, accessToken: accessToken.tokenString)
//            // Sign in with Firebase using Google credentials
//            let result = try await Auth.auth().signIn(with: credential)
//            let firebaseUser = result.user
//            print("\(firebaseUser.uid) with email \(firebaseUser.email ?? "unknown")")
//            return true
//        } catch {
//            // Handle errors during Google Sign-In
//            print(error.localizedDescription)
//            return false
//        }
//    }
}



#Preview {
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
        .environmentObject(AuthenticationViewModel())
}
