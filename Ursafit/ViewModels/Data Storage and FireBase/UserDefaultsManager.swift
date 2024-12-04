//
//  UserDefaultsManager.swift
//  Ursafit
//
//  Created by Miguel Fernandez on 12/1/24.
//

import SwiftUI
import SwiftData

class UserDefaultsManager {
    static let shared = UserDefaultsManager()
    private let defaults = UserDefaults.standard
    
    private let userLoggedInKey = "isUserLoggedIn"
    private let userIDKey = "userID"
    
    func setUserLoggedIn(userID: String, email: String? = nil) {
        defaults.set(true, forKey: userLoggedInKey)
        defaults.set(userID, forKey: userIDKey)
        if let email = email {
            defaults.set(email, forKey: "userEmail")
        }
    }
    
    func isUserLoggedIn() -> Bool {
        return defaults.bool(forKey: userLoggedInKey)
    }
    
    func getUserID() -> String? {
        return defaults.string(forKey: userIDKey)
    }
}
