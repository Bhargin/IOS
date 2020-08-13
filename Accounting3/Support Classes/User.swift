//
//  User.swift
//  Accounting3
//
//  Created by Bhargin Kanani on 5/11/20.
//  Copyright © 2020 pc1. All rights reserved.
//

import SwiftUI

class User: NSObject, Identifiable, NSCoding {
     var username: String
     var password: String
    
    init(username: String, password: String){
        self.username = username
        self.password = password
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(self.username, forKey: "username")
        aCoder.encode(self.password, forKey: "password")
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.username = aDecoder.decodeObject(forKey: "username") as? String ?? "Failed to decode username"
        
        self.password = aDecoder.decodeObject(forKey: "password") as? String ?? "Failed to decode password"
    }
    
    
}

