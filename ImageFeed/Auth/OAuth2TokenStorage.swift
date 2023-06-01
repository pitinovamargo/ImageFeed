//
//  OAuth2TokenStorage.swift
//  ImageFeed
//
//  Created by Margarita Pitinova on 29.05.2023.
//

import Foundation

class OAuth2TokenStorage {
    
    var token: String? {
        get {
            return UserDefaults.standard.string(forKey: "accessToken")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "accessToken")
        }
    }
}

