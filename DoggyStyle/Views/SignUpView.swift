//
//  LogInView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 07/12/23.
//

import SwiftUI
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore

enum FocusedField {
    case mail, password, confirmedPassword
}


struct SignUpView: View {
    let db = Firestore.firestore()

    // Inject the AuthenticationViewModel as an environment object
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @FocusState private var focusField: FocusedField?
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @State private var showButton = false
    @State private var accountExists = true
    @State private var chosenEmail = false
    @State private var mail = ""
    @State private var password = ""
    @State private var confirmedPassword = ""
    @State private var signingUp = true
    @State private var errorSigningUp = false
    @State private var errorText = ""
    
    // Perform Google Sign-In when the corresponding button is tapped
    private func signInWithGoogle() {
        Task {
            if await viewModel.signInWithGoogle() {
                dismiss()
            }
        }
    }

    
    var body: some View {
        
        NavigationStack {
            VStack {
                
//                HStack {
//                    
//                    Button(action: {
//                        signingUp = true
//                    }, label: {
//                        Text("Sign Up")
//                            .foregroundStyle(signingUp ? Color.primary : Color.gray)
//                            .font(.title)
//                            .bold()
//                    })
//                    
//                    Text("|")
//                        .font(.title)
//                        .bold()
//                    
//                    Button(action: {
//                        signingUp = false
//                    }, label: {
//                        Text("Log In")
//                            .foregroundStyle(signingUp ? Color.gray : Color.primary)
//                            .font(.title)
//                            .bold()
//                    })
//                    
//                }
                
                Image("Appicon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .containerRelativeFrame(.vertical){size, axis  in
                        size * 0.2
                    }
                    .clipShape(Circle())
                
                Text("Sign up or Log in")
                    .font(.largeTitle)
                    .bold()
                
                Divider()
                    .padding(.horizontal)
                
                HStack{
                    VStack(alignment: .leading){
                        
//                        if signingUp{
//                            Text("Sign up with E-Mail")
//                                .font(.headline)
//                        }else{
//                            Text("Log in with E-Mail")
//                                .font(.headline)
//                        }
                        Button {
                            withAnimation {
                                chosenEmail.toggle()
                            }
                            
                        } label: {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                    .foregroundStyle(colorScheme == .dark ? Color.black : Color.white)
                                    .frame(height: 50)
                                    .shadow(color: colorScheme == .dark ? Color.clear : Color.gray.opacity(0.4), radius: 5)
                                
                                HStack{
                                    Image(systemName: "envelope")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .padding(.vertical, 2)
                                        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                                    Text("Continue with E-Mail")
                                        .font(.headline)
                                        .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                                    Spacer()
                                }
                                .padding(10)
                                .frame(height: 50)
                            }
                        }

                        
                        if chosenEmail{
                            Text("Type in your E-Mail")
                                .font(.caption)
                                .padding(.top)
                            TextField("E-Mail", text: $mail)
                                .focused($focusField, equals: .mail)
                                .keyboardType(.emailAddress)
                                .textFieldStyle(.plain)
                                .padding(10)
                                .background(.gray.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .textInputAutocapitalization(.never)
                                .autocorrectionDisabled()
                                .textContentType(.username)
                                .onSubmit() {
                                    focusField = .password
                                }
                                
                                .onChange(of: focusField, initial: false) {
                                    if focusField != .mail{
                                        db.collection("user").whereField("email", isEqualTo: mail.lowercased())
                                            .getDocuments() { (querySnapshot, err) in
                                                if let err = err {
                                                    print("Error getting documents: \(err)")
                                                } else {
                                                    print(querySnapshot!.documents)
                                                    if querySnapshot!.documents.isEmpty {
                                                        withAnimation {
                                                            accountExists = false
                                                        }
                                                        
                                                        print("user not found")
                                                    } else {
                                                        withAnimation {
                                                            accountExists = true
                                                        }
                                                        
                                                        for document in querySnapshot!.documents {
                                                            print("\(document.documentID) => \(document.data())")
                                                        }
                                                    }
                                                }
                                            }
                                    }
                                }
                            
                            SecureField("Password", text: $password)
                                .focused($focusField, equals: .password)
                                .textFieldStyle(.plain)
                                .padding(10)
                                .background(.gray.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .textContentType(accountExists ? .password : .newPassword)
                                .onSubmit() {
                                    withAnimation {
                                        focusField = .confirmedPassword
                                    }
                                            
                                        //check if correct and sign in
                                        print("Signed In")
                                        dismiss.callAsFunction()
                                    
                                }
                            
                            if !accountExists{
                                SecureField("Confirm Password", text: $confirmedPassword)
                                    .focused($focusField, equals: .confirmedPassword)
                                    .textFieldStyle(.plain)
                                    .padding(10)
                                    .background(.gray.opacity(0.3))
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                                    .textContentType(.password)
                                    .onSubmit() {
                                        //check if correct and sign up
                                        Auth.auth().createUser(withEmail: mail.lowercased(), password: password) { authResult, error in
                                            if let err = error {
                                                print(err.localizedDescription)
                                            } else {
                                                print(authResult ?? "test")
                                                dismiss()
                                            }
                                        }
                                        viewModel.createUser(email: mail, fromGoogle: false)

                                        print("Signed Up")
                                        dismiss.callAsFunction()
                                    }
                            }
                            
                            if accountExists && !password.isEmpty{
                                Button("Log in"){
                                    Auth.auth().signIn(withEmail: mail.lowercased(), password: password) { authResult, error in
                                        if let err = error {
                                            print(err)
                                        } else {
                                            print(authResult ?? "test")
                                            dismiss()
                                        }
                                    }
                                }
                                
                            }else if !accountExists && !password.isEmpty && password == confirmedPassword{
                                Button("Sign up using E-mail"){
                                    Auth.auth().createUser(withEmail: mail.lowercased(), password: password) { authResult, error in
                                        if let err = error {
                                            errorSigningUp = true
                                            print(err.localizedDescription)
                                            errorText = err.localizedDescription
                                        } else {
                                            print(authResult ?? "test")
                                            dismiss()
                                        }
                                    }
                                    viewModel.createUser(email: mail, fromGoogle: false)

                                }
                                .alert(errorText, isPresented: $errorSigningUp) {
                                    Button("Choose different E-Mail", role: .cancel){
                                        
                                    }
                                }
                            }
                        }
                        
                        if chosenEmail{
                            HStack{
                                Spacer()
                                Text("OR")
                                Spacer()
                            }
                        }
                        
                        //Sign in with Google Button
                            Button(action: signInWithGoogle , label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: 50)
                                        .foregroundStyle(colorScheme == .dark ? Color.black : Color.white)
                                        .shadow(color: colorScheme == .dark ? Color.clear : Color.gray.opacity(0.4), radius: 5)
                                    
                                    HStack{
                                        Image("Google")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                        Text("Continue with Google")
                                            .font(.headline)
                                            .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                                        Spacer()
                                    }
                                    .padding(10)
                                    .frame(height: 50)
                                }
                            })
                        
                        
                        
                        
                    }
                    .padding()
                    Spacer()
                }
                //Spacer()
                
//                if signingUp{
//                    Text("Already have an account?")
//                    
//                    Button(action: {
//                        signingUp = false
//                    }, label: {
//                        Text("Sign In")
//                            .underline()
//                    })
//                    .padding(.bottom)
//                }else{
//                    Text("Don't have an account yet?")
//                    
//                    Button(action: {
//                        signingUp = true
//                    }, label: {
//                        Text("Sign Up")
//                            .underline()
//                    })
//                    .padding(.bottom)
//                }
                
                
                
            }
            
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss.callAsFunction()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        if signingUp {
                            Auth.auth().createUser(withEmail: mail, password: password) { authResult, error in
                                if let err = error {
                                    print(err.localizedDescription)
                                } else {
                                    print(authResult ?? "test")
                                }
                            }
                            //set the user data with only email whn first signing up
                             viewModel.createUser(email: mail, fromGoogle: false)
                        } else {
                            Auth.auth().signIn(withEmail: mail, password: password) { authResult, error in
                                if let err = error {
                                    print(err)
                                } else {
                                    print(authResult ?? "test")
                                }
                            }
                            
                        }
                        dismiss.callAsFunction()
                    }label: {
                        Text(signingUp ? "Sign Up" : "Sign In")
                            .bold()
                            
                    }
                    .disabled(mail.isEmpty || password.isEmpty || confirmedPassword.isEmpty)
                }
            })
            .padding(.top)
        }
        
    }
}

#Preview {
    SignUpView()
        .environmentObject(AuthenticationViewModel())
}
