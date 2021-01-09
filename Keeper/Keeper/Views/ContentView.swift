//
//  ContentView.swift
//  Keeper
//
//  Created by Bhargin Kanani on 8/11/20.
//  Copyright © 2020 Bhargin Kanani. All rights reserved.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseCore
import FirebaseAuth
//import Timestamp


struct ContentView: View {
    
    @State var blurTapped = false
    @State var userName: String = ""
    @Binding var signoutTapped: Bool
    var body: some View {
        
        homeview(blurTapped: self.$blurTapped, signoutTapped: self.$signoutTapped, userNameIN: self.userName)
            .blur(radius: self.blurTapped ? 20 : 0)
            .animation(.spring())
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(userName: "bkanani@terpmail.umd.edu", signoutTapped: .constant(false))
    }
}

struct homeview: View {
    @Binding var blurTapped: Bool
    @Binding var signoutTapped: Bool
    @State var extendTrue = true
    @State var extendFalse = false
    @State var morph = false
    @State var searchText = ""
    @State var firstname = String()
    @State var phone = String()
    @State var dragOffset = CGSize.zero
    @State var cardUp = false
    @State var showAdd = false
    @State var showContactSheet = false
    @State var showSearch = false
    @State var addNewContact = false
    let array = ["Bhargin", "Dhwani", "Alpa", "Paresh", "Shrey", "Bhargin", "Dhwani", "Alpa", "Paresh", "Shrey"]
    @State var contacts = [String]()
    @State var tempContacts = [String]()
    @State var numbers = [String]()
    @State var tempNumbers = [String]()
    @State var extendIndexes = [Int]()
    @State var contactIndexes = [String]()
    @State var success1 = false
    @State var success2 = false
    @State var intId = 0
    @State var notesArray: [NoteType] = []
    var userNameIN: String
    private let auth = Auth.auth()
    
    let db = Firestore.firestore()
    
    var calendar = Calendar.current
    let user = Auth.auth().currentUser
    
