//
//  StoreAccountView.swift
//  Accounting3
//
//  Created by pc1 on 3/28/20.
//  Copyright © 2020 pc1. All rights reserved.
//

import SwiftUI
import CloudKit

struct StoreAccountView: View {
    @State var amount = ""
    @State var storeName = ""
    @State var username = ""
    @State var additonalNote = ""
    @State var date = Date()
    @State private var endDate = Date()
    @State private var now = Date()
    @State var showAddSummary = false
    @State var showMinusSummary = false
    @State var showPendingSummary = false
    @State private var showingAlert = false
    @State private var showingAlert2 = false
    @State private var showingAlert3 = false
    @State private var showingAlert4 = false
    @State private var selectorIndex = 0
    @State private var index = 0
    @State private var numbers = ["Cash", "Cheque"]
    @State private var how = ["+", "-", "?"]
    @State var showCard = false
    @State private var choice = 0
    @State private var saveAlert = false
    
    @State var emptyDict = [String: [String]]()
    @State var temporary3 = [String]()
    
    @State var cashAmount = Double()
    
    // String and number
    @State var record = [String]()
    @State var record2 = ["0.0"]
    
    var cash = "Cash"
    
    
    @State var results2 = [Double]()
    @State var pop = false
    @State var showDelete = false
    @State var showFilter = false
    @State var v1 = 0.0
    @State var v2 = 0.0
    @State var v3 = 0.0
    
    
    @State private var showSheet = false
    @State private var showSheet2 = false
    @State private var showAlert = false
    @State var longPressed = false
    @State var detailText = ""
    
    @State var tempAmount = 0.0
    @State var editAmountBindingString = ""
    @State var editAdditionalNoteString = String()
    @State var tempAdditionalNote = ""
    @State private var Notes = [Note]()
    @State var showTestSheet = false
    @State var showTestSheet2 = false
    @State var showTestSheet3 = false
    @State var returnToFilter = false
    @ObservedObject private var notesList = NotesList()
    @State var showOptions = false
    @State var tempOptionsNote = ""
    @State var edit = false
    @State var accountViewDeleteNoteId = ""
    @State var date2 = ""
    @State private var optionNoteType = ""
    @State private var NotesSummary = [Note]()
    @State private var sortedNotes = [Note]()
    @State private var calendarRecord = [Note]()
    @State private var showLoader = false
    @State private var newEditedNoteDate = String()
    @State private var newEditedNoteValue = String()
    @State private var newEditedNoteAdditionalNote = String()
    @State private var newEditedNoteType = String()
    @State private var newEditedNotePaymentType = String()
    @State private var newEditedNotePerson = String()
    @State private var calendarIndex = Int()
    @State private var notesIndex = Int()
    @State private var recentlyAdded = String()
    
    
    let ck = CloudData()
    let database = CKContainer.default().publicCloudDatabase
    
    
    
    var dateFormatter: String {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        
        return formatter1.string(from: self.date)
    }
    
    var endDateFormatter: String {
           let formatter1 = DateFormatter()
           formatter1.dateStyle = .short
           
           return formatter1.string(from: self.endDate)
       }
    
  
    
    var newDateFormat: String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "MM/dd/yyyy"
        let showDate = inputFormatter.date(from: "\(self.dateFormatter)")
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let resultString = inputFormatter.string(from: showDate!)
        
