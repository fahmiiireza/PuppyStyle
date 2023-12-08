//
//  LogInView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 07/12/23.
//

import SwiftUI

enum FocusedField {
        case mail, password, confirmedPassword
    }

struct SignUpView: View {
    
    @FocusState private var focusField: FocusedField?
    @Environment(\.colorScheme) private var colorScheme
    @Environment(\.dismiss) private var dismiss
    @State private var mail = ""
    @State private var password = ""
    @State private var confirmedPassword = ""
    @State private var signingUp = true
    
    var body: some View {
        
        NavigationStack {
            VStack {
                
                HStack {
                    
                    Button(action: {
                        signingUp = true
                    }, label: {
                        Text("Sign Up")
                            .foregroundStyle(signingUp ? Color.primary : Color.gray)
                            .font(.title)
                            .bold()
                    })
                    
                    Text("|")
                        .font(.title)
                        .bold()
                    
                    Button(action: {
                        signingUp = false
                    }, label: {
                        Text("Log In")
                            .foregroundStyle(signingUp ? Color.gray : Color.primary)
                            .font(.title)
                            .bold()
                    })
                    
                }
                
                Image("Appicon")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .containerRelativeFrame(.vertical){size, axis  in
                        size * 0.2
                    }
                    .clipShape(Circle())
                
                Text("Doggy Style")
                    .font(.largeTitle)
                    .bold()
                
                Divider()
                
                HStack{
                    VStack(alignment: .leading){
                        
                        if signingUp{
                            Text("Sign up with E-Mail")
                                .font(.headline)
                        }else{
                            Text("Log in with E-Mail")
                                .font(.headline)
                        }
                        
                        TextField("E-Mail", text: $mail)
                            .focused($focusField, equals: .mail)
                            .keyboardType(.emailAddress)
                            .textFieldStyle(.plain)
                            .padding(10)
                            .background(.gray.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .autocorrectionDisabled()
                            .textContentType(.emailAddress)
                            .onSubmit() {
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.01){
                                    focusField = .password
                                }
                            }
                            
                        SecureField("Password", text: $password)
                            .focused($focusField, equals: .password)
                            .textFieldStyle(.plain)
                            .padding(10)
                            .background(.gray.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .textContentType(.password)
                            .onSubmit() {
                                if signingUp{
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.01){
                                        focusField = .confirmedPassword
                                    }
                                    
                                }else{
                                    //check if correct and sign in
                                    print("Signed In")
                                    dismiss.callAsFunction()
                                }
                            }
                        
                        if signingUp{
                            SecureField("Confirm Password", text: $confirmedPassword)
                                .focused($focusField, equals: .confirmedPassword)
                                .textFieldStyle(.plain)
                                .padding(10)
                                .background(.gray.opacity(0.3))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .textContentType(.password)
                                .onSubmit() {
                                    //check if correct and sign up
                                    print("Signed Up")
                                    dismiss.callAsFunction()
                                }
                        }
                        
                        HStack{
                            Spacer()
                            Text("OR")
                            Spacer()
                        }
                        
                        //Sign in with Google Button
                        if signingUp {
                            Button(action: {
                                
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .frame(height: 50)
                                        .foregroundStyle(colorScheme == .dark ? Color.black : Color.white)
                                        .shadow(color: colorScheme == .dark ? Color.clear : Color.gray.opacity(0.4), radius: 5)
                                        
                                    HStack{
                                        Image("Google")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                        Text("Sign up with Google")
                                            .font(.headline)
                                            .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                                        Spacer()
                                    }
                                    .padding(10)
                                    .frame(height: 50)
                                }
                            })
                        }else{
                            Button(action: {
                                
                            }, label: {
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10)
                                        .foregroundStyle(colorScheme == .dark ? Color.black : Color.white)
                                        .frame(height: 50)
                                        .shadow(color: colorScheme == .dark ? Color.clear : Color.gray.opacity(0.4), radius: 5)
                                        
                                    HStack{
                                        Image("Google")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                        Text("Sign In with Google")
                                            .font(.headline)
                                            .foregroundStyle(colorScheme == .dark ? Color.white : Color.black)
                                        Spacer()
                                    }
                                    .padding(10)
                                    .frame(height: 50)
                                }
                            })
                        }
                        
                        
                        
                    }
                    .padding()
                    Spacer()
                }
                Spacer()
                
                if signingUp{
                    Text("Already have an account?")
                    
                    Button(action: {
                        signingUp = false
                    }, label: {
                        Text("Sign In")
                            .underline()
                    })
                }else{
                    Text("Don't have an account yet?")
                    
                    Button(action: {
                        signingUp = true
                    }, label: {
                        Text("Sign Up")
                            .underline()
                    })
                }
                
                
                    
            }
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss.callAsFunction()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        dismiss.callAsFunction()
                    }label: {
                        Text(signingUp ? "Sign Up" : "Sign In")
                            .bold()
                            .disabled(mail.isEmpty || password.isEmpty || confirmedPassword.isEmpty)
                    }
                }
            })
            .padding(.top)
        }
        
    }
}

#Preview {
    SignUpView()
}
