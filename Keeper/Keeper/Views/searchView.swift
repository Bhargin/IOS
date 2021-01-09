//
//  searchView.swift
//  Keeper
//
//  Created by Bhargin Kanani on 12/29/20.
//  Copyright © 2020 Bhargin Kanani. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

struct searchView: View {
    @Binding var returnHome: Bool
    @State var startDate = Date()
    @State var endDate = Date()
    @State var searchText = ""
    @State var morph = false
    @State var extendIndexes = [Int]()
    @State var extendTrue = true
    @State var extendFalse = false
    @State var contacts = [String]()
    @State var numbers = [String]()
    @State var contactIndexes = [String]()
    @State var tempNumbers = [String]()
    @State var tempContacts = [String]()
    @State var tappedNameSearch = false
    @State var searchAmount = ""
    @State var searchNote = ""
    @State var showDateFilterSheet = false
    @State var notesArray: [NoteType] = []
    @State var chosenSearchName = ""
    @State var showAlert = false
    var userNameFromHome: String
    
    let db = Firestore.firestore()
    
    var body: some View {
        
        ZStack {
            VStack {
                
                HStack {
                    Spacer()
                    Button(action: {self.returnHome = false}) {
                        Text("Done")
                            .font(Font.custom("TTFirsNeue-Medium", size: 20))
                            .alert(isPresented: self.$showAlert, content: {
                                Alert(title: Text("Error"), message: Text("Please search using one option!"), dismissButton: .default(Text("Ok")))
                            })
                    }
                    .foregroundColor(.black)
                }
                .padding(.horizontal)
                
                searchbar(text: self.$searchText, morph: self.$morph)
                    .animation(.spring())
                
                Text("")
                    .onAppear {
                        self.extendIndexes.removeAll()
                        
                        //MARK: QUERY Contacts
                        db.collection(userNameFromHome).document("Contacts").getDocument { (document, err) in
                            if let document = document {
                                
                                
                                if (document.data() != nil) {
                                    let dataDescription = document.data()!
                                    self.tempContacts = dataDescription["names"] as! [String]
                                    self.tempNumbers = dataDescription["numbers"] as! [String]
                                    self.contacts = dataDescription["names"] as! [String]
                                    self.numbers = dataDescription["numbers"] as! [String]
                                    print("Cached document data: \(self.contacts)")
                                }
                                else {
                                    print("Found nil")
                                }
                                
                            }
                            else {
                                db.collection(userNameFromHome).document("Contacts")
                                print("created document")
                            }
                        }
                    }
                    .sheet(isPresented: self.$showDateFilterSheet, onDismiss: {self.notesArray.removeAll()}){
                        ScrollView(showsIndicators: false){
                            VStack{
                                ForEach(self.notesArray.reversed(), id: \.self) { note in
                                    listview(item: note, userNameFromHome: userNameFromHome, extend: self.extendIndexes.contains(note.ID) ? self.$extendTrue:self.$extendFalse)
                                        .onTapGesture {
                                            
                                            if(self.extendIndexes.contains(note.ID)) {
                                                self.extendIndexes.remove(at: self.extendIndexes.firstIndex(of: note.ID) ?? 0)
                                            } else {
                                                self.extendIndexes.append(note.ID)
                                            }
                                        }
                                        .animation(.spring())
                                       
                                }
                            }
                        }
                        .padding(.vertical, 10)
                    }
               
                
                DatePicker("Select From: ", selection: self.$startDate)
                    .padding(.trailing, 50)
                    .padding(.leading, 10)
                    .font(Font.custom("TTFirsNeue-Medium", size: 17))
                    .offset(x: (self.searchText.count > 0) ? -500:0)
                    .animation(.spring())
                    
                
                DatePicker("Select To: ", selection: self.$endDate)
                    .padding(.trailing, 50)
                    .padding(.leading, 10)
                    .font(Font.custom("TTFirsNeue-Medium", size: 17))
                    .offset(x: (self.searchText.count > 0) ? -500:0)
                    .animation(.spring())
                
                //MARK: CONTACT LIST FOR FILTER
                ScrollView(showsIndicators: false) {
                    VStack {

                            if (self.contacts.isEmpty == false  && self.numbers.isEmpty == false){
                                ForEach(self.contacts.sorted{$0.self < $1.self}.filter {
                                    self.searchText.isEmpty ? true : $0.lowercased().contains(self.searchText.lowercased())
                                }, id: \.self){ name in
                                    contactListView(info: name, mobile: self.numbers[self.contacts.firstIndex(of: name)!], extend: self.contactIndexes.contains(name) ? self.$extendTrue:self.$extendFalse)
                                        .onTapGesture {
                                            self.chosenSearchName = name
                                            self.querywithName()
                                        }

                                }
                        }
                    }
                }
                .offset(x: (self.searchText.count > 0) ? 0 : 500, y: -80)
                .animation(.spring())
                
                TextField("Enter Amount", text: self.$searchAmount)
                    .foregroundColor(.black)
                    .font(Font.custom("TTFirsNeue-Medium", size: 20))
                    .offset(x: (self.searchText.count > 0) ? -500:0,  y: -430)
                    .padding(.leading)
                    .animation(.spring())
                    
                
                TextField("Enter Note", text: self.$searchNote)
                    .foregroundColor(.black)
                    .font(Font.custom("TTFirsNeue-Medium", size: 20))
                    .offset(x: (self.searchText.count > 0) ? -500:0, y: -430)
                    .padding(.leading)
                    .animation(.spring())
                    
                
                Spacer()
                
                Button(action: {
                    
                    if self.searchAmount.count > 0 && self.searchNote.count == 0{
                        self.querywithAmount()
                    } else if self.searchNote.count > 0 && self.searchAmount.count == 0{
                        self.querywithNote()
                    } else if  self.searchNote.count > 0 && self.searchAmount.count > 0{
                        self.showAlert = true
                    } else {
                        self.queryWithDate()
                    }
                    
                }) {
                    ZStack {
                        Circle()
                            .foregroundColor(.white)
                            .frame(width: 60, height: 60)
                            .shadow(radius: 3)
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                    }
                }
                .foregroundColor(.black)
              
               
            }
            .padding(.vertical)
            
        }
        
    }
    
