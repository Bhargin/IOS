//
//  Accountview.swift
//  Keeper
//
//  Created by Bhargin Kanani on 9/6/20.
//  Copyright © 2020 Bhargin Kanani. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth


struct Accountview: View {
    
    @Binding var returnHome: Bool
    @State var cardUp = false
    @State var morph = false
    @State var dragOffset = CGSize.zero
    @State var person = "Select Person"
    @State var amount = ""
    @State var note = ""
    @State var tappedAmount = false
    @State var tappedNote = false
    @State var chequeTapped = false
    @State var minusTapped = false
    @State var contacts = [String]()
    @State var tempContacts = [String]()
    @State var numbers = [String]()
    @State var tempNumbers = [String]()
    @State var showContactSheet = false
    @State var addNewContact = false
    @State var extendTrue = true
    @State var extendFalse = false
    @State var searchText = ""
    @State var extendIndexes = [Int]()
    @State var contactIndexes = [String]()
    @State var plusAmount = 0.00
    @State var minusAmount = 0.00
    @State var showAlert = false
    @State var showSaveAlert = false
    @State var showErrorAlert = false
    @State var message = "Message here."
    @State var docid = ""
    @State var intId = 0
    @State var intId2 = 0
    @State var bal = 0.00
    @State var notesArray: [NoteType] = []
    var userNameFromHome: String
    let db = Firestore.firestore()
    
    var body: some View {
        ZStack {
            Color(.black)
                .onTapGesture {
                    self.tappedAmount = false
                    self.tappedNote = false
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }
            
            
            
            Button(action: {
                self.returnHome = false
                self.reset()
                self.minusTapped = false
                self.chequeTapped = false
                self.extendIndexes.removeAll()
                self.cardUp = false
                
                
            }) {
                Image(systemName: "arrow.left")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            .frame(width: 30, height: 53)
            .foregroundColor(.white)
            .offset(x: -150, y: -370)
            .onAppear{
                self.saveandupdate()
            }
            
            
            
            /*MARK: Select contact sheet.*/
            HStack {
                Button(action: {
                    self.showContactSheet = true
                    
                    //MARK: Query Contacts
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
                }) {
                    Text(self.person)
                        .foregroundColor(.white)
                        .font(Font.custom("TTFirsNeue-Medium", size: 40))
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
                                                                self.reset()
                                                                self.showContactSheet = false
                                                                self.person = name
                                                                self.getAmount()
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
                                
                                
                                
                                if #available(iOS 14.0, *) {
                                    if self.contacts.isEmpty && addNewContact == false{
                                        ProgressView(value: 1.0)
                                            .progressViewStyle(CircularProgressViewStyle())
                                            .scaleEffect(2.0, anchor: .center)
                                    }
                                } else {
                                    // Fallback on earlier versions
                                    Text("Loading")
                                        .foregroundColor(.black)
                                }
                            }
                        }
                }
                .offset(x: -25,y: -310)
                
                Spacer()
                
                
            }
            .padding(.leading, 65)
            
