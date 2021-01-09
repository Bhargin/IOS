//
//  NoteType.swift
//  Keeper
//
//  Created by Bhargin Kanani on 10/15/20.
//  Copyright © 2020 Bhargin Kanani. All rights reserved.
//
import Firebase
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
import SwiftUI

struct NoteType: Hashable{
   
    var UUID: UUID
    var ID: Int
    var Amount: Double
    var Name: String
    var Note: String
    var Time: Timestamp
    var Transation: String
    var type: String
    var balance: Double
    
    init(uniqid: Int, amount: Double, name: String, note: String, time: Timestamp, transaction: String, ty: String, balance: Double) {
        self.ID = uniqid
        self.Amount = amount
        self.Name = name
        self.Note = note
        self.Time = time
        self.Transation = transaction
        self.type = ty
        self.UUID = Foundation.UUID()
        self.balance = balance
    }
    
}


