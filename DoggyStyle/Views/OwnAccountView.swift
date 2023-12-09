//
//  OwnAccountView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 09/12/23.
//

import SwiftUI
import FirebaseAuth

struct OwnAccountView: View {
    
    @EnvironmentObject var viewModel: AuthenticationViewModel
    @Binding var user: User?
    
    var body: some View {
        
        VStack{
            Text(user?.email ?? "Unknown User")
            Button("Sign out") {
                viewModel.signOut()
            }
        }
        
        
    }
}

#Preview {
    OwnAccountView(user: .constant(.none))
}
