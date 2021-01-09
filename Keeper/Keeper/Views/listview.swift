//
//  listview.swift
//  Keeper
//
//  Created by Bhargin Kanani on 8/13/20.
//  Copyright © 2020 Bhargin Kanani. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth

struct listview: View {
    let textcolors = [#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)]
    let item: NoteType
    let screen = UIScreen.main.bounds
    var userNameFromHome: String
    @State var showEdit = false
    @State var changedName = false
    @State var newName = ""
    @State var newNote = ""
    @State var newAmount = ""
    @State var minusTapped = false
    @State var chequeTapped = false
    @State var showContactSheet = false
    @State var addNewContact = false
    @State var morph = false
    @State var searchText = ""
    @State var contacts: [String] = []
    @State var tempContacts: [String] = []
    @State var numbers: [String] = []
    @State var tempNumbers: [String] = []
    @State var extendFalse = false
    @State var newDate = Date()
    
    
    let db = Firestore.firestore()
    @Binding var extend:Bool
    
    
    
    var body: some View {
        ZStack {
            
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor( Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                .frame(width: screen.width - 10, height: self.extend ? 120 : 70)
            
            
            
            VStack {
                HStack(alignment: .center, spacing: 10) {
                    withYouView(name: item.Name)
                        .frame(width: 50, height: 45)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(item.Name)")
                            .font(Font.custom("TTFirsNeue-DemiBold", size: 20))
                            .foregroundColor(.black)
                        Text("\(item.Note)")
                            .font(Font.custom("TTFirsNeue-Light", size: 15))
                    }
                    
                    Spacer()
                    
                    VStack(alignment: .trailing, spacing: 10) {
                        Text(String(format: "%.2f", item.Amount))
                            .font(Font.custom("TTFirsNeue-Medium", size: 20))
                            .foregroundColor((item.type == "Plus") ? .green:.red)
                        
                    }
                }
                .padding(.horizontal, 5)
                .frame(width: screen.width - 10, height: 70)
                
                Spacer()
            }
            .frame(width: screen.width - 10, height: self.extend ? 120 : 70)
            
            HStack {
                VStack(alignment: .leading){
                    Text("\(item.Transation)")
                        .font(Font.custom("TTFirsNeue-Medium", size: 15))
                    Text("\(self.getStringfromData(date: item.Time.dateValue() as NSDate))")
                        .font(Font.custom("TTFirsNeue-Medium", size: 15))
                }
                .padding(.leading)
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("$ \(String(format: "%.2f", item.balance))")
                        .font(.custom("TTFirsNeue-Light", size: 15))
                    
                    HStack {
                        Button(action: {
                            self.newNote = item.Note
                            self.newAmount = String(format: "%.2f", item.Amount)
                            self.minusTapped = (item.type == "Minus") ? true:false
                            self.chequeTapped = (item.Transation == "Cheque") ? true:false
                            self.newDate = item.Time.dateValue()
                            self.showEdit = true
                            print("MinusTapped..... = \(self.minusTapped)")
                        }) {
                            Image(systemName: "pencil")
                                .resizable()
                        }
                        .foregroundColor(.black)
                        .frame(width: 17, height: 17)
                        
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                            Image(systemName: "trash")
                                .resizable()
                        }
                        .foregroundColor(.black)
                        .frame(width: 17, height: 20)
                        .sheet(isPresented: self.$showEdit){
                            ZStack{
                                VStack(alignment: .leading){
                                    HStack{
                                        Spacer()
                                        
                                        //MARK: SAVE BUTTON
                                        Button(action: {
                                            
                                            let newamountconverted: Double = (self.newAmount as NSString).doubleValue
                                            print("new amount convert = \(newamountconverted)")
                                            
                                            print("item.ID = \(item.ID)")
                                            
                                            print("entered changing notes")
                                            db.collection(userNameFromHome).document("other").getDocument { (docsnap, err) in
                                                let data = docsnap!.data()
                                                let lastNoteID = data!["index"] as! Int
                                                
                                                
                                                self.updateEveryNote(from: item.ID, to: lastNoteID, withCurrBal: item.balance, withNewAdjustmentAmount: newamountconverted)
                                                
                                            }
                                            
                                            
                                            
                                            //                                            else {
                                            //                                                db.collection(userNameFromHome).document("\(item.ID)").setData(["Name":self.changedName ? newName:item.Name, "Type": (self.minusTapped ? "Minus":"Plus"), "Transaction":(self.chequeTapped ? "Cheque":"Cash"), "Note":self.newNote != "" ? self.newNote:item.Note], merge: true) { (err) in
                                            //
                                            //                                                                                                                if err == nil {
                                            //                                                                                                                self.showEdit = false
                                            //                                                                                                                } else {
                                            //                                                                                                                print("error in save button code!")
                                            //                                                                                                                }
                                            //
                                            //                                                  }
                                            //                                            }
                                            
                                            
                                            
                                            //END SAVE BUTTON
                                        }) {
                                            Text("Save")
                                                .font(Font.custom("TTFirsNeue-Regular", size: 23))
                                        }
                                        .foregroundColor(.black)
                                        
                                    }
                                    .padding(.horizontal)
                                    
                                    
                                    //MARK: QUERY CONTACT IN EDIT MODE BUTTON
                                    Button(action: {
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
                                        
                                        
                                        self.showContactSheet = true
                                        
                                    }) {
                                        Text(self.changedName ? self.newName:item.Name)
                                            .font(Font.custom("TTFirsNeue-Medium", size: 40))
                                    }
                                    .foregroundColor(.black)
                                    
                                    TextField("Note here", text: self.$newNote)
                                        .font(Font.custom("TTFirsNeue-Regular", size: 23))
                                    
                                    TextField("Amount here", text: self.$newAmount)
                                        .font(Font.custom("TTFirsNeue-Regular", size: 23))
                                        .sheet(isPresented: self.$showContactSheet) {
                                            ZStack {
                                                //MARK: Contact sheet
                                                VStack {
                                                    
                                                    searchbar(text: self.$searchText, morph: self.$morph)
                                                        .padding(.top, -30)
                                                        .animation(.spring())
                                                    
                                                    
                                                    
                                                    ScrollView(showsIndicators: false){
                                                        VStack{
                                                            
                                                            if (self.addNewContact == false) {
                                                                if (self.contacts.isEmpty == false  && self.numbers.isEmpty == false){
                                                                    ForEach(self.contacts.sorted{$0.self < $1.self}.filter {
                                                                        self.searchText.isEmpty ? true : $0.lowercased().contains(self.searchText.lowercased())
                                                                    }, id: \.self){ name in
                                                                        contactListView(info: name, mobile: self.numbers[self.contacts.firstIndex(of: name)!], extend: self.$extendFalse)
                                                                            .onTapGesture {
                                                                                self.changedName = true
                                                                                self.newName = name
                                                                                print(self.newName)
                                                                                self.showContactSheet = false
                                                                            }
                                                                        
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                    
                                                    
                                                }
                                                .frame(height: 730)
                                                .offset(x: self.addNewContact ? -500:0, y: 10)
                                                .animation(.spring())
                                                
                                                
                                                
                                            }
                                        }
                                    
                                    
                                    //MARK: CASH & CHEQUE SELECTOR
                                    HStack {
                                        Spacer()
                                        VStack {
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .foregroundColor(.black)
                                                    .frame(width: 75, height: 35)
                                                    .offset(x: self.minusTapped ? 35:-47, y: 0)
                                                    .animation(.spring())
                                                
                                                HStack(spacing: 65) {
                                                    Button(action: {
                                                        self.minusTapped = false
                                                        
                                                    }) {
                                                        Image(systemName: "plus")
                                                            .resizable()
                                                    }
                                                    .frame(width: 20, height: 20)
                                                    .foregroundColor(self.minusTapped ? .black:.white)
                                                    
                                                    
                                                    Button(action: {
                                                        self.minusTapped = true
                                                    }) {
                                                        Text("-")
                                                    }
                                                    .frame(width: 20, height: 17)
                                                    .foregroundColor(self.minusTapped ? .white:.black)
                                                   
                                                       
                                                    
                                                    
                                                }
                                                .foregroundColor(.black)
                                                .offset(x: -7)
                                                .animation(.spring())
                                                .font(Font.custom("TTFirsNeue-DemiBold", size: 40))
                                                
                                            }
                                            ZStack {
                                                RoundedRectangle(cornerRadius: 10)
                                                    .foregroundColor(.black)
                                                    .frame(width: self.chequeTapped ? 90:75, height: 35)
                                                    .offset(x: self.chequeTapped ? 35:-47, y: 0)
                                                    .animation(.spring())
                                                
                                                HStack(spacing: 23){
                                                    Text("cash")
                                                        .foregroundColor(self.chequeTapped ? .black:.white)
                                                        .onTapGesture {
                                                            self.chequeTapped = false
                                                        }
                                                    
                                                    
                                                    Text("cheque")
                                                        .foregroundColor(self.chequeTapped ? .white:.black
                                                        )
                                                        .onTapGesture {
                                                            self.chequeTapped = true
                                                        }
                                                    
                                                    
                                                }
                                                .foregroundColor(.black)
                                                .animation(.spring())
                                                .font(Font.custom("TTFirsNeue-DemiBold", size: 20))
                                                
                                            }
                                        }
                                    }
                                    .padding(.horizontal)
                                    
                                    //MARK: DATE PICKER
                                    HStack {
                                        DatePicker("Select Date:", selection: self.$newDate)
                                        Spacer()
                                    }
                                    
                                    
                                    Spacer()
                                    
                                }
                                .padding()
                            }
                        }
                        
                    }
                    
                }
                .offset(y: -13)
                
                
            }
            .offset(x: 30, y:25)
            .frame(width: screen.width - 60)
            .opacity(self.extend ? 1:0)
            .padding(.trailing)
            .animation(.spring())
            
            RoundedRectangle(cornerRadius: 5)
                .frame(width: screen.width - 20 , height: 2)
                .offset(y: self.extend ? 65 : 40)
                .foregroundColor(.white)
        }
        .frame(width: screen.width - 10, height: self.extend ? 120 : 70)
        .edgesIgnoringSafeArea(.all)
    }
    
    func getStringfromData(date: NSDate) -> String{
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "MM-dd-YYYY hh:mm a"
        
        return dateFormatterGet.string(from: date as Date)
    }
    
    func updateEveryNote(from id: Int, to last_id: Int, withCurrBal: Double, withNewAdjustmentAmount: Double) {
        print("......ID#: \(item.ID).........")
        print("note curr amount: \(item.Amount)")
        
        var currRetbal: Double = withCurrBal
        print("note current balance: \(currRetbal)")
        
        // RESET CURR BALANCE
        if item.type == "Minus" {currRetbal += item.Amount} else if item.type == "Plus" {currRetbal -= item.Amount}
        print("new reset currRetBal = \(currRetbal)")
        
        // CALCULATE THE NEW CURR BALANCE
        if self.minusTapped { currRetbal -= withNewAdjustmentAmount } else { currRetbal += withNewAdjustmentAmount}
        print("new curr Note RetFinalBal = \(currRetbal)")
        
        db.collection(userNameFromHome).document("Balance").getDocument { (DocumentSnapshot, err) in
            if err == nil {
                
                if DocumentSnapshot!.exists && DocumentSnapshot != nil {
                    let data = DocumentSnapshot!.data()
                    var ret = data!["balance"] as! Double
                    
                    // RESET TOTAL CURR BALANCE
                    if item.type == "Minus" {ret += item.Amount} else if item.type == "Plus" {ret -= item.Amount}
                    
                    // CALCULATE THE NEW TOTAL CURR BALANCE
                    if self.minusTapped { ret -= withNewAdjustmentAmount } else { ret += withNewAdjustmentAmount}
                    
                    // UPDATE THE CURR NOTE WITH NEW VALUES
                    db.collection(userNameFromHome).document("\(id)").setData(["Name":self.changedName ? newName:item.Name, "Type": (self.minusTapped ? "Minus":"Plus"), "Transaction":(self.chequeTapped ? "Cheque":"Cash"), "Amount": self.newAmount != "" ? withNewAdjustmentAmount:item.Amount, "Note":self.newNote != "" ? self.newNote:item.Note, "Time":newDate, "currBal":currRetbal], merge: true) { (err) in
                        
                        if err == nil {
                            if (item.ID < last_id) {
                                print("Entered withoutloop func()")
                                self.updateNotewithoutloop(withID: id + 1, toID: last_id, withCurrBal2: currRetbal)
                                
                            }
                            
                        } else { print("Error") }
                        
                    }
                    
                   
                    
                    // UPDATE THE TOTAL CURR BALANCE
                    db.collection(userNameFromHome).document("Balance").setData(["balance": ret], merge: true) { (err) in
                        if err == nil { self.showEdit = false
                            print("Success") }
                    }
                    
                    
                }
                
            }
            
        }
        
        
    }
    
    func updateNotewithoutloop (withID num: Int, toID last: Int, withCurrBal2: Double) {
        db.collection(userNameFromHome).document("\(num)").getDocument { (docsnap, err) in
            
            var currRetbal2 = withCurrBal2
            
            
            if err == nil && num <= last {
                print("......ID#: \(num)........***")
                let data = docsnap!.data()
                let note_value = data!["Amount"] as! Double
                print("item amount: \(note_value)")
                let note_type = data!["Type"]
                print("item typme: \(note_type)")
                
                if note_type as! String == "Minus" { currRetbal2 -= note_value } else if note_type as! String == "Plus" { currRetbal2 += note_value }
                print("New item balance \(currRetbal2)")
                
                db.collection(userNameFromHome).document("\(num)").setData(["currBal":currRetbal2], merge:true) { (err) in
                    if err == nil {
                        self.updateNotewithoutloop(withID: num + 1, toID: last, withCurrBal2: currRetbal2)
                            
                        } else {print("Error in updating note with id \(num)")}
                    
                }
            }
        }
    }
    
    struct listview_Previews: PreviewProvider {
        static var previews: some View {
            listview(item: NoteType(uniqid: 0, amount: 0.00, name: "bj", note: "k", time: Timestamp(), transaction: "Cash", ty: "Minus", balance: 10200.00), userNameFromHome: "", extend: .constant(true))
        }
    }
}