            HStack {
                Text(String(format: "%.2f", self.plusAmount))
                    .foregroundColor(Color(#colorLiteral(red: 0.07843137255, green: 0.8, blue: 0.3764705882, alpha: 1)))
                Spacer()
                Text(String(format: "%.2f", self.minusAmount))
                    .foregroundColor(Color(#colorLiteral(red: 1, green: 0.2554525024, blue: 0.07898835458, alpha: 1)))
            }
            .font(Font.custom("TTFirsNeue-DemiBold", size: 30))
            .offset(y: -240)
            .padding(.horizontal, 40)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("Insert Amount")
                    .foregroundColor(.white)
                    .font(Font.custom("TTFirsNeue-Light", size: 17))
                    .opacity(0.5)
                
                ZStack {
                    Text("Enter here")
                        .foregroundColor(.white)
                        .font(Font.custom("TTFirsNeue-Medium", size: 20))
                        .offset(x: -142)
                        .opacity(self.tappedAmount ? 0:1)
                        .opacity(self.amount.isEmpty ? 1:0)
                        .animation(.spring())
                    
                    
                    TextField("Enter here", text: self.$amount)
                        .foregroundColor(.white)
                        .font(Font.custom("TTFirsNeue-Medium", size: 20))
                        .onTapGesture {
                            self.tappedAmount = true
                        }
                    
                }
                
                Spacer()
                
                Text("Insert Note")
                    .foregroundColor(.white)
                    .font(Font.custom("TTFirsNeue-Light", size: 17))
                    .opacity(0.5)
                ZStack {
                    Text("Enter note")
                        .foregroundColor(.white)
                        .font(Font.custom("TTFirsNeue-Regular", size: 20))
                        .offset(x: -142)
                        .opacity(self.tappedNote ? 0:1)
                        .opacity(self.note.isEmpty ? 1:0)
                        .animation(.spring())
                    
                    
                    TextField("Enter here", text: self.$note)
                        .foregroundColor(.white)
                        .font(Font.custom("TTFirsNeue-Regular", size: 20))
                        .onTapGesture {
                            self.tappedNote = true
                        }
                    
                }
                
            }
            .padding(.leading, 30)
            .frame(height: 120)
            .offset(y: -30)
            .alert(isPresented: self.$showErrorAlert, content: {
                Alert(title: Text("Error"), message: Text("Error occured. Please try again later."), dismissButton: .default(Text("Ok")){
                    self.showErrorAlert = false
                })
            })
            
            //MARK: Plus & Minus SELECTOR
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundColor(.white)
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
                    .foregroundColor(self.minusTapped ? .white:.black)
                    
                    
                    
                    Text("-")
                        .frame(width: 20, height: 17)
                        .onTapGesture{
                            self.minusTapped = true
                            print("minusTapped")
                        }
                        .foregroundColor(self.minusTapped ? .black:.white)
                    
                    
                }
                .foregroundColor(.black)
                .offset(x: -7)
                .animation(.spring())
                .font(Font.custom("TTFirsNeue-DemiBold", size: 40))
                
            }
            .offset(x: 115, y: 60)
            
            
            HStack(spacing: 115) {
                
                
                Button(action: {
                    self.showSaveAlert = true
                    
                }) {
                    HStack(alignment: .top, spacing: 0) {
                        Text("Save")
                            .font(Font.custom("TTFirsNeue-DemiBold", size: 27))
                        
                        Image(systemName: "arrow.down.to.line.alt")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 30)
                    }
                    .opacity(self.amount.isEmpty ? 0: 1)
                    .padding(.leading, 12)
                    
                }
                .foregroundColor(.white)
                .alert(isPresented: self.$showSaveAlert, content: {
                    Alert(title: Text("Save this note!"), message: Text("Do you want to save the note."), primaryButton: .default(Text("Save")){
                        self.notesArray.removeAll()
                        self.saveandupdate()
                    }, secondaryButton: .destructive(Text("Cancel")))
                })
                
                
                
                
                
                //MARK: CASH & CHEQUE SELECTOR
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .frame(width: self.chequeTapped ? 90:75, height: 35)
                        .offset(x: self.chequeTapped ? 35:-47, y: 0)
                        .animation(.spring())
                    
                    HStack(spacing: 23){
                        Text("cash")
                            .foregroundColor(self.chequeTapped ? .white:.black)
                            .onTapGesture {
                                self.chequeTapped = false
                            }
                        
                        
                        Text("cheque")
                            .foregroundColor(self.chequeTapped ? .black:.white)
                            .onTapGesture {
                                self.chequeTapped = true
                            }
                        
                        
                    }
                    .foregroundColor(.black)
                    .animation(.spring())
                    .font(Font.custom("TTFirsNeue-DemiBold", size: 20))
                    
                }
            }
            .frame(width: screen.width)
            .offset(y: 110)
            
            
            //MARK: Bottom White Card
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .frame(width: screen.width, height: 700)
                .offset(y: self.cardUp ? 99:490)
                .offset(y: self.returnHome ? 20:800)
                .animation(.spring())
            
            //MARK: SCROLL VIEW FOR RECENTS
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
                        
                    }
                }
            }
            .frame(width: screen.width, height: self.cardUp ? 600:300)
            .offset(y: self.cardUp ? 99:360)
            .offset(y: self.returnHome ? -10:800)
            
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 50, height:  10)
                .offset(y: self.cardUp ? -230:160)
                .offset(y: self.returnHome ? 20:800)
                .foregroundColor(Color.gray)
                .gesture(
                    DragGesture()
                        .onChanged({ gesture in
                            self.dragOffset = gesture.translation
                        })
                        .onEnded({ _ in
                            if self.dragOffset.height < 20 {
                                self.morph = false
                                self.cardUp = true
                            } else {
                                self.cardUp = false
                            }
                        })
                )
                .animation(.spring())
        }
        .offset(y: self.tappedAmount||self.tappedNote ? -30:0)
        .animation(.spring())
        .edgesIgnoringSafeArea(.all)
    }
    
    
    
    func saveandupdate() {
        
        //self.intId = 0
        
        if self.person != "Select Person" && self.amount != "" {
            self.save()
        } else {
            db.collection(userNameFromHome).document("other").getDocument { (snapshot, err) in
                if err == nil {
                    if snapshot!.exists && snapshot != nil{
                        let data = snapshot!.data()
                        let retid = data?["index"] as! Int
                        self.notesArray.removeAll()
                        self.getRecents(id: retid)
                    }
                    
                   
                }
               
            }
        }
        
    }
    
    func save() {
        //let newid = UUID().uuidString
        let oldbal = Double(self.amount)!
        let name = self.person
        let note = self.note
        
        let date = Timestamp.init()
        //self.intId2 = newid + 1
      
        db.collection(userNameFromHome).document("Balance").getDocument { (DocumentSnapshot, err) in
            if err == nil{
                if DocumentSnapshot!.exists && DocumentSnapshot != nil {
                    let data = DocumentSnapshot!.data()
                    let ret = data!["balance"] as! Double
                    print("ret...... = \(ret)")
                    
                    db.collection(userNameFromHome).document("other").getDocument { (snapshot, err) in
                        
                        if snapshot!.exists && snapshot != nil{
                            let newbal = self.minusTapped ? (ret - oldbal):(ret + oldbal)
                            let data = snapshot!.data()
                            let id = data?["index"] as! Int
                            
                            print("newbal = \(newbal)")
                            db.collection(userNameFromHome).document("\(id + 1)").setData(["ID":(id + 1), "Name":name, "Type": (self.minusTapped ? "Minus":"Plus"), "Transaction":(self.chequeTapped ? "Cheque":"Cash"), "Amount": oldbal, "Note":note, "Time":date, "currBal":newbal], merge: true) { (err) in
                                
                                if err == nil {print("Added to console")} else { self.showErrorAlert = true}
                            }
                            
                            db.collection(userNameFromHome).document("other").setData(["index":(id + 1)], merge: true) { (err) in
                                if err == nil {print("edited other")} else { self.showErrorAlert = true}
                            }
                            
                            db.collection(userNameFromHome).document("Balance").setData(["balance":newbal], merge: true) { (err) in
                                if err == nil {print("updated balance")} else {self.showErrorAlert = true}
                            }
                            
                            self.getRecents(id: (id + 1))
                            self.minusTapped = false
                            self.chequeTapped = false
                        }
                    }
                } else {
                    
                    print("Entered else.............")
                    db.collection(userNameFromHome).document("\(self.intId2)").setData(["ID": 0, "Name":name, "Type": (self.minusTapped ? "Minus":"Plus"), "Transaction":(self.chequeTapped ? "Cheque":"Cash"), "Amount": self.minusTapped ? (-1 * oldbal):oldbal, "Note":self.note, "Time":date, "currBal":self.minusTapped ? (-1 * oldbal):oldbal], merge: true) { (err) in
                        
                        if err == nil {print("Added to console")} else { self.showErrorAlert = true}
                    }
                    
                    db.collection(userNameFromHome).document("other").setData(["index":0], merge: true) { (err) in
                        if err == nil {print("edited other")} else { self.showErrorAlert = true}
                    }
                    
                    db.collection(userNameFromHome).document("Balance").setData(["balance":self.minusTapped ? (-1 * oldbal):oldbal], merge: true) { (err) in
                        if err == nil {print("updated balance")} else {self.showErrorAlert = true}
                    }
                    
                    self.getRecents(id: 0)
                    self.minusTapped = false
                    self.chequeTapped = false
                }
                
            }
            else {
                self.showErrorAlert = true
                print(err!.localizedDescription)
            }
        }
        self.reset()
    }
    
    func getRecents(id: Int) {
        db.collection(userNameFromHome).whereField("ID", isGreaterThanOrEqualTo: (id - 10)).getDocuments { (QuerySnapshot, err) in
            if err == nil {
                for document in QuerySnapshot!.documents {
                    let data =  document.data()
                    
                    var newNote = NoteType(uniqid: data["ID"] as! Int, amount: data["Amount"] as! Double, name: data["Name"] as! String, note: data["Note"] as! String, time: data["Time"] as! Timestamp, transaction: data["Transaction"] as! String, ty: data["Type"] as! String, balance: data["currBal"] as! Double)
                    
                    self.notesArray.append(newNote)
                    
                }
            }
        }
        
        
    }
    
    func getBalance() -> Double {
        var result = 0.00
        db.collection(userNameFromHome).document("Balance").getDocument { (DocumentSnapshot, err) in
            if err == nil{
                if DocumentSnapshot!.exists && DocumentSnapshot != nil {
                    let data = DocumentSnapshot!.data()
                    let ret = data!["balance"] as! Double
                    print("balance = \(ret)")
                    result = ret
                }
            }
        }
        return result
    }
    
    func getAmount() {
        db.collection(userNameFromHome).whereField("Name", isEqualTo: self.person).getDocuments { (snapshot,err) in
            
            if err == nil {
                for document in snapshot!.documents{
                    let docdata = document.data()
                    
                    if (docdata["Type"] as! String == "Plus"){
                        self.plusAmount += docdata["Amount"] as! Double
                    }
                    
                    if (docdata["Type"] as! String == "Minus"){
                        self.minusAmount += docdata["Amount"] as! Double
                    }
                    
                }
            }
            
            else {
                self.showErrorAlert = true
            }
        }
    }
    
    func reset() {
        self.plusAmount = 0
        self.minusAmount = 0
        self.tappedNote = false
        self.tappedAmount = false
        self.person = "Select Person"
        self.amount.removeAll()
        self.note.removeAll()
        
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

struct Accountview_Previews: PreviewProvider {
    static var previews: some View {
        Accountview(returnHome: .constant(true), userNameFromHome: "")
    }
}
