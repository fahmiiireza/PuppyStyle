//
//  BackgroundLogic.swift
//  DoggyStyle
//
//  Created by Felix Parey on 06/12/23.
//

import SwiftUI

@Observable
class BackgroundLogic{
    
    var path = NavigationPath()
    var addDogSheetPresented = false
    var profileSheetPresented = false
    var imageDataArray: [Data] = []
    var imageStorage: [UIImage] = []
    
}

@Observable
class imageConversion{
    
    var images: [UIImage] = []
    var urlStrings: [String] = []
    
    func uploadImages(images: [UIImage]) async {
        ForEach(images, id: \.self){ image in
            
        }
    }
    
}

@Observable
class DummyDogData{
    var images: [UIImage] = []
    var name: String = "Test"
    var gender: String = "Male"
    var breed: String = "Golden Retriever"
    var age: String = "12"
    var weight: String = "34.56"
    var size: String = "23.45"
    var allergies: String = "none"
    var vaccination: String = "none"
    var chronicdeseases: String = "none"
    var lastvetvisit: String = "none"
    var lenth: String = "wtf"
    var energylevel: String = "G+"
    var friendliness: String = "not friendly"
    var travelinglevel: String = "what even is this?"
}
