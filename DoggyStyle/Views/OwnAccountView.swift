//
//  OwnAccountView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 09/12/23.
//

import SwiftUI
import FirebaseAuth
import PhotosUI
import FirebaseFirestore
import FirebaseStorage

struct OwnAccountView: View {
    
    enum ImageUploadError: Error {
        case imageConversionFailed
        case uploadFailed
        case urlRetrievalFailed
    }
    
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var viewModel: AuthenticationViewModel
    
    @State private var signOutAlertPresented = false
    @State private var cancelAlertPresented = false
    @StateObject private var userDataViewModel = UserDataViewModel()
    @State private var profilePicture: UIImage?
    @State private var photosPickerItem: PhotosPickerItem?
    @Binding var user: User?
  //  @Bindable var specificUser: UserData
    
    func uploadProfileImage(_ image: UIImage, forUser userId: String, completion: @escaping (Result<String, Error>) -> Void) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(ImageUploadError.imageConversionFailed))
            return
        }

        let storageRef = Storage.storage().reference().child("profile_images/\(userId).jpg")

        storageRef.putData(imageData, metadata: nil) { metadata, error in
            guard metadata != nil else {
                completion(.failure(error ?? ImageUploadError.uploadFailed))
                return
            }

            storageRef.downloadURL { url, error in
                if let url = url {
                    completion(.success(url.absoluteString))
                } else {
                    completion(.failure(error ?? ImageUploadError.urlRetrievalFailed))
                }
            }
        }
    }

    func updateUserProfilePictureUrl(_ url: String, forEmail: String, completion: @escaping (Result<Void, Error>) -> Void) {
        let db = Firestore.firestore()
        db.collection("user").document(forEmail).updateData(["profilePictureUrl": url]) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(()))
            }
        }
    }
    
    var body: some View {
        
        NavigationStack{
            Form{
                Section{
                    HStack(){
                        PhotosPicker(selection: $photosPickerItem, matching: .images) {
                            if let profilePictureUrl = userDataViewModel.currentUser?.profilePictureUrl, let url = URL(string: profilePictureUrl) {
                                AsyncImage(url: url) { imagePhase in
                                    switch imagePhase {
                                    case .empty:
                                        ProgressView()
                                    case .success(let image):
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    case .failure:
                                        Image(uiImage: .placeholderProfile)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    @unknown default:
                                        EmptyView()
                                    }
                                }
                            } else {
                                Image(uiImage: .placeholderProfile)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            }
                        }
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                        
                        VStack(alignment: .leading, spacing: 0){
                            Text(userDataViewModel.currentUser?.firstName ?? "")
                                .font(.title2)
                                .bold()
//                            Text("📍\(userDataViewModel.currentUser?.location ?? "No Location Found")")
                        }
                        Spacer()
                    }
                }
                List{
                    Text(userDataViewModel.currentUser?.email ?? "E-Mail")
                        .foregroundStyle(.gray)
                    Text(userDataViewModel.currentUser?.telNumber ?? "Tel. Number")
                        .foregroundStyle(.gray)


                }
                
            }
            
            
            
            .navigationBarTitleDisplayMode(.inline)
            .toolbar(content: {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel){
                        dismiss()
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
            Task {
                if let photosPickerItem = photosPickerItem,
                   let data = try? await photosPickerItem.loadTransferable(type: Data.self),
                   let image = UIImage(data: data),
                   let email = Auth.auth().currentUser?.email {
                    uploadProfileImage(image, forUser: email) { result in
                        switch result {
                        case .success(let url):
                            updateUserProfilePictureUrl(url, forEmail: email) { result in
                                switch result {
                                case .success():
                                    print("Profile picture updated successfully")
                                case .failure(let error):
                                    print("Error updating profile picture URL: \(error.localizedDescription)")
                                }
                            }
                        case .failure(let error):
                            print("Error uploading profile picture: \(error.localizedDescription)")
                        }
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
        .onAppear {
             userDataViewModel.fetchUserData(forUser: user)
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
