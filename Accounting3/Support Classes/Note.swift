//
//  Note.swift
//  Accounting3
//
//  Created by Bhargin Kanani on 4/29/20.
//  Copyright © 2020 pc1. All rights reserved.
//

import SwiftUI

class Note: NSObject, Identifiable, NSCoding {
  
    var id = UUID()
    var content: String
    var value: Double
    var type: String
    var date: String
    var name: String
    var additonalNote: String
    private var tempStringConversion = ""
    
    init(content: String, value: Double, type: String,date: String, name: String, additionalNote: String) {
        self.content = content
        self.value = value
        self.type = type
        self.date = date
        self.name = name
        self.additonalNote = additionalNote
        self.tempStringConversion = String(self.value)
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(content, forKey: "content")
        aCoder.encode(tempStringConversion, forKey: "amount")
        aCoder.encode(type, forKey: "type")
        aCoder.encode(date, forKey: "date")
        aCoder.encode(name, forKey: "name")
        aCoder.encode(additonalNote, forKey: "additionalNote")
      }
      
      required init?(coder aDecoder: NSCoder) {
        content = aDecoder.decodeObject(forKey: "content") as? String ?? "failed to decode content"
        tempStringConversion = aDecoder.decodeObject(forKey: "amount") as? String ?? "failed to decode value"
        type = aDecoder.decodeObject(forKey: "type") as? String ?? "failed to decode type"
        date = aDecoder.decodeObject(forKey: "date") as? String ?? "failed to decode date"
        name = aDecoder.decodeObject(forKey: "name") as? String ?? "failed to decode name"
        additonalNote = aDecoder.decodeObject(forKey: "additionalNote") as? String ?? "failed to decode additionalNote"
        
        self.value = Double(self.tempStringConversion)!
        
      }
      
}


