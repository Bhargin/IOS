//
//  HomeView.swift
//  Accounting3
//
//  Created by pc1 on 3/27/20.
//  Copyright © 2020 pc1. All rights reserved.
//

import SwiftUI
import CloudKit


struct HomeView: View {
    
    @State var filterCalendar = false
    @State var showHome = true
    @State var showAccountSearch = false
    @State var show = false
    @State var clickedOnStore = ""
    @State var showAdd = false
    @State var newStoreName = ""
    @State var showSearch = false
    @State var searchName = ""
    @State var found = false
    @State var clickedSearchedAccount = false
    @State var showCalendar = false
    @State var amount2 = ""
    @State var date = Date()
    @State private var now = Date()
    @State var storeName2 = ""
    @State var person2 = "Select person"
    @State private var selectorIndex = 0
    @State private var numbers = ["Cash", "Cheque"]
    @State var accounts = [String]()
    @State var cashAmount = 0.0
    @State var showNameSearch = false
    @State var v1 = 0.0
    @State var v2 = 0.0
    @State var v3 = 0.0
    @State private var filterAmount = ""
    @State var initil6 = [Note(content: "First Initialized Note", value: 0.0, type: "Add", date: "1/1/15", name: "Accounting3", additionalNote: "Welcome!")]
    @State private var searchText : String = ""
    @State private var searchAccountText : String = ""
    @State private var showAlert = false
    @State var showDuplicateAlert = false
    @State private var showSheet = false
    @State private var showSheet2 = false
    @State private var showSheet3 = false
    @State var how = ["+", "-", "?"]
    @State var choice = 0
    @State var returnToCalendar = false
    @State private var loginView = false
    @State private var Notes = [Note]()
    @State private var calendarRecord = [Note]()
    @State private var calendarNotesList = [Note]()
    @State private var filterName = ""
    @State private var returnToFilter = false
    @State private var showOptions = false
    @State private var optionsNoteContent = String()
    @State private var optionsNoteValue = String()
    @State private var date2 = String()
    @State private var optionsNoteAdditonalNote = String()
    @State private var optionsNoteType = String()
    @State private var optionsNotePaymentType = String()
    @State private var deleteFromOptionsAlert = false
    @State private var optionsNoteId = String()
    @State private var editNote = false
    @State private var optionNotePerson = String()
    @State private var showOptionSheet = false
    @State private var returnToShowSheet = false
    @State private var returnToShowSheet2 = false
    @State private var returnToShowSheet3 = false
    @State private var showLoader = false
    @State private var endDate = Date()
    @State private var recentlyAdded = String()
    @State private var editedNoteValue = String()
    @State private var editedNoteType = String()
    @State private var editedNotePaymentType = String()
    @State private var editedNoteAdditionalNote = String()
    @State private var editedNoteDate = String()
    @State private var editedNotePerson = String()
    @State private var calendarIndex = Int()
    @State private var notesIndex = Int()
    @State private var saveAlert = false
    let screen = UIScreen.main.bounds
    
    var username: String
    
    
    let ck = CloudData()
    let database = CKContainer.default().publicCloudDatabase
    
    
    var dateFormatter: String {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        
        return formatter1.string(from: self.date)
    }
    
    var newDateFormat: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MM/dd/yyyy"
        let showDate = inputFormatter.date(from: "\(self.dateFormatter)")
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let resultString = inputFormatter.string(from: showDate!)
        
