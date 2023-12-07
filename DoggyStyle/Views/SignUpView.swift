//
//  LogInView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 07/12/23.
//

import SwiftUI


struct SignUpView: View {
    
    @State private var mail = ""
    @State private var password = ""
    @State private var confirmedPassword = ""
    @State private var signingUp = true
    
    var body: some View {
        
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
                        .keyboardType(.emailAddress)
                        .textFieldStyle(.plain)
                        .padding(10)
                        .background(.gray.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                    SecureField("Password", text: $password)
                        
                        .textFieldStyle(.plain)
                        .padding(10)
                        .background(.gray.opacity(0.3))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    if signingUp{
                        SecureField("Confirm Password", text: $confirmedPassword)
                            .textFieldStyle(.plain)
                            .padding(10)
                            .background(.gray.opacity(0.3))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
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
                                    .foregroundStyle(.white)
                                    .frame(height: 50)
                                    .shadow(color: .gray.opacity(0.4), radius: 5)
                                    
                                HStack{
                                    Image("Google")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                    Text("Sign up with Google")
                                        .font(.title3)
                                        
                                        .foregroundStyle(.black)
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
                                    .foregroundStyle(.white)
                                    .frame(height: 50)
                                    .shadow(color: .gray.opacity(0.4), radius: 5)
                                    
                                HStack{
                                    Image("Google")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                    Text("Sign In with Google")
                                        .font(.title3)
                                        
                                        .foregroundStyle(.black)
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
        
    }
}

#Preview {
    SignUpView()
}
