//
//  BackgroundLogic.swift
//  DoggyStyle
//
//  Created by Felix Parey on 06/12/23.
//

import SwiftUI

@Observable
class BackgroundLogic{
    
    
    var backgroundImage = Image(.placeholderProfile)
    var path = NavigationPath()
    var addDogSheetPresented = false
    var profileSheetPresented = false
    var tinderPresented = false
    var mapPresented = false
    var imageDataArray: [Data] = []
    var imageStorage: [UIImage] = []
    var scrollPosition: Dog? = nil
    var userJustSignedUp = true
    
}


