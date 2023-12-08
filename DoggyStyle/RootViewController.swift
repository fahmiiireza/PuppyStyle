//
//  RootViewController.swift
//  DoggyStyle
//
//  Created by Fahmi Fahreza on 06/12/23.
//

import Foundation
import UIKit

// Extension for UIApplication to access the current key window and root view controller
extension UIApplication {
    // Computed property to get the current key window
    var currentKeyWindow: UIWindow? {
        UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow }
            .first
    }
    
    // Computed property to get the root view controller
    var rootViewController: UIViewController? {
        currentKeyWindow?.rootViewController
    }
}
