//
//  CreateAccountView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 16/12/23.
//

import SwiftUI
import FirebaseFirestore
import SwiftData
import FirebaseAuth
import PhotosUI

struct CreateAccountView: View {
    
    var locationViewModel = MapViewModel()
    @State private var profilePicture: UIImage = .placeholderProfile
    @State private var photosPickerItem: PhotosPickerItem?
    @State private var location: Location?
    @State private var telNr = ""
    @State private var firstName = ""
    @State private var lastName = ""
    
    var body: some View {
        NavigationStack{
            Form{
                
                
                PhotosPicker(selection: $photosPickerItem, matching: .images) {
                    Image(uiImage: profilePicture)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 70, height: 70)
                        .clipShape(Circle())
                }
                
                Button("Get my location"){
                    print("button clicked")
                    locationViewModel.checkLocationAuthorization()
                    Task {
                        await locationViewModel.checkIfLocationServiceIsEnabled()
            //            fetchUserSameCity()
                    }
                }
                
                TextField("First Name", text: $firstName)
                    .textContentType(.givenName)
                TextField("Last Name", text: $lastName)
                    .textContentType(.familyName)
                TextField("Tel. Number", text: $telNr)
            }
        }
    }
}

#Preview {
    CreateAccountView()
}
