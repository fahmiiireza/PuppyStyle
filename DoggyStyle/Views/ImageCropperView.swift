//
//  ImageCropperView.swift
//  DoggyStyle
//
//  Created by Felix Parey on 10/12/23.
//

import SwiftUI
import PhotosUI

struct ImageCropperView: View {
    
    @Environment(DummyDogData.self) private var dummyDog
    @State private var profilePicture: [UIImage] = []
    @State private var photosPickerItem: [PhotosPickerItem] = []
    
    var body: some View {
        
        
            PhotosPicker(selection: $photosPickerItem, maxSelectionCount: 10, selectionBehavior: .ordered, matching: .images) {
                Text("Upload Images")
            }
            .onChange(of: photosPickerItem) { _, _ in
                Task{
                    
                     for item in photosPickerItem{
                         if let data = try? await item.loadTransferable(type: Data.self){
                            if let image = UIImage(data: data){
                                dummyDog.images.append(image)
                            }
                        }
                     }
                }
            }
    }
}

#Preview {
    ImageCropperView()
        .environment(DummyDogData())
}
