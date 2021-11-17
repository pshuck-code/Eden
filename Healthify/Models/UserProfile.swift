//
//  UserProfile.swift
//  Healthify
//
//  Created by Parker Shuck on 6/12/20.
//  Copyright © 2020 Parker Shuck. All rights reserved.
//

import Foundation

class UserProfile {
    var uid:String
    var username:String
    var photoURL:URL
    
    init(uid:String, username:String,photoURL:URL) {
        self.uid = uid
        self.username = username
        self.photoURL = photoURL
    }
}