    func querywithNote() {
        self.showDateFilterSheet = true
        db.collection(userNameFromHome).getDocuments { (QuerySnapshot, err) in
            if err == nil {
                for document in QuerySnapshot!.documents {
                    let data =  document.data()
                    
                    if data["Note"] != nil {
                    if (data["Note"] as! String).contains(self.searchNote) {
                    self.notesArray.append(NoteType(uniqid: data["ID"] as! Int, amount: data["Amount"] as! Double, name: data["Name"] as! String, note: data["Note"] as! String, time: data["Time"] as! Timestamp , transaction: data["Transaction"] as! String, ty: data["Type"] as! String, balance: data["currBal"] as! Double))
                    }
                    }
                    
                }
            }
        }

    }
    
    func querywithName() {
        self.showDateFilterSheet = true
        db.collection(userNameFromHome).whereField("Name", isEqualTo: self.chosenSearchName).getDocuments { (QuerySnapshot, err) in
            if err == nil {
                for document in QuerySnapshot!.documents {
                    let data =  document.data()
                    
                    self.notesArray.append(NoteType(uniqid: data["ID"] as! Int, amount: data["Amount"] as! Double, name: data["Name"] as! String, note: data["Note"] as! String, time: data["Time"] as! Timestamp , transaction: data["Transaction"] as! String, ty: data["Type"] as! String, balance: data["currBal"] as! Double))

                    
                }
            }
        }
    }
    
    func querywithAmount() {
        self.showDateFilterSheet = true
        let input = (searchAmount as NSString).doubleValue
        db.collection(userNameFromHome).whereField("Amount", isEqualTo: input).getDocuments { (QuerySnapshot, err) in
            if err == nil {
                for document in QuerySnapshot!.documents {
                    let data =  document.data()
                    
                    self.notesArray.append(NoteType(uniqid: data["ID"] as! Int, amount: data["Amount"] as! Double, name: data["Name"] as! String, note: data["Note"] as! String, time: data["Time"] as! Timestamp , transaction: data["Transaction"] as! String, ty: data["Type"] as! String, balance: data["currBal"] as! Double))

                    
                }
            }
        }
        
    }
    
    func queryWithDate() {
        
        self.showDateFilterSheet = true
        print("start date: \(self.startDate)................ end date: \(self.endDate)")
        let start = Timestamp(date: self.startDate)
        let end = Timestamp(date: self.endDate)
        
        print("TImestamp: \(start)")
        db.collection(userNameFromHome).whereField("Time", isGreaterThanOrEqualTo: start).getDocuments { (QuerySnapshot, err) in
            if err == nil {
                for document in QuerySnapshot!.documents {
                    let data =  document.data()
                    guard let stamp = data["Time"] as? Timestamp else {
                              return
                            }
                    let date = stamp.dateValue()
                    print("........................Timestamp: \(date)")
                    if date < self.endDate {
                    
                    self.notesArray.append(NoteType(uniqid: data["ID"] as! Int, amount: data["Amount"] as! Double, name: data["Name"] as! String, note: data["Note"] as! String, time: data["Time"] as! Timestamp , transaction: data["Transaction"] as! String, ty: data["Type"] as! String, balance: data["currBal"] as! Double))
                    }
                    
                }
            }
        }
    }
}

struct searchView_Previews: PreviewProvider {
    static var previews: some View {
        searchView(returnHome: .constant(true), userNameFromHome: "")
    }
}