        return resultString
    }
    
   var endNewDateFormat: String {
          let inputFormatter = DateFormatter()
          inputFormatter.dateFormat = "MM/dd/yyyy"
    let showDate = inputFormatter.date(from: "\(self.endDateFormatter)")
          inputFormatter.dateFormat = "yyyy-MM-dd"
          let resultString = inputFormatter.string(from: showDate!)
          
          return resultString
      }
    
    
    
    
    var body: some View {
        
        //MARK: SUPER ZSTACK
        ZStack {
            
            
            
            //MARK: MAIN ZSTACK
            ZStack {
                Color(#colorLiteral(red: 0.6807169914, green: 0.9276310802, blue: 0.8304732442, alpha: 1))
                
                
                //MARK: TOP HALF
                VStack  {
                    
                    // Name HStack
                    HStack {
                        Text("\(self.storeName)")
                            .font(.system(size: 50, weight: .black, design: .default))
                            .foregroundColor(.white)
                            .onAppear {
                                
                                
                                    self.fetchNotesArrayFromCloud(record: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))NotesArray")
                                    self.fetchCashAmount(from: self.database, withRecordName: "\(self.username)cash", key: "amount")
                                    self.fetchOther(record: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v1")
                                    self.fetchOther(record: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v2")
                                    self.fetchOther(record: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v3")
                                    
                                
                                
                        }
                        
                        Spacer()
                    }
                    .padding(.leading)
                    Spacer()
                    
                    Text("Current Balance:")
                        .font(.system(size: 25, weight: .light, design: .default))
                        .foregroundColor(Color(#colorLiteral(red: 0.5787474513, green: 0.3215198815, blue: 0, alpha: 1)))
                        .offset(x: -100, y: 40)
                    
                    
                    // Amount/Summary HStack
                    VStack(alignment: .leading, spacing: 10) {
                        
                        Button(action: {
                            
                            self.sortedNotes = self.Notes.sorted(by:  { $0.date < $1.date })
                            self.NotesSummary.removeAll()
                            
                            for note in self.sortedNotes {
                                if note.type == "Add" {
                                    self.NotesSummary.append(note)
                                }
                            }
                            
                            
                            self.showAddSummary = true
                            
                        }) {
                            Text("+$\(String(format: "%.2f", self.v1))")
                                .font(.system(size: 25, weight: .bold, design: .default))
                                .foregroundColor(Color(#colorLiteral(red: 0.1960784346, green: 0.3411764801, blue: 0.1019607857, alpha: 1)))
                                .multilineTextAlignment(.leading)
                        }
                        
                        Button(action: {
                            
                            self.sortedNotes = self.Notes.sorted(by:  { $0.date < $1.date })
                            self.NotesSummary.removeAll()
                            
                            for note in self.sortedNotes {
                                if note.type == "Pending" {
                                    self.NotesSummary.append(note)
                                }
                            }
                            
                            
                            self.showPendingSummary = true
                            
                        }) {
                            Text("  $\(String(format: "%.2f", self.v3))")
                                .font(.system(size: 25, weight: .bold, design: .default))
                                .foregroundColor(Color(#colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)))
                                .multilineTextAlignment(.leading)
                        }
                        
                        Button(action: {
                            self.sortedNotes = self.Notes.sorted(by:  { $0.date < $1.date })
                            self.NotesSummary.removeAll()
                            
                            for note in self.sortedNotes {
                                if note.type == "Minus" {
                                    self.NotesSummary.append(note)
                                }
                            }
                            
                            self.showMinusSummary = true
                            
                        }) {
                            Text("-$\(String(format: "%.2f", self.v2))")
                                .font(.system(size: 25, weight: .bold, design: .default))
                                .foregroundColor(Color(#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)))
                                .multilineTextAlignment(.leading)
                        }
                        
                    }
                    .offset(x:-110,y: 50)
                    
                    // Three vertical buttons
                    VStack(spacing: 10) {
                        
                        // Add new
                        Button(action: {
                            self.longPressed = false
                            self.fetchCashAmount(from: self.database, withRecordName: "\(self.username)cash", key: "amount")
                            self.fetchCalendarRecord(from: self.database, withRecordName: "\(self.username)calendar", key: "all")
                            self.pop = true
                            
                        }) {
                            ZStack {
                                Circle()
                                Image(systemName: "plus")
                                    .resizable()
                                    .foregroundColor(.white)
                                    .frame(width: 30, height: 30)
                            }
                        }
                        .frame(width: 50, height: 50)
                        .foregroundColor(.black)
                        
                        
                        
                        // Delete
                        Button(action: {
                           
                            self.showDelete = true}) {
                                ZStack {
                                    Circle()
                                    Image(systemName: "trash")
                                        .resizable()
                                        .foregroundColor(.white)
                                        .frame(width: 30, height: 30)
                                }
                        }
                        .frame(width: 50, height: 50)
                        .foregroundColor(.black)
                    }
                    .offset(x: 150, y: -160)
                    .animation(.spring())
                    
                }
                .padding(.top)
                .frame(width: screen.width, height: 340)
                .offset(y: -245)
                //MARK: END TOP HALP
                
                //MARK: SUMMARY SLIDE
                ZStack {
                    
                    // Slide background
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundColor(.white)
                    
                    NavigationView {
                        List{
                            ForEach(self.Notes.reversed(), id: \.self) { note in
                                ListView(note: note)
                                    .onLongPressGesture {
                                        self.tempOptionsNote = note.content
                                        self.accountViewDeleteNoteId = note.id.uuidString
                                        self.date2 = note.date
                                        self.editAdditionalNoteString = note.additonalNote
                                        self.editAmountBindingString = String(note.value)
                                        self.optionNoteType = note.type
                                    
                                        self.newEditedNoteDate = note.date
                                        self.newEditedNoteAdditionalNote = note.additonalNote
                                        self.newEditedNoteValue = String(note.value)
                                        self.newEditedNotePerson = note.name
                                        
                                        
                                        
                                        self.showOptions = true
                                         self.fetchCalendarRecord(from: self.database, withRecordName: "\(self.username)calendar", key: "all")
                                         self.fetchCashAmount(from: self.database, withRecordName: "\(self.username)cash", key: "amount")
                                        
                                         self.fetchNotesArrayFromCloud(record: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))NotesArray")
                                        print("Fetched cash amount: \(self.cashAmount)")
                                        
                                        
                                        
                                        
                                }
                            }
                            
                        }
                        .navigationBarTitle("Recently Added")
                        .navigationBarItems(trailing: Text("$\(String(format: "%.2f", self.cashAmount))"))
                    }
                    
                    
                }
                .frame(width: screen.width, height: screen.height/2 + 80)
                .offset(y: 190)
                .animation(.spring())
                
                //MARK: END SUMMARY SLIDE
                
                
                
                
                //MARK: NEW ENTRY POP-UP
                ZStack{
                    Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.9297677654))
                    NavigationView {
                Form{
                    
                    // Extra note and amount
                    Section {
                        TextField("Enter extra note:", text: $additonalNote) {
                            self.endEditing()
                        }
                            .frame(width: 400, height: 40)
                            .padding(.leading)
                        
                        TextField("Enter Amount:", text: self.$amount) {
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
                        
                        if self.amount == "" || self.amount.isEmpty {
                            self.showAlert = true
                        } else {
                            self.saveAlert = true
                        }
                        
                       
                        
                       
                        
                       
                    }) {
                        Text("Save")
                            .offset(x: 170)
                            .alert(isPresented: self.$showAlert) {
                                                               Alert(title: Text("Error!"), message: Text("Amount cannot be blank"), dismissButton: .default(Text("Ok")))
                                                       }
                    }
                    
                    
                   
                    // Cancel Button
                    Button(action: {
                        self.pop = false
                        self.date = self.now
                        self.choice = 0
                        self.selectorIndex = 0
                        self.amount = ""
                        self.additonalNote.removeAll()
                      
                    }) {
                        Text("Cancel")
                            .offset(x: 163)
                            .alert(isPresented: self.$saveAlert){
                                Alert(title: Text("Are you sure you want to save this?") , message: Text("\(self.dateFormatter) - \(self.storeName) - \(self.additonalNote) - \(self.numbers[self.selectorIndex]) - \(self.how[self.choice])$\(self.amount)"), primaryButton: .default(Text("Save")) {
                                    
                                    // If Add
                                    if (self.how[self.choice] == "+") {
                                        
                                        // Change calendar cash amount
                                        if (self.numbers[self.selectorIndex] == "Cash") {
                                            self.cashAmount += Double(self.amount) ?? 0.0
                                            self.v1 += Double(self.amount) ?? 0.0
                                        }
                                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v1", save: self.v1, forKey: "currentbalance")
                                        
                                        
                                        // UUID and NOTE STRUCT PROGRAM /////////
                                        let ent = Note(content: "\(self.dateFormatter) - \(self.storeName) - \(self.additonalNote) - \(self.numbers[self.selectorIndex]) - +$\(self.amount)", value: Double(self.amount)!, type: "Add", date: self.dateFormatter, name: self.storeName, additionalNote: self.additonalNote)
                                        
                                        self.Notes.append(ent)
                                        self.calendarRecord.append(ent)
                                        
                                        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: self.Notes, requiringSecureCoding: false) {
                                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))NotesArray", save: savedData as NSData, forKey: "items")
                                            print("convereted to NSDATA")
                                        }
                                        
                                        if let savedDataCal = try? NSKeyedArchiver.archivedData(withRootObject: self.calendarRecord, requiringSecureCoding: false) {
                                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)calendar", save: savedDataCal as NSData, forKey: "all")
                                            print("convereted to Cal to NSDATA")
                                        }
                                        
                                        self.recentlyAdded = ent.content
                                        
                                    }
                                    
                                    
                                    // If Minus
                                    if (self.how[self.choice] == "-") {
                                        
                                        
                                        // Change calendar cash amount
                                        if (self.numbers[self.selectorIndex] == "Cash") {
                                            self.cashAmount -= Double(self.amount) ?? 0.0
                                            self.v2 += Double(self.amount) ?? 0.0
                                        }
                                        
                                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v2", save: self.v2, forKey: "currentbalance")
                                        
                                        // UUID and NOTE STRUCT PROGRAM /////////
                                        let ent = Note(content: "\(self.dateFormatter) - \(self.storeName) - \(self.additonalNote) - \(self.numbers[self.selectorIndex]) - -$\(self.amount)", value: Double(self.amount) ?? 0.0, type: "Minus", date: self.dateFormatter, name: self.storeName, additionalNote: self.additonalNote)
                                        
                                        self.Notes.append(ent)
                                        self.calendarRecord.append(ent)
                                        
                                        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: self.Notes, requiringSecureCoding: false) {
                                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))NotesArray", save: savedData as NSData, forKey: "items")
                                            print("convereted to NSDATA")
                                            
                                        }
                                        
                                        if let savedDataCal = try? NSKeyedArchiver.archivedData(withRootObject: self.calendarRecord, requiringSecureCoding: false) {
                                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)calendar", save: savedDataCal as NSData, forKey: "all")
                                            print("convereted to Cal to NSDATA")
                                        }
                                        
                                        self.recentlyAdded = ent.content
                                        
                                    }
                                    
                                    // If Pending
                                    if ((self.how[self.choice] == "?")) {
                                        
                                        if (self.numbers[self.selectorIndex] == "Cash") {
                                            self.v3 += Double(self.amount) ?? 0.0
                                        }
                                        
                                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v3", save: self.v3, forKey: "currentbalance")
                                        
                                        // UUID and NOTE STRUCT PROGRAM /////////
                                        let ent = Note(content: "\(self.dateFormatter) - \(self.storeName) - \(self.additonalNote) - \(self.numbers[self.selectorIndex]) - $\(self.amount)?", value: Double(self.amount) ?? 0.0, type: "Pending", date: self.dateFormatter, name: self.storeName, additionalNote: self.additonalNote)
                                        
                                        self.Notes.append(ent)
                                        self.calendarRecord.append(ent)
                                        
                                        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: self.Notes, requiringSecureCoding: false) {
                                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))NotesArray", save: savedData as NSData, forKey: "items")
                                            print("convereted to NSDATA")
                                            
                                        }
                                        
                                        if let savedDataCal = try? NSKeyedArchiver.archivedData(withRootObject: self.calendarRecord, requiringSecureCoding: false) {
                                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)calendar", save: savedDataCal as NSData, forKey: "all")
                                            print("convereted to Cal to NSDATA")
                                        }
                                        
                                        self.recentlyAdded = ent.content
                                    }
                                    
                                    
                                    self.date = self.now
                                    self.choice = 0
                                    self.selectorIndex = 0
                                    self.additonalNote.removeAll()
                                    self.amount = ""
                                    
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
                    .navigationBarTitle("pop-up")
                    .navigationBarItems(leading: Button(action: {
                        self.pop = false
                                               self.date = self.now
                                               self.choice = 0
                        self.selectorIndex = 0
                                               self.amount = ""
                                               self.additonalNote = ""
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
                .frame(width: screen.width, height: screen.height - 30)
                }
                    
                .offset(x: pop ? 0 : 500, y: 30)
                
                
                
                //MARK: END NEW ENTRY POP-UP
                
                
                
                //MARK: SHOW DELETE
                ZStack {
                      Color(#colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 0.9297677654))
                    
                    NavigationView {
                Form {
             
                    
                    Section {
                    // Date picker
                    DatePicker("Select Start Date:", selection: $date, displayedComponents: .date)
                        .padding(.horizontal)
                        
                        // Date picker
                        DatePicker("Select End Date:", selection: $endDate, displayedComponents: .date)
                            .padding(.horizontal)
                    
                    // Countinue button
                    Button(action: {
                        self.fetchCashAmount(from: self.database, withRecordName: "\(self.username)cash", key: "amount")
                         self.fetchNotesArrayFromCloud(record: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))NotesArray")
                         self.fetchCalendarRecord(from: self.database, withRecordName: "\(self.username)calendar", key: "all")
                        
                        self.endEditing()
                        print("pressed continue")
                        
                        
                        self.notesList.items.removeAll()
                        
                        // UUID Integration ///////////////
                        for note in self.Notes.sorted(by: {$0.date < $1.date }){
                           
                       
                            
                            if ((self.date...self.endDate).contains(self.convertToDate(dateIn: note.date))) || (note.date == self.dateFormatter){
                                
                                
                                self.notesList.items.append(note)
                            }
                        }
                        
                        self.showTestSheet = true
                        
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                            Text("Filter")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .medium, design: .default))
                        }
                    }
                    .frame(width: screen.width - 50, height: 50)
                  
                    .sheet(isPresented: self.$showTestSheet) {
                        NavigationView {
                            List{
                                ForEach(self.notesList.items, id: \.id) { item in
                                    ListView(note: item)
                                }
                                .onDelete(perform: self.removeItemsByDate)
                            }
                            .navigationBarTitle("Filtered Results")
                            .navigationBarItems(trailing: Text("$\(String(format: "%.2f", self.cashAmount))"))
                        }
                    }
                    }
                    
                    Section {
                    // Value Textfield
                    TextField("Enter Amount to filter", text: $amount) {
                        self.endEditing()
                    }
                        .padding(.leading)
                    
                    
                    // Value Countinue button
                    Button(action: {
                        self.fetchCashAmount(from: self.database, withRecordName: "\(self.username)cash", key: "amount")
                         self.fetchNotesArrayFromCloud(record: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))NotesArray")
                         self.fetchCalendarRecord(from: self.database, withRecordName: "\(self.username)calendar", key: "all")
                        self.endEditing()
                        
                        // UUID Integration ///////////////
                        self.notesList.items.removeAll()
                        
                        for note in self.Notes{
                            if (note.value == Double(self.amount)!) {
                                self.notesList.items.append(note)
                            }
                        }
                        self.showTestSheet2 = true
                        self.tempAmount = Double(self.amount)!
                        self.amount.removeAll()
                        
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                            Text("Filter")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .medium, design: .default))
                        }
                    }
                    .frame(width: screen.width - 50, height: 50)
                    .sheet(isPresented: $showTestSheet2) {
                        NavigationView {
                            List{
                                ForEach(self.notesList.items, id: \.id) { item in
                                    ListView(note: item)
                                }
                                .onDelete(perform: self.removeItemsByValue)
                            }
                            .navigationBarTitle("Filtered Results")
                            .navigationBarItems(trailing: Text("$\(String(format: "%.2f", self.cashAmount))"))
                        }
                    }
                    
                    }
                    
                    Section {
                    // Note textfield
                    TextField("Enter Note to filter", text: $additonalNote) {
                        self.endEditing()
                    }
                        .padding(.leading)
                        
                    
                    // Note Continue button
                    Button(action: {
                        self.fetchCashAmount(from: self.database, withRecordName: "\(self.username)cash", key: "amount")
                         self.fetchNotesArrayFromCloud(record: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))NotesArray")
                         self.fetchCalendarRecord(from: self.database, withRecordName: "\(self.username)calendar", key: "all")
                        self.endEditing()
                        self.notesList.items.removeAll()
                        
                        for note in self.Notes{
                            if (note.additonalNote.lowercased().contains(self.additonalNote.lowercased())) {
                                self.notesList.items.append(note)
                            }
                        }
                        
                        self.showTestSheet3 = true
                        self.tempAdditionalNote = self.additonalNote
                        self.additonalNote.removeAll()
                    }) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                            Text("Filter")
                                .foregroundColor(.white)
                                .font(.system(size: 20, weight: .medium, design: .default))
                        }
                    }
                    .frame(width: screen.width - 50, height: 50)
                    .sheet(isPresented: $showTestSheet3){
                        NavigationView {
                            List{
                                ForEach(self.notesList.items, id: \.id) { item in
                                    ListView(note: item)
                                }
                                .onDelete(perform: self.removeItemsByNote)
                            }
                            .navigationBarTitle("Filtered Results")
                            .navigationBarItems(trailing: Text("$\(String(format: "%.2f", self.cashAmount))"))
                        }
                        
                    }
                        
                    }
                    
                    
                    
                    
                }
                .navigationBarTitle("Filter")
                .navigationBarItems(leading: Button(action: {
                    self.showDelete = false
                    self.date = Date()
                    self.endDate = Date()

                    self.additonalNote.removeAll()
                    self.amount = ""
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
                     .frame(width: screen.width, height: screen.height - 30)
                }
                .offset(x: showDelete ? 0 : 500, y: 30)
                
                //MARK: SHOW EDIT
                Form {
                    
                    
                    Section(header: Text("MM/DD/YY")) {
                        TextField("Enter Date", text: self.$newEditedNoteDate) {
                            self.endEditing()
                        }
                    }
                    
                    Section(header: Text("Additional Note")){
                        TextField("Enter additional note", text: self.$newEditedNoteAdditionalNote) {
                            self.endEditing()
                        }
                    }
                    
                    Section(header: Text("Amount")) {
                        TextField("Enter amount", text: $newEditedNoteValue) {
                            self.endEditing()
                        }
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
                       
                        
                       if self.how[self.choice] == "+" {
                            self.newEditedNoteType = "Add"
                        }
                        
                       if self.how[self.choice] == "-" {
                            self.newEditedNoteType = "Minus"
                        }
                        
                        if self.how[self.choice] == "?" {
                            self.newEditedNoteType = "Pending"
                        }
                        
                        let ent2 = Note(content: "\(self.newEditedNoteDate) - \(self.newEditedNotePerson) - \(self.newEditedNoteAdditionalNote) - \(self.numbers[self.selectorIndex]) - $\(self.newEditedNoteValue)", value: Double(self.newEditedNoteValue)!, type: self.newEditedNoteType, date: self.newEditedNoteDate, name: self.newEditedNotePerson, additionalNote: self.newEditedNoteAdditionalNote)
                        
                        
                        for note in self.calendarRecord {
                            
                            if (self.tempOptionsNote == note.content) {
                                
                                print("Found one note to edit in calendar")
                                
                                
                                
                                let idx = self.calendarRecord.firstIndex(of: note)
                                self.calendarIndex = idx!
                                
                                
                                if note.content.contains("- Cash -") && note.type == "Add"{
                                    self.v1 -= note.value
                                    self.cashAmount -= note.value
                                    print("/////////: \(note.value)")
                                    
                                    
                                    self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(note.name.replacingOccurrences(of: " ", with: ""))v1", save: self.v1, forKey: "currentbalance")
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
                            
                            
                            if (note.content == self.tempOptionsNote) {
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
                                self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(ent2.name.replacingOccurrences(of: " ", with: ""))v1", save: self.v1, forKey: "currentbalance")
                            }
                            
                            
                            
                            self.Notes.insert(ent2, at: self.notesIndex)
                            self.calendarRecord.insert(ent2, at: self.calendarIndex)
                            
                            
                            
                            
                            if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: self.Notes, requiringSecureCoding: false) {
                                self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(ent2.name.replacingOccurrences(of: " ", with: ""))NotesArray", save: savedData as NSData, forKey: "items")
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
                                self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(ent2.name.replacingOccurrences(of: " ", with: ""))v2", save: self.v2, forKey: "currentbalance")
                            }
                            
                            
                            self.Notes.insert(ent2, at: self.notesIndex)
                            self.calendarRecord.insert(ent2, at: self.calendarIndex)
                            
                            
                            if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: self.Notes, requiringSecureCoding: false) {
                                self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(ent2.name.replacingOccurrences(of: " ", with: ""))NotesArray", save: savedData as NSData, forKey: "items")
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
                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(ent2.name.replacingOccurrences(of: " ", with: ""))v3", save: self.v3, forKey: "currentbalance")
                            
                            
                            self.Notes.insert(ent2, at: self.notesIndex)
                            self.calendarRecord.insert(ent2, at: self.calendarIndex)
                            
                            if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: self.Notes, requiringSecureCoding: false) {
                                self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(ent2.name.replacingOccurrences(of: " ", with: ""))NotesArray", save: savedData as NSData, forKey: "items")
                                print("convereted to NSDATA")
                                
                            }
                            
                            if let savedDataCal = try? NSKeyedArchiver.archivedData(withRootObject: self.calendarRecord, requiringSecureCoding: false) {
                                self.editFetchedOther(to: self.database, withRecordName: "\(self.username)calendar", save: savedDataCal as NSData, forKey: "all")
                                print("convereted to Cal to NSDATA")
                                
                            }
                            
                            
                            
                            
                            
                            
                        }
                        
                        self.edit = false
                        
                    }) {
                        Text("Save")
                            .offset(x: 170)
                    }
                    
                    // Cancel Button
                    Button(action: {
                        self.edit = false
                    }) {
                        Text("Cancel")
                            .offset(x: 163)
                        
                    }
                    .foregroundColor(.red)
                    
                    
                }
                .frame(width: screen.width, height: screen.height - 10 )
                .offset(x: edit ? 0 : 500)
                
                
                //MARK: SHOW ADD SUMMARY
                if self.showAddSummary {
                    
                    ZStack {
                        Color.white
                        NavigationView {
                                List {
                                    ForEach(self.NotesSummary.indices, id: \.self){ index in
                                        ListView(note: self.NotesSummary[index])
                                    }
                                }
                                .navigationBarTitle("Summary")
                                .navigationBarItems(leading:
                                    Button(action: {self.showAddSummary = false}){
                                        Text("Close")
                                    }
                                )
                            }
                            .frame(width: screen.width, height: screen.height - 125)
                       
                        
                            
                        
                        
                    }
                    .frame(width: screen.width, height: screen.height)
                    .transition(.slide)
                    .animation(.spring())
                }
                
                //MARK: SHOW MINUS SUMMARY
                if self.showMinusSummary {
                    ZStack{
                        Color.white
                        NavigationView {
                            List {
                                ForEach(self.NotesSummary.indices, id: \.self){ index in
                                    ListView(note: self.NotesSummary[index])
                                }
                            }
                            .navigationBarTitle("Summary")
                            .navigationBarItems(leading:
                                Button(action: {self.showMinusSummary = false}){
                                    Text("Close")
                                }
                            )
                        }
                        .frame(width: screen.width, height: screen.height - 125)
                        
                    }
                    .frame(width: screen.width, height: screen.height)
                    .transition(.slide)
                    .animation(.spring())
                }
                
                
                //MARK: SHOW PENDING SUMMARY
                if self.showPendingSummary {
                    ZStack{
                        NavigationView {
                            List {
                                ForEach(self.NotesSummary.indices, id: \.self){ index in
                                    ListView(note: self.NotesSummary[index])
                                }
                            }
                            .navigationBarTitle("Summary")
                            .navigationBarItems(leading:
                                Button(action: {self.showPendingSummary = false}){
                                    Text("Close")
                                }
                            )
                        }
                        .frame(width: screen.width, height: screen.height - 125)
                    }
                    .frame(width: screen.width, height: screen.height)
                    .transition(.slide)
                    .animation(.spring())
                }
                
                if showOptions{
                    OptionsView(content: self.tempOptionsNote)
                        .transition(.slide)
                        .animation(.spring())
                        .onAppear {
                             print("cashAmount: \(self.cashAmount)")
                    }
                    
                    HStack(spacing: 0) {
                        
                        // Edit Button
                        
                        Button(action: {
                            if self.tempOptionsNote.contains("- Cash -") {
                                self.selectorIndex = 0
                            }
                            
                            if self.tempOptionsNote.contains("- Cheque -") {
                                self.selectorIndex = 1
                            }
                            
                            if self.optionNoteType == "Add" {
                                self.choice = 0
                            }
                            
                            if self.optionNoteType == "Minus" {
                                self.choice = 1
                            }
                            
                            if self.optionNoteType == "Pending" {
                                self.choice = 2
                            }
                            
                            self.edit = true
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
                        
                        // Delete Button
                        
                        Button(action: {
                            self.showingAlert4 = true
                            
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
                        .alert(isPresented: self.$showingAlert4){
                            Alert(title: Text("Are you sure you want to delete this?"), message: Text(self.tempOptionsNote), primaryButton: .destructive(Text("Delete")) {
                                
                                self.showLoader = true
                                
                                
                              for note in self.calendarRecord {
                                    
                                    if (note.content == self.tempOptionsNote){
                                       
                                        print("Found one note in calendar")
                                        
                                        
                                        
                                        let idx = self.calendarRecord.firstIndex(of: note)
                                        

                                        if note.content.contains("- Cash -") && note.type == "Add"{
                                            self.v1 -= note.value
                                            self.cashAmount -= note.value
                                            
                                           
                                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(note.name.replacingOccurrences(of: " ", with: ""))v1", save: self.v1, forKey: "currentbalance")
                                        }
                                        
                                        if note.content.contains("- Cash -") && note.type == "Minus"{
                                            self.v2 -= note.value
                                            self.cashAmount += note.value
                                            
                                            
                                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(note.name.replacingOccurrences(of: " ", with: ""))v2", save: self.v2, forKey: "currentbalance")
                                        }
                                        
                                        if note.content.contains("- Cash -") && note.type == "Pending"{
                                            self.v3 -= note.value
                                            
                                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(note.name.replacingOccurrences(of: " ", with: ""))v3", save: self.v3, forKey: "currentbalance")
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
                                    
                                   
                                    if (note.content == self.tempOptionsNote) {
                                        print("Found note in personal notes")
                                        let idx = self.Notes.firstIndex(of: note)
                                        
                                        self.Notes.remove(at: idx!)
                                        
                                        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: self.Notes, requiringSecureCoding: false) {
                                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(note.name.replacingOccurrences(of: " ", with: ""))NotesArray", save: savedData as NSData, forKey: "items")
                                            print("convereted to NSDATA")
                                            
                                        }
                                        
                                        break
                                        
                                    }
                                }
                                
                                self.showOptions = false
                                
                                self.showLoader = false
                                }, secondaryButton: .cancel())
                        }
                        
                        
                    }
                    .transition(.slide)
                    .animation(.spring())
                    
                    Button(action: {self.showOptions = false}) {
                        Image(systemName: "arrow.left.circle")
                            .resizable()
                        
                    }
                    .foregroundColor(.black)
                    .frame(width: 30, height: 30)
                    .offset(x: -150, y: -85)
                    .transition(.slide)
                    .animation(.spring())
                }
                
                
                
                
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
        
        
        
        
        //MARK: END MAIN ZSTACK
        
        
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
                self.showLoader = false
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
                self.showLoader = false
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
                
                self.showLoader = false
            }
        }
        
    }
    
    func fetchCashAmount(from database: CKDatabase, withRecordName: String, key: String){
        
        self.showLoader = true
        database.fetch(withRecordID:  CKRecord.ID(recordName: withRecordName)) { (cashRecord, _) in
            self.cashAmount = cashRecord?.value(forKeyPath: key) as! Double
            
            self.showLoader = false
        }
        print("retreived cash amount")
        
        
        
    }
    
    func fetchCalendarRecord(from database: CKDatabase, withRecordName: String, key: String) {
        self.showLoader = true
        database.fetch(withRecordID:  CKRecord.ID(recordName: withRecordName)) { (calendarRec, Err) in
            if Err != nil {
                print(Err!)
            } else {
                
                if let decodedNotes = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(calendarRec?.value(forKeyPath: key) as! Data) as? [Note] {
                    self.calendarRecord = decodedNotes
                    print("calendar: \(decodedNotes)")
                }
                
            }
            self.showLoader = false
        }
        print("retreived calendar record")
        
        
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
                }
                
            }
            
            self.showLoader = false
        }
        
    }
    
    private func endEditing() {
          UIApplication.shared.endEditing()
      }
    
    
    func removeItemsByDate(at offsets: IndexSet) {
        self.showLoader = true
        self.notesList.items.remove(atOffsets: offsets)
        print(notesList.items)
        
        if (self.notesList.items.count != 0){
            for remNote in self.notesList.items{
                
                for note2 in self.calendarRecord {
                    if (note2.content != remNote.content && (((self.date...self.endDate).contains(self.convertToDate(dateIn: note2.date))) || (note2.date == self.dateFormatter))) {
                        let idx2 = self.calendarRecord.firstIndex(of: note2)
                        
                        self.calendarRecord.remove(at: idx2!)
                        
                        if let savedDataCal = try? NSKeyedArchiver.archivedData(withRootObject: self.calendarRecord, requiringSecureCoding: false) {
                                                                                                         self.editFetchedOther(to: self.database, withRecordName: "\(self.username)calendar", save: savedDataCal as NSData, forKey: "all")
                                                                                                         print("convereted to Cal to NSDATA")
                                                                                                         
                                                              }
                        break
                    }
                }
                
                for note in self.Notes{
                    if (note.id != remNote.id && note.date == remNote.date ){
                        let idx = self.Notes.firstIndex(of: note)
                        
                        
                        
                        if note.content.contains("- Cash -") && note.type == "Add"{
                            self.v1 -= note.value
                            self.cashAmount -= note.value
                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v1", save: self.v1, forKey: "currentbalance")
                        }
                        
                        if note.content.contains("- Cash -") && note.type == "Minus"{
                            self.v2 -= note.value
                            self.cashAmount += note.value
                            
                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v2", save: self.v2, forKey: "currentbalance")
                        }
                        
                        if note.content.contains("- Cash -") && note.type == "Pending"{
                            self.v3 -= note.value
                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v3", save: self.v3, forKey: "currentbalance")
                        }
                        
                        self.Notes.remove(at: idx!)
                       
                        print("Deleted: \(note)")
                        
                        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: self.Notes, requiringSecureCoding: false) {
                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))NotesArray", save: savedData as NSData, forKey: "items")
                            print("convereted to NSDATA")
                        }
                        
                        
                        break
                        
                    }
                }
            }
            
        }
        
        if (self.notesList.items.count == 0){
            
            for note2 in self.calendarRecord {
                if ((self.date...self.endDate).contains(self.convertToDate(dateIn: note2.date))) || (note2.date == self.dateFormatter) {
                    let idx2 = self.calendarRecord.firstIndex(of: note2)
                    
                    self.calendarRecord.remove(at: idx2!)
                    
                    if let savedDataCal = try? NSKeyedArchiver.archivedData(withRootObject: self.calendarRecord, requiringSecureCoding: false) {
                                                                                                     self.editFetchedOther(to: self.database, withRecordName: "\(self.username)calendar", save: savedDataCal as NSData, forKey: "all")
                                                                                                     print("convereted to Cal to NSDATA")
                                                                                                     
                                                          }
                    
                    
                }
            }
            
            for note in self.Notes{
                if  (self.date...self.endDate).contains(self.convertToDate(dateIn: note.date)) || (note.date == self.dateFormatter){
                    let idx = self.Notes.firstIndex(of: note)
                   
                    
                    if note.content.contains("- Cash -") && note.type == "Add"{
                        self.v1 -= note.value
                        self.cashAmount -= note.value
                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v1", save: self.v1, forKey: "currentbalance")
                    }
                    
                    if note.content.contains("- Cash -") && note.type == "Minus"{
                        self.v2 -= note.value
                        self.cashAmount += note.value
                        
                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v2", save: self.v2, forKey: "currentbalance")
                    }
                    
                    if note.content.contains("- Cash -") && note.type == "Pending"{
                        self.v3 -= note.value
                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v3", save: self.v3, forKey: "currentbalance")
                    }
                    
                    self.Notes.remove(at: idx!)
                   
                    
                    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: self.Notes, requiringSecureCoding: false) {
                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))NotesArray", save: savedData as NSData, forKey: "items")
                        print("convereted to NSDATA")
                    }
                    
                
                    
                    
                }
            }
        }
        
        self.showLoader = false
    }
    func removeItemsByValue(at offsets: IndexSet) {
        
        self.showLoader = true
        self.notesList.items.remove(atOffsets: offsets)
        
        if (self.notesList.items.count != 0){
            for remNote in self.notesList.items{
                
                
                for note2 in self.calendarRecord {
                    if(note2.content != remNote.content && note2.value == remNote.value) {
                        let idx2 = self.calendarRecord.firstIndex(of: note2)
                                               
                                               self.calendarRecord.remove(at: idx2!)
                                               
                                               if let savedDataCal = try? NSKeyedArchiver.archivedData(withRootObject: self.calendarRecord, requiringSecureCoding: false) {
                                                                                                                                self.editFetchedOther(to: self.database, withRecordName: "\(self.username)calendar", save: savedDataCal as NSData, forKey: "all")
                                                                                                                                print("convereted to Cal to NSDATA")
                                                                                                                                
                                                                                     }
                    break
                    }
                }
                
                
                for note in self.Notes{
                    if (note.id != remNote.id && note.value == remNote.value){
                        let idx = self.Notes.firstIndex(of: note)
                        
                        
                        if note.content.contains("- Cash -") && note.type == "Add"{
                            self.v1 -= note.value
                            self.cashAmount -= note.value
                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v1", save: self.v1, forKey: "currentbalance")
                        }
                        
                        if note.content.contains("- Cash -") && note.type == "Minus"{
                            self.v2 -= note.value
                            self.cashAmount += note.value
                            
                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v2", save: self.v2, forKey: "currentbalance")
                        }
                        
                        if note.content.contains("- Cash -") && note.type == "Pending"{
                            self.v3 -= note.value
                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v3", save: self.v3, forKey: "currentbalance")
                        }
                        
                        self.Notes.remove(at: idx!)
                        
                        print("Deleted: \(note)")
                        
                        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: self.Notes, requiringSecureCoding: false) {
                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))NotesArray", save: savedData as NSData, forKey: "items")
                            print("convereted to NSDATA")
                        }
                        
                      
                      break
                    }
                }
            }
        }
        
        if (self.notesList.items.count == 0){
            
            for note2 in self.calendarRecord {
                if (note2.value == self.tempAmount) {
                    let idx2 = self.calendarRecord.firstIndex(of: note2)
                                           
                                           self.calendarRecord.remove(at: idx2!)
                                           
                                           if let savedDataCal = try? NSKeyedArchiver.archivedData(withRootObject: self.calendarRecord, requiringSecureCoding: false) {
                                                                                                                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)calendar", save: savedDataCal as NSData, forKey: "all")
                                                                                                                            print("convereted to Cal to NSDATA")
                                                                                                                            
                                                                                 }
                
                
                }
            }
            
            for note in self.Notes{
                if (note.value == self.tempAmount){
                    let idx = self.Notes.firstIndex(of: note)
                    
                    
                    if note.content.contains("- Cash -") && note.type == "Add"{
                        self.v1 -= note.value
                        self.cashAmount -= note.value
                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v1", save: self.v1, forKey: "currentbalance")
                    }
                    
                    if note.content.contains("- Cash -") && note.type == "Minus"{
                        self.v2 -= note.value
                        self.cashAmount += note.value
                        
                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v2", save: self.v2, forKey: "currentbalance")
                    }
                    
                    if note.content.contains("- Cash -") && note.type == "Pending"{
                        self.v3 -= note.value
                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v3", save: self.v3, forKey: "currentbalance")
                    }
                    
                    self.Notes.remove(at: idx!)
                    
                    
                    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: self.Notes, requiringSecureCoding: false) {
                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))NotesArray", save: savedData as NSData, forKey: "items")
                        print("convereted to NSDATA")
                    }
                    
                  
                 
                }
            }
        }
        
        self.showLoader = false
    }
    func removeItemsByNote(at offsets: IndexSet) {
        
        self.showLoader = true
        self.notesList.items.remove(atOffsets: offsets)
        
        if (self.notesList.items.count != 0){
            for remNote in self.notesList.items{
                
                for note2 in self.calendarRecord {
                    if (note2.content != remNote.content && note2.additonalNote.lowercased().contains(self.tempAdditionalNote.lowercased())) {
                        let idx2 = self.calendarRecord.firstIndex(of: note2)
                        
                        self.calendarRecord.remove(at: idx2!)
                        
                        if let savedDataCal = try? NSKeyedArchiver.archivedData(withRootObject: self.calendarRecord, requiringSecureCoding: false) {
                                                                                                         self.editFetchedOther(to: self.database, withRecordName: "\(self.username)calendar", save: savedDataCal as NSData, forKey: "all")
                                                                                                         print("convereted to Cal to NSDATA")
                                                                                                         
                                                              }
                        
                        break
                    }
                }
                
                
                for note in self.Notes{
                    if (note.id != remNote.id && note.additonalNote.lowercased().contains(self.tempAdditionalNote.lowercased())){
                        let idx = self.Notes.firstIndex(of: note)
                        
                        
                        if note.content.contains("- Cash -") && note.type == "Add"{
                            self.v1 -= note.value
                            self.cashAmount -= note.value
                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v1", save: self.v1, forKey: "currentbalance")
                        }
                        
                        if note.content.contains("- Cash -") && note.type == "Minus"{
                            self.v2 -= note.value
                            self.cashAmount += note.value
                            
                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v2", save: self.v2, forKey: "currentbalance")
                        }
                        
                        if note.content.contains("- Cash -") && note.type == "Pending"{
                            self.v3 -= note.value
                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v3", save: self.v3, forKey: "currentbalance")
                        }
                        
                        self.Notes.remove(at: idx!)
                       
                        print("Deleted: \(note)")
                        
                        if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: self.Notes, requiringSecureCoding: false) {
                            self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))NotesArray", save: savedData as NSData, forKey: "items")
                            print("convereted to NSDATA")
                        }
                        break
                    }
                }
            }
        }
        
        if (self.notesList.items.count == 0){
            
            for note2 in self.calendarRecord {
                if note2.additonalNote.lowercased().contains(self.tempAdditionalNote.lowercased()) {
                    let idx2 = self.calendarRecord.firstIndex(of: note2)
                    
                    self.calendarRecord.remove(at: idx2!)
                    
                    if let savedDataCal = try? NSKeyedArchiver.archivedData(withRootObject: self.calendarRecord, requiringSecureCoding: false) {
                                                                                                     self.editFetchedOther(to: self.database, withRecordName: "\(self.username)calendar", save: savedDataCal as NSData, forKey: "all")
                                                                                                     print("convereted to Cal to NSDATA")
                                                                                                     
                                                    }
                    
                }
            }
            
            for note in self.Notes{
                if (note.additonalNote.lowercased().contains(self.tempAdditionalNote.lowercased())){
                    let idx = self.Notes.firstIndex(of: note)
                    
                    
                    if note.content.contains("- Cash -") && note.type == "Add"{
                        self.v1 -= note.value
                        self.cashAmount -= note.value
                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v1", save: self.v1, forKey: "currentbalance")
                    }
                    
                    if note.content.contains("- Cash -") && note.type == "Minus"{
                        self.v2 -= note.value
                        self.cashAmount += note.value
                        
                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v2", save: self.v2, forKey: "currentbalance")
                    }
                    
                    if note.content.contains("- Cash -") && note.type == "Pending"{
                        self.v3 -= note.value
                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)cash", save: self.cashAmount, forKey: "amount")
                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))v3", save: self.v3, forKey: "currentbalance")
                    }
                    
                    self.Notes.remove(at: idx!)
                  
                    
                    if let savedData = try? NSKeyedArchiver.archivedData(withRootObject: self.Notes, requiringSecureCoding: false) {
                        self.editFetchedOther(to: self.database, withRecordName: "\(self.username)\(self.storeName.replacingOccurrences(of: " ", with: ""))NotesArray", save: savedData as NSData, forKey: "items")
                        print("convereted to NSDATA")
                    }
                    
                  
                }
            }
        }
        
       
        
        self.showLoader = false
    }
    
    //MARK: EDIT OTHER RECORD FROM CLOUD
       func editFetchedOther(to database: CKDatabase, withRecordName: String, save element: Any, forKey: String){
              self.showLoader = true
              database.fetch(withRecordID:  CKRecord.ID(recordName: withRecordName)) { (uniRecord, error) in
                  
                         
                  if (error != nil) {
                    print("\(error ?? "Failed" as! Error) in updating: \(withRecordName)")
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
                          print("Saved record")
                          self.showLoader = false
                      }
            }
      
}

struct StoreAccountView_Previews: PreviewProvider {
    static var previews: some View {
        StoreAccountView(storeName: "Cashland")
    }
}



let screen = UIScreen.main.bounds
