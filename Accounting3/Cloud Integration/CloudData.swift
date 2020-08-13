//
//  SwiftUIView.swift
//  Accounting3
//
//  Created by pc1 on 4/12/20.
//  Copyright © 2020 pc1. All rights reserved.
//
import SwiftUI
import CloudKit
 
struct  CloudData {
    
    @State private var retDict = Dictionary<String, Any>()
    @State var retArrs = [""]
    @State var sample = [CKRecord]()
    let database = CKContainer.default().publicCloudDatabase
    
      
    //MARK: SAVE TO CLOUD
    func saveToCloud(record: CKRecord, in database: CKDatabase) {
           database.save(record) { (recordIn, error) in
            print(error as Any)
                     guard recordIn != nil else {return}
                     print("Saved record")
                     
                 }
       }
    
    //MARK: INITIALIZE TO CLOUD
    func initializeNewRecord(name: String, in database: CKDatabase, v1: Double, v2: Double, v3: Double, data:NSData) {
        
        let recentV1 = CKRecord(recordType: name, recordID: CKRecord.ID(recordName: "\(name)v1"))
        recentV1.setValue(v1, forKey: "currentbalance")
        saveToCloud(record: recentV1, in: database)
        
        let recentV2 = CKRecord(recordType: name, recordID: CKRecord.ID(recordName: "\(name)v2"))
        recentV2.setValue(v2, forKey: "currentbalance")
        saveToCloud(record: recentV2, in: database)
        
        let recentV3 = CKRecord(recordType: name, recordID: CKRecord.ID(recordName: "\(name)v3"))
        recentV3.setValue(v3, forKey: "currentbalance")
        saveToCloud(record: recentV3, in: database)
        
        // Notes array
        let recentNote = CKRecord(recordType: name, recordID: CKRecord.ID(recordName: "\(name)NotesArray"))
        recentNote.setValue(data, forKey: "items")
        saveToCloud(record: recentNote, in: database)
        print("Saved notes array to cloud")
        
       
    }
    
    //MARK: SAVE CASH AMOUNT
    func initCashAmount(username: String, amount money: Double, in database: CKDatabase){
        let cashAmu = CKRecord(recordType: "\(username)cashAmount", recordID: CKRecord.ID(recordName: "\(username)cash"))
        cashAmu.setValue(money, forKey: "amount")
        saveToCloud(record: cashAmu, in: database)
    }
    
    //MARK: SAVE CASH AMOUNT
    func initCalendarRecord(username: String, data: NSData, in database: CKDatabase){
           let calRec = CKRecord(recordType: "\(username)calendarRecord", recordID: CKRecord.ID(recordName: "\(username)calendar"))
           calRec.setValue(data, forKey: "all")
           saveToCloud(record: calRec, in: database)
       }
    
    func initNamesList(username: String, data: [String]){
        let namRec = CKRecord(recordType: "\(username)Notes", recordID: (CKRecord.ID(recordName: "\(username)Names")))
        namRec.setValue(data, forKey: "name")
        saveToCloud(record: namRec, in: self.database)
    }
    
    func intializeNewUserRecord(user: Any){
        let intiUser = CKRecord(recordType: "Login", recordID: CKRecord.ID(recordName: "LoginAccounts"))
        intiUser.setValue(user, forKey: "info")
        saveToCloud(record: intiUser, in: self.database)
        
        print("init user record")
    }
    
   
    
    //MARK: EDIT OTHER RECORD FROM CLOUD
    func editFetchedOther(to database: CKDatabase, withRecordName: String, save element: Any, forKey: String){
           
           database.fetch(withRecordID:  CKRecord.ID(recordName: withRecordName)) { (uniRecord, error) in
                      
               if (error != nil) {
                   print(error ?? "failed")
               } else {
                   uniRecord?.setValue(element, forKey: forKey)
                   self.saveToCloud(record: uniRecord!, in: database)
                   print("edited \(withRecordName)")
                
               
               }
               
           }
       }
    

  
  
}

