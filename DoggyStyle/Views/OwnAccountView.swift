//
//  OwnAccountView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 09/12/23.
//

import SwiftUI
import FirebaseAuth
import PhotosUI

struct OwnAccountView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @State private var signOutAlertPresented = false
    @State private var cancelAlertPresented = false
    @State private var currentUser: UserData?
    @State private var profilePicture: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @Binding var user: User?
  //  @Bindable var specificUser: UserData
    
    var body: some View {
        
        NavigationStack{
            Form{
                Section{
                    HStack(){
                        PhotosPicker(selection: $photosPickerItem, matching: .images) {
                            Image(uiImage: profilePicture ?? .placeholderDog)
                                .resizable()
                               .aspectRatio(contentMode: .fill)
                                .frame(width: 70, height: 70)
                                .clipShape(Circle())
                                
                                
                        }
                        VStack(alignment: .leading, spacing: 0){
                            Text("Susanne Herbig")
                                .font(.title2)
                                .bold()
                            Text("📍\(currentUser?.location ?? "No Location Found")")
                        }
                        Spacer()
                    }
                }
                List{
                    Text("hello")
                }
                
            }
            
            
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel"){
                        cancelAlertPresented.toggle()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        /// ADD Funtion to save in ModelContext and also Firebase
                        dismiss()
                    }, label: {
                        Text("Done")
                            .bold()
                    })
                }
            })
        }
        .alert("Discard Changes?", isPresented: $cancelAlertPresented){
            
            Button("Keep Editing", role: .cancel) {
                
            }
            
            Button("Discard Changes", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("If you cancel your changes will be discarded.")
        }
        .onChange(of: photosPickerItem) { _, _ in
            Task{
                if let photosPickerItem,
                   let data = try? await photosPickerItem.loadTransferable(type: Data.self){
                    if let image = UIImage(data: data){
                        profilePicture = image
                    }
                }
            }
        }
        
        
        
        VStack{
            Text(user?.email ?? "Unknown User")
            Button("Sign out") {
                signOutAlertPresented.toggle()
                
            }
        }
        .alert("Sign Out?", isPresented: $signOutAlertPresented) {
            Button("Cancel", role: .cancel) {
                
            }
            Button("Sign out", role: .destructive) {
                withAnimation {
                    viewModel.signOut()
                }
                
            }
        } message: {
            Text("Do you really want to sign out of your account?")
        }

        
        
    }
}

#Preview {
    OwnAccountView(user: .constant(.none))
}
