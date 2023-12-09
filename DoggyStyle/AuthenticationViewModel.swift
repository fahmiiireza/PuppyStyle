//
// AuthenticationViewModel.swift
// Favourites
//
// Created by Peter Friese on 08.07.2022
// Copyright © 2021 Google LLC. All rights reserved.
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

import Foundation
import FirebaseCore
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift
import FirebaseFirestore

// Enum defining authentication states
enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

// Enum defining authentication flow (login or sign up)
enum AuthenticationFlow {
    case login
    case signUp
}

// AuthenticationViewModel manages user authentication state
@MainActor
class AuthenticationViewModel: ObservableObject {
    let db = Firestore.firestore()

    // Published properties for user input
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var confirmPassword: String = ""
    
    // Published properties for authentication flow and state
    @Published var flow: AuthenticationFlow = .login
    @Published var isValid: Bool = false
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage: String = ""
    @Published var user: User?
    @Published var displayName: String = ""
    
    // Initialize the view model and register the auth state change handler
    init() {
        registerAuthStateHandler()
        
        $flow
            .combineLatest($email, $password, $confirmPassword)
            .map { flow, email, password, confirmPassword in
                flow == .login
                ? !(email.isEmpty || password.isEmpty)
                : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            }
            .assign(to: &$isValid)
    }
    
    // Auth state change handler
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    // Register the auth state change handler
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.displayName = user?.email ?? ""
            }
        }
    }
    
    // Switch between login and sign up flows
    func switchFlow() {
        flow = flow == .login ? .signUp : .login
        errorMessage = ""
    }
    
    // Async function to introduce a wait
    private func wait() async {
        do {
            print("Wait")
            try await Task.sleep(nanoseconds: 1_000_000_000)
            print("Done")
        } catch {}
    }
    
    // Reset properties to default values
    func reset() {
        flow = .login
        email = ""
        password = ""
        confirmPassword = ""
    }
}

// Extension for additional functions related to AuthenticationViewModel
extension AuthenticationViewModel {
    // Async function to sign in with email and password
    func signInWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            try await Auth.auth().signIn(withEmail: self.email, password: self.password)
            return true
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    // Async function to sign up with email and password
    func signUpWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            try await Auth.auth().createUser(withEmail: email, password: password)
            return true
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    // Function to sign out
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    // Async function to delete the user account
    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}

// Enum defining authentication errors
enum AuthenticationError: Error {
    case tokenError(message: String)
}

// Extension for additional functions related to AuthenticationViewModel
extension AuthenticationViewModel {
    // Async function to sign in with Google
    func signInWithGoogle() async -> Bool {
        // Obtain the client ID from Firebase configuration
        guard let clientID = FirebaseApp.app()?.options.clientID else {
            fatalError("No client ID found in Firebase configuration")
        }
        // Configure Google Sign-In with the obtained client ID
        let config = GIDConfiguration(clientID: clientID)
        GIDSignIn.sharedInstance.configuration = config
        
        // Obtain the root view controller for Google Sign-In
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first,
              let rootViewController = window.rootViewController else {
            print("There is no root view controller!")
            return false
        }
        
        do {
            // Perform Google Sign-In and obtain user information
            let userAuthentication = try await GIDSignIn.sharedInstance.signIn(withPresenting: rootViewController)
            let user = userAuthentication.user
            guard let idToken = user.idToken else {
                throw AuthenticationError.tokenError(message: "ID token missing")
            }
            let accessToken = user.accessToken
            
            // Create Firebase credential with Google Sign-In tokens
            let credential = GoogleAuthProvider.credential(withIDToken: idToken.tokenString,
                                                           accessToken: accessToken.tokenString)
            
            // Sign in with Firebase using Google credentials
            let result = try await Auth.auth().signIn(with: credential)
            let firebaseUser = result.user
            //set the user data with only email whn first signing up
            db.collection("user").document(firebaseUser.email!).setData([
              "email": firebaseUser.email!,
            ]) { err in
              if let err = err {
                print("Error writing document: \(err)")
              } else {
                print("Document successfully written!")
              }
            }
            
            print("User \(firebaseUser.uid) signed in with email \(firebaseUser.email ?? "unknown")")
            return true
        } catch {
            // Handle errors during Google Sign-In
            print(error.localizedDescription)
            self.errorMessage = error.localizedDescription
            return false
        }
    }
}

