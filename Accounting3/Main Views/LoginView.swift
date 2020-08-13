//
//  LoginView.swift
//  Accounting3
//
//  Created by Bhargin Kanani on 5/8/20.
//  Copyright © 2020 pc1. All rights reserved.
//

import SwiftUI
import CloudKit

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var signUpView = false
    @State private var showHome = false
    @State private var users = [User]()
    @State var homeName = String()
    
    @State private var signUpAlert = false
    @State private var incorrectCred = false
    
    let database = CKContainer.default().publicCloudDatabase
    let ck = CloudData()
    
    var body: some View {
        
        ZStack {
            Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1))
                .onTapGesture {
                    self.endEditing()
            }
            
            Text("Welcome Back")
                .font(.largeTitle)
                .fontWeight(.black)
                .foregroundColor(.black)
                .offset(x: 0, y: -150)
                .onAppear {
                    self.fetchUserAccounts()
                    self.username.removeAll()
            }
            .onTapGesture {
                self.endEditing()
            }
            
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 350, height: 60)
                .offset(x: 0, y: -70)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
            .onTapGesture {
                           self.endEditing()
                       }
            
            RoundedRectangle(cornerRadius: 10)
                .frame(width: 350, height: 60)
                .offset(x: 0, y: -5)
                .foregroundColor(.white)
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
            .onTapGesture {
                           self.endEditing()
                       }
            
            TextField("Enter Username", text: $username){
                self.endEditing()
            }
                .offset(x: 0, y: -70)
                .frame(width: 330, height: 60)
            .alert(isPresented: $signUpAlert) {
                Alert(title: Text("You don't have an Account"), message: Text("Sign up now!"), dismissButton: .default(Text("Ok")) {
                    self.password.removeAll()
                    
                    })
            }
            
            SecureField("Enter Password", text: $password) {
                self.endEditing()
            }
                .offset(x: 0, y: -5)
                .frame(width: 330, height: 60)
            .alert(isPresented: $incorrectCred) {

                               Alert(title: Text("Incorrect Username or Password"), message: Text("Please try again. Or sign up!"), dismissButton: .default(Text("Ok")) {
                                   self.password.removeAll()
                                   
                                   })
                           
                       }
            
            
            
            Button(action: {
                
                self.endEditing()
                if (self.users.count == 0 || self.users == nil){
                    self.signUpAlert = true
                } else {
                    for user in self.users {
                        if (user.username == self.username && user.password == self.password) {
                            self.homeName = self.username
                            self.showHome = true
                           
                            
                            self.password.removeAll()
                        }
                    }
                    
                    if self.showHome != true {
                        self.incorrectCred = true
                      
                    }
                    
                }
                
                
               
                
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                    HStack{
                        Spacer()
                        Text("Login")
                            .font(.headline)
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                        Spacer()
                    }
                }
            }
            .frame(width: 340, height: 50)
            .offset(x: 0, y: 60)
            .foregroundColor(Color("card3"))
            
           
            
            HStack{
                Text("Don't have an account?")
                
                Button(action: {
                    self.endEditing()
                    self.signUpView = true
                }) {
                    Text("Sign up")
                }
                .foregroundColor(Color("card3"))
            }
            .offset(x: 0, y: 370)
            
            if self.signUpView{
                SignUpView()
                    .transition(.move(edge: .top))
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

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
