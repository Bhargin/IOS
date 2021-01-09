//
//  Time.swift
//  Keeper
//
//  Created by Bhargin Kanani on 9/17/20.
//  Copyright © 2020 Bhargin Kanani. All rights reserved.
//

import SwiftUI

class Time {
    let date = Date()
    let calendar = Calendar.current
    var hour: Int
    var minute: Int
    var second: Int
    
    init() {    
        self.hour = calendar.component(.hour, from: date)
        self.minute = calendar.component(.minute, from: date)
        self.second = calendar.component(.second, from: date)
    }
    
    
}
