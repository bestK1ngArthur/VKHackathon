//
//  AppManager.swift
//  HackathonApp
//
//  Created by a.belkov on 10/11/2018.
//  Copyright © 2018 bestK1ng. All rights reserved.
//

import Foundation
import Alamofire

class AppManager {

    var currentUserID: Int? {
        set {
            UserDefaults.standard.set(newValue, forKey: "user_id")
        }
        
        get {
            let id = UserDefaults.standard.integer(forKey: "user_id")
            if id == 0 {
                return nil
            } else {
                return nil
            }
        }
    }
    
    var currentUserName: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: "username")
        }
        
        get {
            return UserDefaults.standard.string(forKey: "username") ?? nil
        }
    }
}
