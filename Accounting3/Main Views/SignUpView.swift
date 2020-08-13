//
//  SignUpView.swift
//  Accounting3
//
//  Created by Bhargin Kanani on 5/9/20.
//  Copyright © 2020 pc1. All rights reserved.
//

import SwiftUI
import CloudKit

struct SignUpView: View {
    @State private var username2 = ""
    @State private var password2 = ""
    @State private var confirmPassword2 = ""
    @State private var loginView = false
    @State private var showHome = false
    @State private var users = [User]()
    @State var homeName = String()
    @State private var showAlert = false
    
    @State private var passwordMisMatch = false
    
    let database = CKContainer.default().publicCloudDatabase
    let ck = CloudData()
    
    var body: some View {
        ZStack {
            ZStack {
                Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
                    .onTapGesture {
                        self.endEditing()
                }
                
                Text("Sign up")
                    .font(.largeTitle)
                    .fontWeight(.black)
                    .foregroundColor(.black)
                    .offset(x: 0, y: -190)
                    .onAppear {
                        self.fetchUserAccounts()
                        self.username2.removeAll()
                }
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 350, height: 60)
                    .offset(x: 0, y: -90)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                    .onTapGesture {
                        self.endEditing()
                }
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 350, height: 60)
                    .offset(x: 0, y: -20)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                    .onTapGesture {
                        self.endEditing()
                }
                
                RoundedRectangle(cornerRadius: 10)
                    .frame(width: 350, height: 60)
                    .offset(x: 0, y: 50)
                    .foregroundColor(.white)
                    .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                    .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                    .onTapGesture {
                        self.endEditing()
                }
                
                TextField("Enter Username", text: $username2){
                    self.endEditing()
                }
                .offset(x: 0, y: -90)
                .frame(width: 330, height: 60)
                
                SecureField("Enter Password", text: $password2) {
                    self.endEditing()
                }
                .offset(x: 0, y: -20)
                .frame(width: 330, height: -600)
                
                SecureField("Confirm Password", text: $confirmPassword2) {
                    self.endEditing()
                }
                .offset(x: 0, y: 50)
                .frame(width: 330, height: 60)
                .alert(isPresented: $passwordMisMatch){
                    
                    
                    Alert(title: Text("Invalid passwords"), message: Text("Try re-enter your password. They have to be same and cannot be blank."), dismissButton: .default(Text("ok")))
                }
                
                
                Button(action: {
                    self.endEditing()
                    
                    if (self.users.count == 0 || self.users == nil) {
                        
                        let temp = [User(username: self.username2, password: self.password2)]
                        self.users = temp
                        
                        if let newConvertedUser = try? NSKeyedArchiver.archivedData(withRootObject: self.users, requiringSecureCoding: false){
                            self.ck.intializeNewUserRecord(user: newConvertedUser as NSData)
                            
                            self.showHome = true
                            self.homeName = self.username2
                            self.password2.removeAll()
                        }
                    } else {
                        
                        for user in self.users {
                            if user.username == self.username2 {
                                self.showAlert = true
                                return
                            }
                        }
                        
                        if (self.password2 != self.confirmPassword2 && (self.password2.isEmpty && self.confirmPassword2.isEmpty)) {
                            self.passwordMisMatch = true
                            self.password2.removeAll()
                            self.confirmPassword2.removeAll()
                        }
                        
                        if (self.password2 == self.confirmPassword2) {
                            self.users.append(User(username: self.username2, password: self.password2))
                            
                            if let newConvertedUser = try? NSKeyedArchiver.archivedData(withRootObject: self.users, requiringSecureCoding: false) {
                                self.ck.editFetchedOther(to: self.database, withRecordName: "LoginAccounts", save: newConvertedUser as NSData, forKey: "info")
                                print("edited user list")
                                
                                self.showHome = true
                                self.homeName = self.username2
                                self.password2.removeAll()
                                
                            }
                        }
                    }
                    
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 20)
                        HStack{
                            Spacer()
                            Text("Sign up")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                }
                .frame(width: 340, height: 50)
                .offset(x: 0, y: 120)
                .foregroundColor(Color("card3"))
                .alert(isPresented: self.$showAlert) {
                    Alert(title: Text("This username is taken"), message: Text("Please enter another username!"), dismissButton: .default(Text("Ok")) {
                        self.username2 = ""
                        self.password2.removeAll()
                        self.confirmPassword2.removeAll()
                        })
                }
                
                HStack{
                    Text("Already have an account?")
                    
                    Button(action: {
                        self.endEditing()
                        self.loginView = true
                    }) {
                        Text("Login here")
                    }
                    .foregroundColor(Color("card3"))
                }
                .offset(x: 0, y: 370)
                
                
                
            }
            .edgesIgnoringSafeArea(.all)
            
            if self.loginView{
                LoginView()
                    .transition(.move(edge: .bottom))
                    .animation(.spring())
            }
            if self.showHome {
                HomeView(username: self.homeName)
                    .transition(.slide)
                    .animation(.spring())
            }
        }
            
        .edgesIgnoringSafeArea(.all)
    }
    
    func fetchUserAccounts(){
        self.database.fetch(withRecordID: CKRecord.ID(recordName: "LoginAccounts")) { (CKUsersRecord, Err) in
            
            if Err != nil {
                print(Err!)
                
            } else {
                if let decodedUsers = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(CKUsersRecord?.value(forKeyPath: "info") as! Data) as? [User] {
                    self.users = decodedUsers
                    
                    for user in self.users {
                        print(user.username)
                    }
                }
            }
            
        }
    }
    
    private func endEditing() {
        UIApplication.shared.endEditing()
    }
    
    
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