        return resultString
    }
    
    var cashAmu: Double {
        return self.cashAmount
    }
    
    var body: some View {
        
        
        
        //MARK: SUPER ZSTACK
        ZStack {
            ZStack {
                Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
                
                Button(action: {
                    self.loginView = true
                    self.showHome = false
                }) {
                    Image(systemName: "power")
                        //.renderingMode(.original)
                        .foregroundColor(.primary)
                        .font(.system(size: 16, weight: .medium))
                        .frame(width: 50, height: 50)
                        .background(Color("background3"))
                        .clipShape(Circle())
                        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                }
                .offset(x: 150, y: showHome ? -350:-500)
                .animation(.spring())
                
                
                Text("Welcome \(self.username)")
                    .font(.title)
                    .fontWeight(.heavy)
                    .foregroundColor(.black)
                    .frame(width: 250, height: 80)
                    .offset(x: showHome ? -50 : -500, y: -350)
                
                
                
                //MARK: MAIN ZSTACK
                ZStack {
                    
                    
                    
                    //MARK: HOME BUTTONS
                    // Add new person button
                    Button(action: {
                        
                        self.fetchNamesList(withRecordName: "\(self.username)Names")
                        
                        self.showHome = false
                        self.showAdd = true
                        
                    }) {
                        
                        // ZSTACK CONTAINS CIRCLE AND PLUS IMAGE
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(#colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)))
                                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                            
                            Image(systemName: "person.badge.plus")
                                .resizable()
                                .frame(width: 43, height: 40)
                            
                        }
                        .frame(width: 150, height: 150)
                        
                        
                    }
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                    .offset(x: showHome ? -100 : -500, y: 100)
                    .animation(.spring())
                    .onAppear  {
                        
                        
                        if (self.accounts.count == 0 || self.accounts.isEmpty){
                            
                            //MARK: INIT CALENDAR MAP
                            self.initCashAmount(username: self.username ,amount: self.cashAmount, in: self.database)
                            print("initialized cash amount")
                            
                            if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: self.initil6, requiringSecureCoding: false){
                                
                                self.initCalendarRecord(username: self.username, data: savedData as NSData, in: self.database)
                                print("initialized calendar")
                            }
                            
                        }
                        
                    }
                    
                    
                    // Add Entry in Calendar Button
                    Button(action: {
                        DispatchQueue.main.async {
                            self.fetchCashAmount(from: self.database, withRecordName: "\(self.username)cash", key: "amount")
                            self.fetchCalendarRecord(from: self.database, withRecordName: "\(self.username)calendar", key: "all")
                            
                        }
                        self.showCalendar = true
                        self.showHome = false
                    }) {
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(#colorLiteral(red: 0.9120063186, green: 0.8949263692, blue: 0.3813914359, alpha: 1)))
                                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                            
                            Image(systemName: "calendar.badge.plus")
                                .resizable()
                                .frame(width: 60, height: 50)
                            
                        }
                        .frame(width: 150, height: 150)
                    }
                    .offset(x: showHome ? -100 : -500, y: -200)
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                    .animation(.spring())
                    
                    
                    // Filter in Calendar Button
                    Button(action: {
                        
                        self.showHome = false
                        self.fetchCalendarRecord(from: self.database, withRecordName: "\(self.username)calendar", key: "all")
                        self.filterCalendar = true
                        
                    }) {
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(#colorLiteral(red: 0.6276626587, green: 0.9202881455, blue: 0.9033475518, alpha: 1)))
                                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                            
                            Image(systemName: "list.bullet")
                                .resizable()
                                .frame(width: 60, height: 40)
                            
                        }
                        .frame(width: 150, height: 150)
                    }
                    .offset(x: showHome ? 100 : 500, y: -200)
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                    .animation(.spring())
                    
                    // View all Accounts Button
                    Button(action: {
                        self.fetchNamesList(withRecordName: "\(self.username)Names")
                        self.showAccountSearch = true
                        self.showHome = false
                        
                    }) {
                        ZStack {
                            
                            RoundedRectangle(cornerRadius: 10)
                                .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 0.6991117295)))
                                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                            
                            Image(systemName: "person.3")
                                .resizable()
                                .frame(width: 60, height: 30)
                                .foregroundColor(.white)
                            
                        }
                        .frame(width: 150, height: 150)
                        
                    }
                    .offset(x: showHome ? 100 : 500, y: 100)
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                    .animation(.spring())
                    .onAppear{
                        DispatchQueue.main.async {
                            self.fetchCashAmount(from: self.database, withRecordName: "\(self.username)cash", key: "amount")
                            self.fetchNamesList(withRecordName: "\(self.username)Names")
                        }
                    }
                    
                    //MARK: SHOW ADD
                    if showAdd{
                        ZStack{
                            Color.white
                                
                            .onTapGesture {
                                self.endEditing()
                            }
                            
                            // Background of TextField
                            RoundedRectangle(cornerRadius: 20)
                                .foregroundColor(Color(#colorLiteral(red: 0.9593952298, green: 0.9594177604, blue: 0.959405601, alpha: 1)))
                                .frame(width: 390, height: 85)
                                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                                .offset(y: -270)
                                .onTapGesture {
                                    self.endEditing()
                            }
                            
                            // "Enter New Name" Texfield
                            HStack {
                                TextField("Enter Person name here: ", text: $newStoreName) {
                                    self.endEditing()
                                }
                                    
                                .frame(width: 390, height: 85)
                            }
                            .frame(width: 390, height: 85)
                            .offset(y: -265)
                            .padding(.leading)
                            
                            // "Enter" Button
                            Button(action: {
                                
                                self.addStoreCard(name: self.newStoreName)
                                
                                
                            }) {
                                
                                ZStack {
                                    // Background of "Enter" button
                                    RoundedRectangle(cornerRadius: 20)
                                        .foregroundColor(Color(#colorLiteral(red: 0.03873530403, green: 0.9241017699, blue: 0.7897507548, alpha: 1)))
                                        .frame(width: 390, height: 45)
                                        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                                        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                                    
                                    // Text "Enter"
                                    Text("ENTER")
                                        .font(.system(size:25))
                                        .fontWeight(.regular)
                                        .foregroundColor(.white)
                                        .font(.headline)
                                    
                                    
                                }
                                
                            }
                            .offset(y: -200)
                            .alert(isPresented: $showDuplicateAlert) {
                                Alert(title: Text("Error!"), message: Text("You already have a account with same name. Please select another name!"), dismissButton: .default(Text("Ok")) {self.newStoreName = ""})
                            }
                            
                            
                        }
                        .animation(.spring())
                        .transition(.slide)
                        
                    }
                    //MARK: END SHOW ADD
                    
                    //MARK: ClOSE SHOW ADD BUTTON
                    Button(action: {
                        
                        if (self.returnToCalendar == false && self.returnToFilter == false){
                        self.showHome = true
                        }
                        self.showAdd = false
                        self.showCalendar = (self.returnToCalendar ? true:false)
                        self.filterCalendar = (self.returnToFilter ? true:false)
                      
                    
                        self.endEditing()
                    }) {
                        
                        // ZSTACK CONTAINS CIRCLE AND CROSS IMAGE
                        ZStack {
                            Circle()
                                .frame(width: 55, height: 60)
                                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                            
                            
                            
                            Image(systemName: "xmark")
                                .resizable()
                                .foregroundColor(.white)
                                .frame(width: 30, height: 30)
                            
                        }
                        
                    }
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                    .offset(x: 150, y: showAdd ? -370 : -500)
                    .animation(.easeInOut)
                    
                    //MARK: SHOW ACCOUNT LIST
                    if showAccountSearch {
                        
                            VStack {
                                HStack {
                                    Text("Accounts").font(.largeTitle).fontWeight(.heavy).foregroundColor(.black)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        
                                        self.showAccountSearch = false
                                        self.searchAccountText.removeAll()
                                        self.showAdd = true
                                        
                                        
                                    }) {
                                        Text("Add")
                                            .font(.system(size: 20))
                                    }
                                    .foregroundColor(.blue)
                                    .frame(width: 50, height: 50)
                                    .offset(x: -10)
                                    
                                    Spacer()
                                    
                                    Button(action: {
                                        self.person2 = "Select person"
                                        self.showAccountSearch = false
                                        self.searchAccountText.removeAll()
                                        self.showHome = true
                                        
                                    }) {
                                        Text("Close")
                                            .font(.system(size: 20))
                                    }
                                    .foregroundColor(.blue)
                                    .frame(width: 50, height: 50)
                                    .offset(x: -10)
                                }
                                .offset(y: 20)
                                .padding(.horizontal)
                                
                                TextField("Search person name here", text: $searchAccountText).padding(.leading)
                                
                                List {
                                    ForEach(self.accounts.sorted{$0.self < $1.self}.filter {
                                        self.searchAccountText.isEmpty ? true : $0.lowercased().contains(self.searchAccountText.lowercased())
                                    }, id: \.self) { name in
                                        ListNamesView(name: name)
                                            .onTapGesture {
                                                
                                                self.person2 = name
                                                self.clickedOnStore = name
                                                
                                                //MARK: NEED TO FETCH HERE
                                                
                                                self.show = true
                                                self.searchAccountText.removeAll()
                                                self.showAccountSearch = false
                                        }
                                        
                                    }
                                }
                            .environment(\.defaultMinListRowHeight, 30)
                            
                                
                            }
                        .foregroundColor(.red)
                             .offset(y: 30)
                            .frame(height: screen.height - 70)
                        .animation(.spring())
                        .transition(.slide)
                    }
                    
                    
                    //MARK: SHOW
                    if show {
                        
                        StoreAccountView(storeName: self.clickedOnStore, username: self.username)
                            .transition(.move(edge: .bottom))
                        
                    }
                    
                    
                    //MARK: ClOSE SHOW BUTTON
                    Button(action: {
                        self.show = false
                        self.person2 = "Select Person"
                        DispatchQueue.main.async {
                            self.fetchCashAmount(from: self.database, withRecordName: "\(self.username)cash", key: "amount")
                        }
                        
                        self.showHome = true
                    }) {
                        
                        // ZSTACK CONTAINS CIRCLE AND CROSS IMAGE
                        ZStack {
                            RoundedRectangle(cornerRadius: 20)
                                .frame(width: 80, height: 40)
                            
                            
                            Text("Home")
                                .foregroundColor(.white)
                                .frame(width: 60, height: 30)
                            
                        }
                        
                    }
                    .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                    .frame(width: 50, height: 55)
                    .offset(x: 150, y: show ? -382 : -500)
                    .animation(.easeInOut)
                    
                    //MARK: SHOW CALENDAR
                    if showCalendar {
                        
                        NavigationView {
                        Form{
                            
                            // Select person
                            Section(header: Text("Person Name")) {
                                Button(action: {
                                    
                                    self.showNameSearch = true
                                    self.showCalendar = false
                                    self.returnToCalendar = true
                                    
                                }) {
                                    HStack{
                                        
                                        Text("\(self.person2)")
                                            .multilineTextAlignment(.center)
                                        
                                    }
                                    .padding(.trailing).frame(width: screen.width)
                                }
                            }
                            
                            
                            // Extra note and amount
                            Section {
                                TextField("Enter extra note:", text: $storeName2) {
                                    self.endEditing()
                                }
                                .frame(width: 400, height: 40)
                                .padding(.leading)
                                
                                TextField("Enter Amount:", text: self.$amount2) {
                                    self.endEditing()
                                }
                                .padding(.leading)
                                .frame(width: 300, height: 40)
                            }
                            
                            // Cash and Cheque picker
                            Section {
                                Picker("Numbers", selection: $selectorIndex) {
                                    ForEach(0 ..< numbers.count) { index in
                                        Text(self.numbers[index]).tag(index)
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            
                            // Date picker
                            Section(footer: Text("Note: Tap box to change date")) {
                                DatePicker("Select Date:", selection: $date, displayedComponents: .date)
                                    .padding(.horizontal)
                                    .onTapGesture {
                                        self.date = self.date
                                }
                            }
                            
                            // Add/Min/Pend picker
                            Section {
                                Picker(selection: $choice, label: Text("Where do you want to add the entry")) {
                                    
                                    ForEach(self.how.indices, id: \.self) { int in
                                        
                                        Text(self.how[int]).tag(int)
                                        
                                    }
                                }
                                .pickerStyle(SegmentedPickerStyle())
                            }
                            
                            
                            // Save button
                            Button(action: {
                                
                                if (self.person2 == "Select person" || self.amount2 == "") {
                                    self.showAlert = true
                                    
                                } else {
                                    
                                    self.saveAlert = true
                                    
                                    
                                    
                                }
                                
                                
                            }) {
                                Text("Save")
                                    .offset(x: 170)
                                    .alert(isPresented: self.$showAlert) {
                                        Alert(title: Text("Error!"), message: Text("Both Amount and Person cannot be blank"), dismissButton: .default(Text("Ok")))
                                }
                                
                                
                            }
                            
                            
                            // Cancel Button
                            Button(action: {
                                self.showCalendar = false
                                self.showHome = true
                                self.date = self.now
                                self.choice = 0
                                self.selectorIndex = 0
                                self.person2 = "Select Person"
                                self.storeName2 = ""
                                self.amount2 = ""
                                self.Notes.removeAll()
                                self.returnToCalendar = false
                            }) {
                                Text("Cancel")
                                    .offset(x: 163)
                                    .alert(isPresented: self.$saveAlert){
                                        Alert(title: Text("Are you sure you want to save this?"), message: Text("\(self.dateFormatter) - \(self.person2) - \(self.storeName2) - \(self.numbers[self.selectorIndex]) - \(self.how[self.choice])$\(self.amount2)"), primaryButton: .default(Text("Save")) {
                                            // If Add
                                            if (self.how[self.choice] == "+") {
                                                
                                                
                                                if (self.person2 == "Select person" || (self.amount2 == "" || self.amount2.isEmpty)){
                                                    self.showAlert = true
                                                    
                                                } else {
                                                    
                                                    // Record Dictionary
                                                    if(self.numbers[self.selectorIndex] == "Cash") {
                                                        self.cashAmount += Double(self.amount2) ?? 0.0
                                                        self.v1 += Double(self.amount2)!
                                                        
                                                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                                                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.person2.replacingOccurrences(of: " ", with: ""))v1", save: self.v1, forKey: "currentbalance")
                                                    }
                                                    
                                                    // UUID and NOTE STRUCT PROGRAM /////////
                                                    let ent = Note(content: "\(self.dateFormatter) - \(self.person2) - \(self.storeName2) - \(self.numbers[self.selectorIndex]) - +$\(self.amount2)", value: Double(self.amount2)!, type: "Add", date: self.dateFormatter, name: self.person2, additionalNote: self.storeName2)
                                                    
                                                    
                                                    
                                                    self.Notes.append(ent)
                                                    self.calendarRecord.append(ent)
                                                    
                                                    print ("New note id: \(ent.id)")
                                                    
                                                    
                                                    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: self.Notes, requiringSecureCoding: false) {
                                                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.person2.replacingOccurrences(of: " ", with: ""))NotesArray", save: savedData as NSData, forKey: "items")
                                                        print("convereted to NSDATA")
                                                    }
                                                    
                                                    if let savedDataCal = try? NSKeyedArchiver.archivedData(withRootObject: self.calendarRecord, requiringSecureCoding: false) {
                                                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)calendar", save: savedDataCal as NSData, forKey: "all")
                                                        print("convereted to Cal to NSDATA")
                                                        self.recentlyAdded = ent.content
                                                    }
                                                    
                                                }
                                                
                                                
                                                
                                            }
                                            
                                            // If Minus
                                            if (self.how[self.choice] == "-") {
                                                
                                                
                                                if self.amount2 == "" || self.person2 == "Select person"{
                                                    self.showAlert = true
                                                } else {
                                                    
                                                    // Record Dictionary
                                                    if(self.numbers[self.selectorIndex] == "Cash") {
                                                        self.cashAmount -= Double(self.amount2) ?? 0.0
                                                        
                                                        self.v2 += Double(self.amount2) ?? 0.0
                                                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                                                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.person2.replacingOccurrences(of: " ", with: ""))v2", save: self.v2, forKey: "currentbalance")
                                                    }
                                                    
                                                    // UUID and NOTE STRUCT PROGRAM /////////
                                                    let ent = Note(content: "\(self.dateFormatter) - \(self.person2) - \(self.storeName2) - \(self.numbers[self.selectorIndex]) - -$\(self.amount2)", value: Double(self.amount2) ?? 0.0, type: "Minus", date: self.dateFormatter, name: self.person2, additionalNote: self.storeName2)
                                                    
                                                    self.Notes.append(ent)
                                                    self.calendarRecord.append(ent)
                                                    
                                                    
                                                    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: self.Notes, requiringSecureCoding: false) {
                                                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.person2.replacingOccurrences(of: " ", with: ""))NotesArray", save: savedData as NSData, forKey: "items")
                                                        print("convereted to NSDATA")
                                                        
                                                    }
                                                    
                                                    if let savedDataCal = try? NSKeyedArchiver.archivedData(withRootObject: self.calendarRecord, requiringSecureCoding: false) {
                                                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)calendar", save: savedDataCal as NSData, forKey: "all")
                                                        print("convereted to Cal to NSDATA")
                                                        self.recentlyAdded = ent.content
                                                    }
                                                    
                                                }
                                                
                                            }
                                            
                                            // If Pending
                                            if ((self.how[self.choice] == "?")) {
                                                
                                                
                                                //Record Dictonary
                                                if self.amount2 == "" || self.person2 == "Select person"{
                                                    self.showAlert = true
                                                    
                                                } else {
                                                    self.v3 += Double(self.amount2) ?? 0.0
                                                    self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.person2.replacingOccurrences(of: " ", with: ""))v3", save: self.v3, forKey: "currentbalance")
                                                    
                                                    // UUID and NOTE STRUCT PROGRAM /////////
                                                    let ent = Note(content: "\(self.dateFormatter) - \(self.person2) - \(self.storeName2) - \(self.numbers[self.selectorIndex]) - $\(self.amount2)?", value: Double(self.amount2) ?? 0.0, type: "Pending", date: self.dateFormatter, name: self.person2, additionalNote: self.storeName2)
                                                    
                                                    self.Notes.append(ent)
                                                    self.calendarRecord.append(ent)
                                                    
                                                    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: self.Notes, requiringSecureCoding: false) {
                                                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.person2.replacingOccurrences(of: " ", with: ""))NotesArray", save: savedData as NSData, forKey: "items")
                                                        print("convereted to NSDATA")
                                                        
                                                    }
                                                    
                                                    if let savedDataCal = try? NSKeyedArchiver.archivedData(withRootObject: self.calendarRecord, requiringSecureCoding: false) {
                                                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)calendar", save: savedDataCal as NSData, forKey: "all")
                                                        print("convereted to Cal to NSDATA")
                                                        self.recentlyAdded = ent.content
                                                    }
                                                    
                                                    
                                                    
                                                }
                                                
                                                
                                            }
                                            
                                            self.choice = 0
                                            self.selectorIndex = 0
                                            self.person2 = "Select person"
                                            self.storeName2.removeAll()
                                            self.amount2 = ""
                                            self.Notes.removeAll()
                                            self.date = Date()
                                            self.returnToCalendar = false
                                            self.saveAlert = false
                                            
                                            
                                            
                                            }, secondaryButton: .default(Text("Cancel"), action: {
                                                
                                                self.saveAlert = false
                                            }))
                                }
                                
                            }
                            .foregroundColor(.red)
                            
                            Section(header: Text("Recently Added")) {
                                Text(self.recentlyAdded)
                            }
                        
                        }
                        .navigationBarTitle("Calendar")
                        .navigationBarItems(leading: Button(action: {
                            self.showCalendar = false
                            self.showHome = true
                            self.date = self.now
                            self.choice = 0
                            self.selectorIndex = 0
                            self.person2 = "Select Person"
                            self.storeName2 = ""
                            self.amount2 = ""
                            self.Notes.removeAll()
                            self.returnToCalendar = false
                        }) {
                            
                            HStack {
                                Image(systemName: "chevron.left")
                                    .resizable()
                                    .frame(width: 10, height: 15)
                                Text("Back")
                                    .font(.system(size: 23, weight: .medium, design: .default))
                            }
                        })
                        }
                       
                        .frame(width: screen.width , height: screen.height - 20)
                        .offset(y: 80)
                        .animation(.spring())
                        .transition(.slide)
                        
                        
                        
                    }
                    
                }
                .edgesIgnoringSafeArea(.all)
                //MARK: END MAIN ZSTACK
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(Color(#colorLiteral(red: 0.7200976014, green: 0.9323262572, blue: 0.7635449767, alpha: 1)))
                    
                    
                    Text("$\(String(format: "%.2f", self.cashAmu))")
                        .font(.system(size: 30, weight: .medium, design: .monospaced))
                        .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                }
                .frame(width: 370, height: 80)
                .offset(x: showHome ? 0 : 500, y: 300)
                .animation(.spring())
                
                //MARK: FILTER CALENDAR
                if filterCalendar {
                    Form {
                        
                        // Close filter calendar button
                        Button(action: {
                            self.filterCalendar = false
                            self.returnToFilter = false
                            self.person2 = "Select person"
                            self.showHome = true
                            self.endEditing()
                            self.date = Date()
                            self.endDate = Date()
                            self.filterAmount.removeAll()
                        }) {
                            
                            
                            // ZSTACK CONTAINS CIRCLE AND CROSS IMAGE
                            ZStack {
                                Circle()
                                    .frame(width: 50, height: 55)
                                    .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                                
                                
                                
                                
                                Image(systemName: "arrow.uturn.left")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 25, height: 25)
                                
                            }
                            
                            
                        }
                        .foregroundColor(Color(#colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)))
                        .frame(width: 50, height: 55)
                        .animation(.spring())
                        
                        // Date filter
                        Section {
                        
                        // Date picker
                        DatePicker("Select Date:", selection: $date, displayedComponents: .date)
                            .padding(.horizontal)
                            
                        // Date picker
                        DatePicker("Select End Date:", selection: $endDate, displayedComponents: .date)
                        .padding(.horizontal)
                            
                        // Continue
                        Button(action: {
                            
                            self.calendarNotesList.removeAll()
                            
                            // UUID Integration ///////////////
                            for note in self.calendarRecord.sorted(by: {$0.date.compare($1.date) == .orderedAscending}){
                                if ((self.date...self.endDate).contains(self.convertToDate(dateIn: note.date))) || (note.date == self.dateFormatter){
                                    self.calendarNotesList.append(note)
                                }
                            }
                            self.endEditing()
                            self.showSheet = true
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                Text("Filter")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .medium, design: .default))
                            }
                        }
                        .frame(width: screen.width - 50, height: 50)
                        .sheet(isPresented: $showSheet) {
                            
                            NavigationView {
                                List{
                                    ForEach(self.calendarNotesList.indices, id: \.self) { item in
                                        ListView(note: self.calendarNotesList[item])
                                            .onLongPressGesture {
                                                self.showSheet = false
                                                self.returnToShowSheet = true
                                                
                                                self.optionsNoteContent = self.calendarNotesList[item].content
                                                self.optionsNoteId = self.calendarNotesList[item].id.uuidString
                                                self.optionsNoteValue = String(self.calendarNotesList[item].value)
                                                self.date2 = self.calendarNotesList[item].date
                                                self.optionNotePerson = self.calendarNotesList[item].name
                                                self.optionsNoteType = self.calendarNotesList[item].type
                                                self.optionsNoteAdditonalNote = self.calendarNotesList[item].additonalNote
                                                
                                                 self.fetchCashAmount(from: self.database, withRecordName: "\(self.username)cash", key: "amount")
                                                self.fetchCalendarRecord(from: self.database, withRecordName: "\(self.username)calendar", key: "all")
                                                self.fetchNotesArrayFromCloud(record: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))NotesArray")
                                                
                                                 
                                                self.fetchOther(record: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))v1")
                                                
                                                
                                                self.fetchOther(record: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))v2")
                                                
                                                
                                                self.fetchOther(record: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))v3")
                                                
                                                
                                                self.showOptions = true
                                        }
                                    }
                                    
                                }
                                .navigationBarTitle("Filtered Results")
                                .navigationBarItems(trailing: Text("$\(String(format: "%.2f", self.cashAmount))"))
                            }
                        }
                        
                        }
                        
                        // Value filter
                        Section {
                        // Value textfield
                        TextField("Enter Amount to filter", text: $filterAmount){
                            self.endEditing()
                        }
                        .padding(.leading)
                        
                        // Value Countinue button
                        Button(action: {
                            
                            // UUID Integration ///////////////
                            self.calendarNotesList.removeAll()
                            
                            for note in self.calendarRecord.sorted(by: {$0.date < $1.date }){
                                if (note.value == Double(self.filterAmount)!) {
                                    self.calendarNotesList.append(note)
                                }
                            }
                            self.showSheet2 = true
                            self.endEditing()
                            
                            
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                Text("Filter")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .medium, design: .default))
                            }
                        }
                        .frame(width: screen.width - 50, height: 50)
                        .sheet(isPresented: $showSheet2) {
                            
                            NavigationView {
                                List{
                                    ForEach(self.calendarNotesList.indices, id: \.self) { item in
                                        ListView(note: self.calendarNotesList[item])
                                            .onLongPressGesture {
                                                self.showSheet2 = false
                                                self.returnToShowSheet2 = true
                                                
                                                self.optionsNoteContent = self.calendarNotesList[item].content
                                                self.optionsNoteId = self.calendarNotesList[item].id.uuidString
                                                self.optionsNoteValue = String(self.calendarNotesList[item].value)
                                                self.date2 = self.calendarNotesList[item].date
                                                self.optionNotePerson = self.calendarNotesList[item].name
                                                self.optionsNoteType = self.calendarNotesList[item].type
                                                self.optionsNoteAdditonalNote = self.calendarNotesList[item].additonalNote
                                                
                                                self.fetchCashAmount(from: self.database, withRecordName: "\(self.username)cash", key: "amount")
                                                self.fetchCalendarRecord(from: self.database, withRecordName: "\(self.username)calendar", key: "all")
                                                self.fetchNotesArrayFromCloud(record: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))NotesArray")
                                                
                                                
                                                self.fetchOther(record: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))v1")
                                                
                                                
                                                self.fetchOther(record: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))v2")
                                                
                                                
                                                self.fetchOther(record: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))v3")
                                                
                                                
                                                self.showOptions = true
                                        }
                                    }
                                    
                                }
                                .navigationBarTitle("Filtered Results")
                                .navigationBarItems(trailing: Text("$\(String(format: "%.2f", self.cashAmount))"))
                            }
                        }
                        }
                        
                        // Additional Note filter
                        Section {
                        // Name Continue button
                        Button(action: {
                            self.calendarNotesList.removeAll()
                            
                            self.showNameSearch = true
                            self.returnToFilter = true
                            self.filterCalendar = false
                            self.endEditing()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10)
                                Text("Filter by name: \(self.person2)")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20, weight: .medium, design: .default))
                            }
                        }
                        .frame(width: screen.width - 50, height: 50)
                        .sheet(isPresented: $showSheet3){
                            
                            NavigationView {
                                List{
                                    ForEach(self.calendarNotesList.indices, id: \.self) { item in
                                        ListView(note: self.calendarNotesList[item])
                                            .onLongPressGesture {
                                                self.showSheet3 = false
                                                self.returnToShowSheet3 = true
                                                
                                                self.optionsNoteContent = self.calendarNotesList[item].content
                                                self.optionsNoteId = self.calendarNotesList[item].id.uuidString
                                                self.optionsNoteValue = String(self.calendarNotesList[item].value)
                                                self.date2 = self.calendarNotesList[item].date
                                                self.optionNotePerson = self.calendarNotesList[item].name
                                                self.optionsNoteType = self.calendarNotesList[item].type
                                                self.optionsNoteAdditonalNote = self.calendarNotesList[item].additonalNote
                                                
                                                self.fetchCashAmount(from: self.database, withRecordName: "\(self.username)cash", key: "amount")
                                                self.fetchCalendarRecord(from: self.database, withRecordName: "\(self.username)calendar", key: "all")
                                                self.fetchNotesArrayFromCloud(record: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))NotesArray")
                                                self.fetchOther(record: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))v1")
                                                self.fetchOther(record: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))v2")
                                               self.fetchOther(record: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))v3")
                                                self.showOptions = true
                                        }
                                    }
                                    
                                }
                                .navigationBarTitle("Filtered Results")
                                 .navigationBarItems(trailing: Text("$\(String(format: "%.2f", self.cashAmount))"))
                            }
                            
                        }
                        }
                        
                        
                        
                    }
                    .animation(.spring())
                    .transition(.slide)
                    
                }
                
                if showNameSearch {
                    
                        VStack {
                            HStack {
                                Text("Accounts").font(.largeTitle).fontWeight(.heavy).foregroundColor(.black)
                                Spacer()
                                Button(action: {
                                    self.showAdd = true
                                    self.showNameSearch = false
                                    self.searchAccountText.removeAll()
                                    
                                    
                                    
                                    
                                }) {
                                    Text("Add")
                                        .font(.system(size: 20))
                                }
                                .foregroundColor(.blue)
                                .frame(width: 50, height: 50)
                                .offset(x: -10)
                                
                                Button(action: {
                                    self.showNameSearch = false
                                    self.searchAccountText.removeAll()
                                    self.showCalendar = (self.returnToCalendar ? true : false)
                                    self.filterCalendar = (self.returnToFilter ? true : false)
                                }) {
                                    Text("Close")
                                        .font(.system(size: 20))
                                }
                                .foregroundColor(.blue)
                                .frame(width: 50, height: 50)
                                .offset(x: -10)
                            }
                            .offset(y: 20)
                            .padding(.horizontal)
                            
                            
                            TextField("Search person name here", text: $searchAccountText).padding(.leading)
                                .onTapGesture {
                                    self.endEditing()
                            }
                            List {
                                ForEach(self.accounts.sorted{$0.self < $1.self}.filter {
                                    self.searchAccountText.isEmpty ? true : $0.lowercased().contains(self.searchAccountText.lowercased())
                                }, id: \.self) { name in
                                    ListNamesView(name: name)
                                        .frame(width: 400, height: 35)
                                        .font(.system(size: 25))
                                        .onTapGesture {
                                            self.endEditing()
                                            if self.returnToFilter {
                                                
                                                self.person2 = name
                                                self.clickedOnStore = name
                                                
                                                self.filterCalendar = (self.returnToFilter ? true:false)
                                                 
                                                
                                                if self.filterCalendar {
                                                for note in self.calendarRecord.sorted(by: {$0.date < $1.date }) {
                                                    if note.name == self.person2{
                                                        self.calendarNotesList.append(note)
                                                    }
                                                }
                                                }
                                                
                                                self.showSheet3 = true
                                                self.showNameSearch = false
                                               
                                            }
                                            
                                            self.person2 = name
                                            self.clickedOnStore = name
                                            
                                            
                                            //MARK: NEED TO FETCH DATA HERE
                                            
                                            self.fetchNotesArrayFromCloud(record: "\(self.username)\(self.person2.replacingOccurrences(of: " ", with: ""))NotesArray")
                                            self.fetchOther(record: "\(self.username)\(self.person2.replacingOccurrences(of: " ", with: ""))v1")
                                            self.fetchOther(record: "\(self.username)\(self.person2.replacingOccurrences(of: " ", with: ""))v2")
                                            self.fetchOther(record: "\(self.username)\(self.person2.replacingOccurrences(of: " ", with: ""))v3")
                                            
                                            self.showNameSearch = false
                                            self.searchAccountText.removeAll()
                                            self.showCalendar = (self.returnToCalendar ? true : false)
                                    }
                                }
                            }
                             .environment(\.defaultMinListRowHeight, 30)
                            
                        }
                    
                    .foregroundColor(.red)
                .offset(y: 0)
                            .frame(height: screen.height - 70)
                    .animation(.spring())
                    .transition(.slide)
                }
                
                if loginView {
                    LoginView()
                        .transition(.slide)
                        .animation(.spring())
                }
                
                
                //MARK: SHOW OPTIONS
                if showOptions{
                    OptionsView(content: self.optionsNoteContent)
                        .transition(.slide)
                        .animation(.spring())
                        .onAppear {
                            self.endEditing()
                    }
                    
                    HStack(spacing: 0) {
                        
                        // Edit button
                        Button(action: {
                            
                            if self.optionsNoteContent.contains("- Cash -") {
                                self.selectorIndex = 0
                            }
                            
                            if self.optionsNoteContent.contains("- Cheque -") {
                                self.selectorIndex = 1
                            }
                            
                            if self.optionsNoteType == "Add" {
                                self.choice = 0
                                print("before edit type: Add")
                            }
                            
                            if self.optionsNoteType == "Minus" {
                                self.choice = 1
                                print("before edit type: Minus")
                            }
                            
                            if self.optionsNoteType == "Pending" {
                                self.choice = 2
                                print("before edit type: Pending")
                            }
                            
                            self.editedNoteDate = self.date2
                            self.editedNoteValue = self.optionsNoteValue
                            self.editedNoteAdditionalNote = self.optionsNoteAdditonalNote
                            self.editedNotePerson = self.optionNotePerson
                            
                            self.fetchCashAmount(from: self.database, withRecordName: "\(self.username)cash", key: "amount")
                            self.fetchCalendarRecord(from: self.database, withRecordName: "\(self.username)calendar", key: "all")
                            self.fetchNotesArrayFromCloud(record: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))NotesArray")
                            self.fetchOther(record: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))v1")
                            self.fetchOther(record: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))v2")
                               self.fetchOther(record: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))v3")
                                                                           
                            
                            self.editNote = true
                            self.showOptions = false
                        }) {
                            ZStack {
                                
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(.yellow)
                                Text("Edit")
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 350/2, height: 50)
                        .offset(y: 100)
                       
                        // Delete button
                        Button(action: {
                            self.deleteFromOptionsAlert = true
                            
                        }) {
                            ZStack {
                                
                                RoundedRectangle(cornerRadius: 5)
                                    .foregroundColor(.red)
                                Text("Delete")
                                    .foregroundColor(.white)
                            }
                        }
                        .frame(width: 350/2, height: 50)
                        .offset(y: 100)
                        .alert(isPresented: self.$deleteFromOptionsAlert){
                            Alert(title: Text("Are you sure you want to delete this?"), message: Text(self.optionsNoteContent), primaryButton: .destructive(Text("Delete")) {
                                
                                for note in self.calendarRecord {
                                    
                                    if (note.content == self.optionsNoteContent){
                                       
                                        print("Found one note in calendar")
                                        
                                        
                                        
                                        let idx = self.calendarRecord.firstIndex(of: note)
                                        

                                        if note.content.contains("- Cash -") && note.type == "Add"{
                                            self.v1 -= note.value
                                            self.cashAmount -= note.value
                                            
                                           
                                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))v1", save: self.v1, forKey: "currentbalance")
                                        }
                                        
                                        if note.content.contains("- Cash -") && note.type == "Minus"{
                                            self.v2 -= note.value
                                            self.cashAmount += note.value
                                            
                                            
                                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))v2", save: self.v2, forKey: "currentbalance")
                                        }
                                        
                                        if note.content.contains("- Cash -") && note.type == "Pending"{
                                            self.v3 -= note.value
                                            
                                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))v3", save: self.v3, forKey: "currentbalance")
                                        }
                                        
                                        
                                        
                                        self.calendarRecord.remove(at: idx!)
                                        
                                        
                                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                                        
                                        
                                        if let savedDataCal = try? NSKeyedArchiver.archivedData(withRootObject: self.calendarRecord, requiringSecureCoding: false) {
                                            
                                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)calendar", save: savedDataCal as NSData, forKey: "all")
                                            
                                            print("convereted to Cal to NSDATA")
                                        }
                                        
                                        break
                                        
                                    }
                                }
                                
                                for note in self.Notes {
                                    
                                   
                                    if (note.content == self.optionsNoteContent) {
                                        print("Found note in personal notes")
                                        let idx = self.Notes.firstIndex(of: note)
                                        
                                        self.Notes.remove(at: idx!)
                                        
                                        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: self.Notes, requiringSecureCoding: false) {
                                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))NotesArray", save: savedData as NSData, forKey: "items")
                                            print("convereted to NSDATA")
                                            
                                        }
                                        
                                        break
                                        
                                    }
                                }
                                
                                for note in self.calendarNotesList {
                                    
                                    if (note.content == self.optionsNoteContent) {
                                        let idx = self.calendarNotesList.firstIndex(of: note)
                                        self.calendarNotesList.remove(at: idx!)
                                        break
                                    }
                                }
                                
                                if self.returnToShowSheet == true {
                                    self.showSheet = true
                                    self.returnToShowSheet = false
                                }
                                
                                if self.returnToShowSheet2 == true {
                                    self.showSheet2 = true
                                    self.returnToShowSheet2 = false
                                }
                                
                                if self.returnToShowSheet3 == true {
                                    self.showSheet3 = true
                                    self.returnToShowSheet3 = false
                                }
                                
                                self.optionNotePerson.removeAll()
                                self.optionsNoteId.removeAll()
                                self.optionsNoteValue.removeAll()
                                self.optionsNoteContent.removeAll()
                                self.optionsNoteType.removeAll()
                                
                                
                                self.showOptions = false
                                }, secondaryButton: .cancel())
                        }
                        
                        
                    }
                    .transition(.slide)
                    .animation(.spring())
                    
                    Button(action: {
                        
                        if self.returnToShowSheet == true {
                            self.showSheet = true
                            self.returnToShowSheet = false
                        }
                        
                        if self.returnToShowSheet2 == true {
                            self.showSheet2 = true
                            self.returnToShowSheet2 = false
                        }
                        
                        if self.returnToShowSheet3 == true {
                            self.showSheet3 = true
                            self.returnToShowSheet3 = false
                        }
                        
                        self.showOptions = false
                        
                        
                    }) {
                        Image(systemName: "arrow.left.circle")
                            .resizable()
                        
                    }
                    .foregroundColor(.black)
                    .frame(width: 30, height: 30)
                    .offset(x: -150, y: -85)
                    .transition(.slide)
                    .animation(.spring())
                }
                
                //MARK: SHOW EDIT
                Form {
                    
                    
                    
                    Section(header: Text("MM/DD/YY")) {
                        TextField("Enter Date", text: $editedNoteDate)
                    }
                    
                    Section(header: Text("Additional Note")){
                        TextField("Enter additional note", text: self.$editedNoteAdditionalNote)
                    }
                    
                    Section(header: Text("Amount")) {
                        TextField("Enter amount", text: self.$editedNoteValue)
                    }
                    
                    
                    // Cash and Cheque picker
                    Section {
                        Picker("Numbers", selection: self.$selectorIndex) {
                            ForEach(0 ..< numbers.count) { index in
                                Text(self.numbers[index]).tag(index)
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Add, minus, pending
                    Section {
                        Picker("Where do you want to add the entry", selection: self.$choice) {
                            
                            ForEach(self.how.indices, id: \.self) { int in
                                
                                Text(self.how[int]).tag(int)
                                
                            }
                        }
                        .pickerStyle(SegmentedPickerStyle())
                    }
                    
                    // Save button
                    Button(action: {
                        
                        print("///////////////////////////EDIT/////////////////////")
                        
                        if self.how[self.choice] == "+" {
                            self.editedNoteType = "Add"
                        }
                        
                       if self.how[self.choice] == "-" {
                            self.editedNoteType = "Minus"
                        }
                        
                        if self.how[self.choice] == "?" {
                            self.editedNoteType = "Pending"
                        }
                                                
                        let ent2 = Note(content: "\(self.editedNoteDate) - \(self.editedNotePerson) - \(self.editedNoteAdditionalNote) - \(self.numbers[self.selectorIndex]) - $\(self.editedNoteValue)", value: Double(self.editedNoteValue) ?? 0.0, type: self.editedNoteType, date: self.editedNoteDate, name: self.editedNotePerson, additionalNote: self.editedNoteAdditionalNote)
                        
                        print("New note type: \(self.editedNoteType)")
                        
                        for note in self.calendarRecord {
                            
                            if (self.optionsNoteContent == note.content) {
                                
                                print("Found one note to edit in calendar")
                                
                                
                                  
                                    let idx = self.calendarRecord.firstIndex(of: note)
                                    self.calendarIndex = idx!
                                    
                                    
                                    if note.content.contains("- Cash -") && note.type == "Add"{
                                        self.v1 -= note.value
                                        self.cashAmount -= note.value
                                        print("/////////: \(note.value)")
                                        
                                        
                                    }
                                    
                                    if note.content.contains("- Cash -") && note.type == "Minus"{
                                        self.v2 -= note.value
                                        self.cashAmount += note.value
                                        
                                        
                                       
                                    }
                                    
                                    if note.content.contains("- Cash -") && note.type == "Pending"{
                                        self.v3 -= note.value
                                        
                                        
                                    }
                                    
                                    
                                    
                                    self.calendarRecord.remove(at: idx!)
                                
                                
                                
                                    break
                                    
                            }
                            
                        }
                        
                        for note in self.Notes {
                                                          
                                                         
                                                          if (note.content == self.optionsNoteContent) {
                                                              print("Found one note to edit in personal notes")
                                                              let idx = self.Notes.firstIndex(of: note)
                                                            self.notesIndex = idx!
                                                              
                                                              self.Notes.remove(at: idx!)
                                                             
                                                              
                                                              break
                                                              
                                                          }
                                                      }
                        
                      
                     
                        
                        // If Add
                        if (ent2.type == "Add") {
                            
                            
                            
                                // Record Dictionary
                            if(ent2.content.contains("- Cash -")) {
                                self.cashAmount += Double(ent2.value)
                                    self.v1 += Double(ent2.value)
                                    
                                    self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                                    self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))v1", save: self.v1, forKey: "currentbalance")
                                }
                                
                               
                                
                            self.Notes.insert(ent2, at: self.notesIndex)
                            self.calendarRecord.insert(ent2, at: self.calendarIndex)
                                
                                
                               
                                
                                if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: self.Notes, requiringSecureCoding: false) {
                                    self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))NotesArray", save: savedData as NSData, forKey: "items")
                                    print("convereted to NSDATA")
                                }
                                
                                if let savedDataCal = try? NSKeyedArchiver.archivedData(withRootObject: self.calendarRecord, requiringSecureCoding: false) {
                                    self.editFetchedOther(to: self.database, withRecordName: "\(self.username)calendar", save: savedDataCal as NSData, forKey: "all")
                                    print("convereted to Cal to NSDATA")
                                     
                                }
                                
                            
                            
                            
                            
                        }
                        
                        // If Minus
                        if (ent2.type == "Minus") {
                            
                            
                           
                                
                                // Record Dictionary
                            if(ent2.content.contains("- Cash -")) {
                                    self.cashAmount -= Double(ent2.value)
                                    
                                    self.v2 += Double(ent2.value)
                                    self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                                    self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))v2", save: self.v2, forKey: "currentbalance")
                                }
                                
                               
                            self.Notes.insert(ent2, at: self.notesIndex)
                            self.calendarRecord.insert(ent2, at: self.calendarIndex)
                                 
                                
                                if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: self.Notes, requiringSecureCoding: false) {
                                    self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))NotesArray", save: savedData as NSData, forKey: "items")
                                    print("convereted to NSDATA")
                                    
                                }
                                
                                if let savedDataCal = try? NSKeyedArchiver.archivedData(withRootObject: self.calendarRecord, requiringSecureCoding: false) {
                                    self.editFetchedOther(to: self.database, withRecordName: "\(self.username)calendar", save: savedDataCal as NSData, forKey: "all")
                                    print("convereted to Cal to NSDATA")
                                    
                                }
                                
                            
                            
                        }
                        
                        // If Pending
                        if (ent2.type == "Pending") {
                            
                            
                            //Record Dictonary
                           
                            self.v3 += Double(ent2.value)
                                self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))v3", save: self.v3, forKey: "currentbalance")
                                
                             
                            self.Notes.insert(ent2, at: self.notesIndex)
                            self.calendarRecord.insert(ent2, at: self.calendarIndex)
                                
                                if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: self.Notes, requiringSecureCoding: false) {
                                    self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.optionNotePerson.replacingOccurrences(of: " ", with: ""))NotesArray", save: savedData as NSData, forKey: "items")
                                    print("convereted to NSDATA")
                                    
                                }
                                
                                if let savedDataCal = try? NSKeyedArchiver.archivedData(withRootObject: self.calendarRecord, requiringSecureCoding: false) {
                                    self.editFetchedOther(to: self.database, withRecordName: "\(self.username)calendar", save: savedDataCal as NSData, forKey: "all")
                                    print("convereted to Cal to NSDATA")
                                    
                                }
                                
                                
                                
                            
                            
                            
                        }
                        
                        if self.returnToShowSheet {
                                
                                self.calendarNotesList.removeAll()
                                                           
                                                           // UUID Integration ///////////////
                                                           for note in self.calendarRecord.sorted(by: {$0.date < $1.date }){
                                                               if ((self.date...self.endDate).contains(self.convertToDate(dateIn: note.date))) || (note.date == self.dateFormatter){
                                                                   self.calendarNotesList.append(note)
                                                               }
                                                           }
                        }
                        
                        if self.returnToShowSheet2 {
                            // UUID Integration ///////////////
                            self.calendarNotesList.removeAll()
                            
                            for note in self.calendarRecord{
                                if (note.value == Double(self.filterAmount)!) {
                                    self.calendarNotesList.append(note)
                                }
                            }
                        }
                        
                        if self.returnToShowSheet3 {
                            self.calendarNotesList.removeAll()
                            
                            for note in self.calendarRecord.sorted(by: {$0.date < $1.date }) {
                                                                               if note.name == self.person2{
                                                                                   self.calendarNotesList.append(note)
                                                                               }
                                                                           }
                        }
                                
                                if self.returnToShowSheet == true {
                                    self.showSheet = true
                                    self.returnToShowSheet = false
                                }
                                
                                if self.returnToShowSheet2 == true {
                                    self.showSheet2 = true
                                    self.returnToShowSheet2 = false
                                }
                                
                                if self.returnToShowSheet3 == true {
                                    self.showSheet3 = true
                                    self.returnToShowSheet3 = false
                                }
                                
                        self.editedNoteValue.removeAll()
                        self.editedNoteType.removeAll()
                        self.editedNotePaymentType.removeAll()
                        self.editedNoteAdditionalNote.removeAll()
                        self.editedNoteDate.removeAll()
                        self.editedNotePerson.removeAll()
                        self.optionNotePerson.removeAll()
                        self.optionsNoteId.removeAll()
                        self.optionsNoteValue.removeAll()
                        self.optionsNoteContent.removeAll()
                        self.optionsNoteType.removeAll()
                        
                        
                    self.editNote = false
                          
                        
                        
                        
                        
                    }) {
                        Text("Save")
                            .offset(x: 170)
                    }
                    
                    // Cancel Button
                    Button(action: {
                        if self.returnToShowSheet == true {
                            self.showSheet = true
                            self.returnToShowSheet = false
                        }
                        
                        if self.returnToShowSheet2 == true {
                            self.showSheet2 = true
                            self.returnToShowSheet2 = false
                        }
                        
                        if self.returnToShowSheet3 == true {
                            self.showSheet3 = true
                            self.returnToShowSheet3 = false
                        }
                        
                      self.editedNoteValue.removeAll()
                                               self.editedNoteType.removeAll()
                                               self.editedNotePaymentType.removeAll()
                                               self.editedNoteAdditionalNote.removeAll()
                                               self.editedNoteDate.removeAll()
                                               self.editedNotePerson.removeAll()
                                               self.optionNotePerson.removeAll()
                                               self.optionsNoteId.removeAll()
                                               self.optionsNoteValue.removeAll()
                                               self.optionsNoteContent.removeAll()
                                               self.optionsNoteType.removeAll()
                        self.editNote = false
                    }) {
                        Text("Cancel")
                            .offset(x: 163)
                        
                    }
                    .foregroundColor(.red)
                    
                    
                }
                .frame(width: screen.width, height: screen.height - 70 )
                .offset(x: editNote ? 0 : 500)
            }
            
            //MARK: LOADER
            if self.showLoader {
                ZStack {
                    if self.showLoader {
                        GeometryReader { _ in
                            Loader()
                        }
                        .background(Color.black.opacity(0.45).edgesIgnoringSafeArea(.all))
                    }
                }
            }
            
        }
        .edgesIgnoringSafeArea(.all)
        //MARK: END SUPER ZSTACK
        
        
        
    }
    
    
    
    //MARK: ADD NEW NAME FUNC
    func addStoreCard(name: String) {
        
        if self.accounts.contains(name){
            self.showDuplicateAlert = true
            self.newStoreName = ""
        } else {
            
            if self.accounts.count == 0 {
                
                self.accounts.append(name)
                self.initNamesList(username: self.username, data: self.accounts)
               
                
                if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: initil6, requiringSecureCoding: false) {
                    self.initializeNewRecord(name: "\(self.username)\(name.replacingOccurrences(of: " ", with: ""))", in: self.database, v1: 0.0, v2: 0.0, v3: 0.0, data: savedData as NSData)
                    
                }
                
                self.newStoreName = ""
                self.person2 = name
                self.clickedOnStore = name
                
                if returnToCalendar == true {
                    self.showCalendar = true
                }
                if returnToFilter == true {
                    self.filterCalendar = true
                }
                
                self.showAdd = false
                self.showHome = false
                
            } else {
                
                self.accounts.append(name)
                
                self.editFetchedOther(to: self.database, withRecordName: "\(self.username)Names", save: self.accounts, forKey: "name")
                
                if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: initil6, requiringSecureCoding: false) {
                    self.initializeNewRecord(name: "\(self.username)\(name.replacingOccurrences(of: " ", with: ""))", in: self.database, v1: 0.0, v2: 0.0, v3: 0.0, data: savedData as NSData)
                    print("convereted to NSDATA")
                }
                
                self.newStoreName = ""
                self.person2 = name
                self.clickedOnStore = name
                
                 if returnToCalendar == true {
                                  self.showCalendar = true
                              }
                              if returnToFilter == true {
                                  self.filterCalendar = true
                              }
                if (returnToCalendar == false && returnToFilter == false) {
                    self.show = true
                }
                self.showAdd = false
                self.showHome = false
                
            }
        }
    }
    
    
    func fetchCashAmount(from database: CKDatabase, withRecordName: String, key: String){
        
        self.showLoader = true
        database.fetch(withRecordID:  CKRecord.ID(recordName: withRecordName)) { (cashRecord, error ) in
            
            if ((error) != nil){
                print(error!)
                
            } else {
                
                self.cashAmount = cashRecord?.value(forKeyPath: key) as! Double
            }
            
            self.showLoader = false
        }
        print("retreived cash amount")
        
    }
    
    func fetchNamesList(withRecordName: String) {
        self.accounts.removeAll()
        self.database.fetch(withRecordID: CKRecord.ID(recordName: "\(self.username)Names")) { (nameRecord, error) in
            if((error) != nil) {
                print(error!)
            } else {
                self.accounts = nameRecord?.value(forKeyPath: "name") as! [String]
            }
            print("got all notes")
        }
    }
    
    func fetchOther(record name: String){
        
        self.showLoader = true
        
        if name.contains("v1") {
            self.database.fetch(withRecordID: CKRecord.ID(recordName: name)) { (fetchedRecord, error) in
                if ((error) != nil) {
                    print(error!)
                }
                else {
                    
                    self.v1 = (fetchedRecord?.value(forKeyPath: "currentbalance") as! Double)
                    print("self v1 = \(self.v1)")
                    
                }
            }
        }
        
        if name.contains("v2") {
            self.database.fetch(withRecordID: CKRecord.ID(recordName: name)) { (fetchedRecord, error) in
                if ((error) != nil) {
                    print(error!)
                }
                else {
                    
                    self.v2 = (fetchedRecord?.value(forKeyPath: "currentbalance") as! Double)
                    print("self v2 = \(self.v2)")
                    
                }
            }
        }
        
        if name.contains("v3") {
            self.database.fetch(withRecordID: CKRecord.ID(recordName: name)) { (fetchedRecord, error) in
                if ((error) != nil) {
                    print(error!)
                }
                else {
                    
                    self.v3 = (fetchedRecord?.value(forKeyPath: "currentbalance") as! Double)
                    print("self v3 = \(self.v3)")
                    
                }
            }
        }
        
        self.showLoader = false
    }
    
    func convertToDate(dateIn: String) -> Date {
            
                   let dateFormatter = DateFormatter()
                   dateFormatter.dateFormat = "MM/dd/yy"
                 let date = dateFormatter.date(from: dateIn)!
                 return date
               
             
             }
    
    func fetchNotesArrayFromCloud(record name: String){
        
        self.showLoader = true
        database.fetch(withRecordID: CKRecord.ID(recordName: name)) { (uniRecord2, Err) in
            
            if Err != nil {
                print(Err!)
            } else {
                
                if let decodedNotes = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(uniRecord2?.value(forKeyPath: "items") as! Data) as? [Note] {
                    self.Notes = decodedNotes
                    print(decodedNotes)
                    print("Fetched Notes Array from Cloud")
                }
            }
            
            self.showLoader = false
        }
    }
    
    func fetchCalendarRecord(from database: CKDatabase, withRecordName: String, key: String) {
        
        self.showLoader = true
        database.fetch(withRecordID:  CKRecord.ID(recordName: withRecordName)) { (calendarRec, Err) in
            if Err != nil {
                print(Err!)
            } else {
                
                if let decodedNotes = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(calendarRec?.value(forKeyPath: key) as! Data) as? [Note] {
                    self.calendarRecord = decodedNotes
                    print(decodedNotes)
                }
                
            }
            
            self.showLoader = false
        }
        print("retreived calendar record")
    }
    
    //MARK: EDIT OTHER RECORD FROM CLOUD
     func editFetchedOther(to database: CKDatabase, withRecordName: String, save element: Any, forKey: String){
             self.showLoader = true
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
    
    //MARK: SAVE TO CLOUD
       func saveToCloud(record: CKRecord, in database: CKDatabase) {
      
              database.save(record) { (recordIn, error) in
                
              
               print(error as Any)
                        guard recordIn != nil else {return}
                print("Saved record with record type: \(record.recordType) and record name: \(record.recordID.recordName)")
                        self.showLoader = false
                    }
          }
    
    func initNamesList(username: String, data: [String]){
        self.showLoader = true
          let namRec = CKRecord(recordType: "\(username)", recordID: (CKRecord.ID(recordName: "\(username)Names")))
          namRec.setValue(data, forKey: "name")
          saveToCloud(record: namRec, in: self.database)
        
        self.Notes = initil6
      }
    
    //MARK: SAVE CASH AMOUNT
       func initCashAmount(username: String, amount money: Double, in database: CKDatabase){
        self.showLoader = true
           let cashAmu = CKRecord(recordType: "\(username)", recordID: CKRecord.ID(recordName: "\(username)cash"))
           cashAmu.setValue(money, forKey: "amount")
           saveToCloud(record: cashAmu, in: database)
       }
       
       //MARK: SAVE CASH AMOUNT
       func initCalendarRecord(username: String, data: NSData, in database: CKDatabase){
        self.showLoader = true
              let calRec = CKRecord(recordType: "\(username)", recordID: CKRecord.ID(recordName: "\(username)calendar"))
              calRec.setValue(data, forKey: "all")
              saveToCloud(record: calRec, in: database)
          }
    
    //MARK: INITIALIZE TO CLOUD
      func initializeNewRecord(name: String, in database: CKDatabase, v1: Double, v2: Double, v3: Double, data:NSData) {
        
        self.showLoader = true
          
          let recentV1 = CKRecord(recordType: "\(username)", recordID: CKRecord.ID(recordName: "\(name)v1"))
          recentV1.setValue(v1, forKey: "currentbalance")
          saveToCloud(record: recentV1, in: database)
          
          let recentV2 = CKRecord(recordType: "\(username)", recordID: CKRecord.ID(recordName: "\(name)v2"))
          recentV2.setValue(v2, forKey: "currentbalance")
          saveToCloud(record: recentV2, in: database)
          
          let recentV3 = CKRecord(recordType: "\(username)", recordID: CKRecord.ID(recordName: "\(name)v3"))
          recentV3.setValue(v3, forKey: "currentbalance")
          saveToCloud(record: recentV3, in: database)
          
          // Notes array
          let recentNote = CKRecord(recordType: "\(username)", recordID: CKRecord.ID(recordName: "\(name)NotesArray"))
          recentNote.setValue(data, forKey: "items")
          saveToCloud(record: recentNote, in: database)
          print("Saved notes array to cloud")
          

         self.Notes = initil6
      }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    
    struct HomeView_Previews: PreviewProvider {
        static var previews: some View {
            HomeView(username: "Ramesh")
        }
    }
    
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


