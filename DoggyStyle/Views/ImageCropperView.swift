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
    @State var dog: Dog
    
    var body: some View {
        
        
            PhotosPicker(selection: $photosPickerItem, maxSelectionCount: 10, selectionBehavior: .ordered, matching: .images) {
                Text("Upload Images")
            }
            .onChange(of: photosPickerItem) { _, _ in
                Task{
                    
                     for item in photosPickerItem{
                         if let data = try? await item.loadTransferable(type: Data.self){
                             
                             dog.imageData.append(data)
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
    ImageCropperView(dog: Dog(imageNames: [""], name: "", gender: "", breed: "", age: "", weight: "", size: "", allergies: "", vaccination: "", chronicdeseases: "", lastvetvisit: "", lenth: "", energylevel: "", friendliness: "", travelinglevel: ""))
        .environment(DummyDogData())
}