    var body: some View {
        ZStack{
            
            Color(#colorLiteral(red: 1, green: 0.768627451, blue: 0.1725490196, alpha: 1))
                
            
            HStack {
                Text("Home")
                    .font(Font.custom("TTFirsNeue-DemiBold", size: 35))
                
                Button(action: {self.getRecents()}) {
                    Image(systemName: "arrow.counterclockwise")
                }
                .foregroundColor(.black)
               
                Spacer()
                Button(action: {
                    self.signoutTapped = true
                    self.signout()
//                    let date = Date()
//
//                    print("\(date), \(calendar.component(.hour, from: date)), \(calendar.component(.minute, from: date)), \(calendar.component(.second, from: date))")
//
//                                        let docRef: Void = db.collection(userNameIN).document("contacts").getDocument { (document, err) in
//
//                                            if err == nil {
//                                                if document != nil && document!.exists {
//                                                    let docuData = document?.data()
//                                                    print("number: \(String(describing: docuData?["tag"] as! String))")
//                                                }
//                                            } else {
//                                                print("found error")
//                                            }
//
//                                        }
//
                    
                }) {
                    Image(systemName: "bell.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                    
                }
                .foregroundColor(.black)
                .frame(width: 27, height: 27)
            }
            .padding(.horizontal, 30)
            .offset(y: -360)
            
            creditcardView(userNameInFromHome: self.userNameIN)
                .offset(y: -200)
                .onAppear{ self.getRecents()}
               
            
            
            //MARK: Bottom White Card
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .frame(width: screen.width, height: 700)
                .offset(y: self.cardUp ? 99:400)
                
            
            RoundedRectangle(cornerRadius: 20)
                .frame(width: 50, height:  10)
                .offset(y: self.cardUp ? -230:70)
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
            
            
            ScrollView(showsIndicators: false){
                VStack{
                    ForEach(self.notesArray.reversed(), id: \.self) { note in
                        listview(item: note, userNameFromHome: userNameIN, extend: self.extendIndexes.contains(note.ID) ? self.$extendTrue:self.$extendFalse)
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
            .frame(width: screen.width, height: self.cardUp ? 630:330)
            .offset(y: self.cardUp ? 99:250)
            
            
            
            //MARK: FIRST CIRCLE
            if (self.cardUp == false) {
                if (self.showContactSheet == false || self.showSearch == false) {
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: self.showAdd ? 0:50)
                            .foregroundColor(self.showAdd ? .black :.white)
                            .frame(maxWidth: self.showAdd ? .infinity:65)
                            .frame(maxHeight: self.showAdd ? .infinity:65)
                            .onTapGesture {
                                self.showAdd.toggle()
                            }
                        
                        Image(systemName: "plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(.black)
                            .foregroundColor(self.cardUp ? .white:.black)
                        
                    }
                    .onTapGesture {
                        self.showAdd.toggle()
                    }
                    .offset(x:self.showAdd ? 0:-125, y: -20)
                    .opacity(self.cardUp ? 0:1)
                    .animation(.spring())
                    .edgesIgnoringSafeArea(.all)
                    
                    Text("Add")
                        .font(Font.custom("TTFirsNeue-DemiBold", size: 15))
                        .foregroundColor(self.showAdd ? .white:.black)
                        .foregroundColor(self.cardUp ? .white:.black)
                        .opacity(self.cardUp ? 0:1)
                        .animation(.spring())
                        .offset(x:-125, y:30)
                    
                }
                
            }
            
            //MARK: SECOND CIRCLE
            if (self.cardUp == false) {
                if (self.showAdd != true) {
                    
                    //MARK: second circle
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .foregroundColor(.white)
                            .frame(width: 65, height: 65)
                        
                        Image(systemName: "person")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            
                            .foregroundColor(self.cardUp ? .white:.black)
                        
                    }
                    .onTapGesture {
                        
                        self.extendIndexes.removeAll()
                        
                        //MARK: QUERY Contacts
                        db.collection(userNameIN).document("Contacts").getDocument { (document, err) in
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
                                db.collection(userNameIN).document("Contacts")
                                print("created document")
                            }
                        }
                        
                        
                        self.showContactSheet = true
                    }
                    .offset(y: -20)
                    .opacity(self.cardUp ? 0:1)
                    .animation(.spring())
                    .edgesIgnoringSafeArea(.all)
                    
                    Text("Contact")
                        .font(Font.custom("TTFirsNeue-DemiBold", size: 15))
                        .opacity(self.cardUp ? 0:1)
                        .foregroundColor(self.cardUp ? .white:.black)
                        .animation(.spring())
                        .offset(x:0, y:30)
                        .sheet(isPresented: self.$showContactSheet, onDismiss: {
                            self.addNewContact = false
                            self.contacts.removeAll()
                            self.numbers.removeAll()
                        }) {
                            ZStack {
                                
                                //MARK: Contact sheet
                                VStack {
                                    
                                    HStack {
                                        Spacer()
                                        Button(action: {
                                            
                                            self.addNewContact = true
                                            self.extendIndexes.removeAll()
                                        }) {
                                            HStack{
                                                Image(systemName: "plus.circle.fill")
                                                    .resizable()
                                                    .aspectRatio(contentMode: .fit)
                                                    .frame(width: 23, height: 25)
                                                
                                                Text("Add")
                                                    .font(Font.custom("TTFirsNeue-Regular", size: 17))
                                            }
                                            .foregroundColor(.black)
                                            .frame(width: 70, height: 25)
                                        }
                                        .offset(y: -30)
                                    }
                                    .padding(.horizontal)
                                    
                                    
                                    
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
                                                        contactListView(info: name, mobile: self.numbers[self.contacts.firstIndex(of: name)!], extend: self.contactIndexes.contains(name) ? self.$extendTrue:self.$extendFalse)
                                                            .onTapGesture {
                                                                
                                                                if(self.contactIndexes.contains(name)) {
                                                                    self.contactIndexes.remove(at: self.contactIndexes.firstIndex(of: name) ?? 0)
                                                                } else {
                                                                    self.contactIndexes.append(name)
                                                                }
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
                                
                                //MARK: Add Contact sheet
                                VStack {
                                    
                                    HStack {
                                        Button(action: {
                                            self.addNewContact = false
                                            self.resetSuccess()
                                            self.firstname.removeAll()
                                            self.phone.removeAll()
                                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                        }) {
                                            HStack{
                                                
                                                
                                                Text("Cancel")
                                                    .font(Font.custom("TTFirsNeue-Regular", size: 18))
                                            }
                                            .foregroundColor(.black)
                                            .frame(width: 90, height: 30)
                                        }
                                        .offset(y: -30)
                                        Spacer()
                                        Button(action: {
                                            
                                            self.tempContacts.append(self.firstname)
                                            self.tempNumbers.append(self.phone)
                                            
                                            db.collection(userNameIN).document("Contacts").setData(["names":self.tempContacts], merge: true) { (err) in
                                                if err == nil {
                                                    self.contacts.append(self.firstname)
                                                    self.firstname.removeAll()
                                                    self.success1 = true
                                                    print("\(self.contacts)")
                                                } else {
                                                    print("Could not add contact!")
                                                }
                                            }
                                            
                                            db.collection(userNameIN).document("Contacts").setData(["numbers":self.tempNumbers], merge: true) { (err) in
                                                if err == nil {
                                                    self.numbers.append(self.phone)
                                                    self.phone.removeAll()
                                                    self.addNewContact = false
                                                    self.resetSuccess()
                                                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                                                    self.success2 = true
                                                    print("\(self.numbers)")
                                                } else {
                                                    print("Could not add number!")
                                                }
                                            }
                                            
                                            
                                            
                                        }) {
                                            HStack{
                                                
                                                Text("Done")
                                                    .font(Font.custom("TTFirsNeue-Regular", size: 18))
                                            }
                                            .foregroundColor(.black)
                                            .frame(width: 80, height: 30)
                                        }
                                        .offset(y: -30)
                                    }
                                    .padding(.horizontal, 3)
                                    
                                    
                                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                                        Image(systemName: "person.crop.circle")
                                            .resizable()
                                            .aspectRatio(contentMode: .fit)
                                            .frame(width: 150, height: 150)
                                            .foregroundColor(.black)
                                    }
                                    
                                    TextField("First Name", text: self.$firstname)
                                        .font(Font.custom("TTFirsNeue-Regular", size: 18))
                                        .padding(.leading)
                                    
                                    TextField("Mobile", text: self.$phone)
                                        .font(Font.custom("TTFirsNeue-Regular", size: 18))
                                        .padding(.leading)
                                    Spacer()
                                    
                                }
                                .frame(height: 730)
                                .offset(x: self.addNewContact ? 0:500, y: 10)
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
            }
            
        
            //MARK: THIRD CIRCLE
            if (self.cardUp == false) {
                if(self.showAdd != true) {
                    //MARK: thrid circle
                    ZStack {
                        RoundedRectangle(cornerRadius: 50)
                            .foregroundColor(.white)
                            .frame(width: 65, height: 65)
                        
                        Image(systemName: "magnifyingglass")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                            .foregroundColor(self.cardUp ? .white:.black)
                        
                    }
                    .animation(.spring())
                    .onTapGesture {
                        self.showSearch.toggle()
                        self.extendIndexes.removeAll()
                    }
                    .offset(x: 125, y: -20)
                    .opacity(self.cardUp ? 0:1)
                    .edgesIgnoringSafeArea(.all)
                    .sheet(isPresented: self.$showSearch){
                        searchView(returnHome: self.$showSearch, userNameFromHome: userNameIN)
                       
                            
                    }
                    
                    
                    Text("Search")
                        .font(Font.custom("TTFirsNeue-DemiBold", size: 15))
                        .opacity(self.cardUp ? 0:1)
                        .foregroundColor(self.cardUp ? .white:.black)
                        .animation(.spring())
                        .offset(x:125, y:30)
                    
                    
                }
            }
            
            
            if self.showAdd {
                Accountview(returnHome: self.$showAdd, userNameFromHome: userNameIN)
                    .animation(.spring())
                    .onDisappear{
                        self.getRecents()
                    }
            }
            
           
            
        }
        .edgesIgnoringSafeArea(.all)
       
    }
    
    func resetSuccess(){
        self.success1 = false
        self.success2 = false
    }
    
    func signout() {
        
        if auth.currentUser != nil {
            do {
                print("Currently signed in \(auth.currentUser?.email)")
                try auth.signOut()
            } catch let signOutError as NSError{
                print ("Error signing out: \(signOutError)")
            }
        } else {
            print("No one is signed in")
        }
        
        
    }
    
    
    func getRecents(){
        db.collection(userNameIN).document("other").getDocument { (snapshot, err) in
            if err == nil {
                if snapshot!.exists && snapshot != nil {
                    let data = snapshot!.data()
                    let retid = data?["index"] as! Int
                    self.notesArray.removeAll()
                    self.queryRecents(id: retid)
                }
               
            }
           
        }
        
    }
    func queryRecents(id: Int){
        
        db.collection(userNameIN).whereField("ID", isGreaterThanOrEqualTo: (id - 10)).getDocuments { (QuerySnapshot, err) in
            if err == nil {
                for document in QuerySnapshot!.documents {
                    let data =  document.data()
                    
                    
                    self.notesArray.append(NoteType(uniqid: data["ID"] as! Int, amount: data["Amount"] as! Double, name: data["Name"] as! String, note: data["Note"] as! String, time: data["Time"] as! Timestamp , transaction: data["Transaction"] as! String, ty: data["Type"] as! String, balance: data["currBal"] as! Double))
                    
                    
                    
                }
            }
        }
            
        
    }
}

let screen = UIScreen.main.bounds


