//
//  login.swift
//  Keeper
//
//  Created by Bhargin Kanani on 8/12/20.
//  Copyright © 2020 Bhargin Kanani. All rights reserved.
//

import SwiftUI
import FirebaseAuth

struct login: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State var pull_up: Bool = false
    private let auth = Auth.auth()
    @State private var showHome = false
    @State var blurTapped = true
    @State private var loginError = false
    @State private var resetPass = false
    @State private var resetPassError = false
    @State private var signoutTapped = false
    @State private var passedInUserName = ""
    @State private var showForgotPasswordView = false
    @State private var loginerrormessage = ""
    @State private var resetPassErrormessage = ""
    @State private var joinnow = false
    @State private var joinnowError = false
    @State private var joinnowErrorMessage = ""
    
    var body: some View {
        ZStack{
            Color(#colorLiteral(red: 0.9085983667, green: 0.9380948604, blue: 0.919694858, alpha: 1))
            
            
            Image("logo2")
                .resizable()
                .frame(width: 230, height: 230, alignment: .center)
                .aspectRatio(contentMode: .fit)
                .offset(y: screen.height - 1200)
                .alert(isPresented: self.$resetPass, content: {
                    Alert(title: Text("Reset link sent"), message: Text("Please check your email for the link"), dismissButton: .default(Text("Ok")))
                })
            
            VStack(spacing: 15){
                
                Text(self.showForgotPasswordView ? "FORGOT PASSWORD": self.joinnow ? "Enter New User Detail":"LOGIN")
                    .font(Font.custom("Roboto-Bold", size: 25))
                    .alert(isPresented: self.$loginError, content: {
                        Alert(title: Text("Login Error!"), message: Text("\(loginerrormessage)!"), dismissButton: .default(Text("Ok"), action: {
                            self.username.removeAll()
                            self.password.removeAll()
                        }))
                    })
                
                ZStack{
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                        .frame(width: 350, height: 50)
                    
                    TextField("Enter Email", text: $username)
                        .padding(.leading)
                        .foregroundColor(.black)
                        .frame(width: 350, height: 50)
                }
                    
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                .onTapGesture {
                    self.pull_up = true
                }
                .alert(isPresented: self.$resetPassError, content: {
                    Alert(title: Text("Error!"), message: Text("\(resetPassErrormessage)!"), dismissButton: .default(Text("Ok"), action: {
                        self.username.removeAll()
                        self.password.removeAll()
                    }))
                })
                
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                        .frame(width: 350, height: 50)
                        .opacity(self.showForgotPasswordView ? 0:1)
                        .animation(.spring())
                        .alert(isPresented: self.$joinnowError, content: {
                            Alert(title: Text("Error!"), message: Text("\(self.joinnowErrorMessage)"), dismissButton: .default(Text("Ok")))
                        })
                    
                    SecureField("Enter Password", text: $password)
                        .padding(.leading)
                        .foregroundColor(.black)
                        .frame(width: 350, height: 50)
                        .opacity(self.showForgotPasswordView ? 0:1)
                        .animation(.spring())
                }
                .onTapGesture {
                    self.pull_up = true
                }
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                
                Button(action: {
                    self.pull_up = false
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    self.showForgotPasswordView.toggle()
                }) {
                    Text(self.showForgotPasswordView ? "Login" : "Forget Password?")
                        .font(Font.custom("Roboto-Light", size: 17))
                        .foregroundColor(.black)
                }
                
                Button(action: {
                    self.showForgotPasswordView ? self.reset_password() : self.joinnow ? self.signup():self.login()
                }) {
                    ZStack {
                        
                        RoundedRectangle(cornerRadius: 20)
                            .foregroundColor(Color(#colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)))
                            .frame(width: 250, height: 50)
                        Text(self.showForgotPasswordView ? "Send Link": self.joinnow ? "Join Now":"Log in")
                            .foregroundColor(.white)
                            .font(Font.custom("Roboto-Regular", size: 25))
                    }
                    
                }
                .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                
                HStack {
                    Text(self.joinnow ? "Already a user?":"Not a member?")
                    Button(action: {
                        self.showForgotPasswordView = false
                        self.joinnow.toggle()
                        self.pull_up = false
                        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    }) {
                        Text (self.joinnow ? "Login":"Join now")
                            .font(Font.custom("Roboto-Bold", size: 18))
                            .foregroundColor(Color(#colorLiteral(red: 0.9568627477, green: 0.6588235497, blue: 0.5450980663, alpha: 1)))
                    }
                    
                }
                
                
            }
            .offset(y: screen.height - 950)
            
            if (self.showHome && self.signoutTapped == false){
                ContentView(userName: self.passedInUserName, signoutTapped: self.$signoutTapped)
                    .transition(.slide)
                    .animation(.spring())
            }
        }
        .onTapGesture {
            self.pull_up = false
             UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        .offset(y: pull_up ? screen.height - 1070: screen.height - 896)
        .animation(.spring())
        .edgesIgnoringSafeArea(.all)
        
        
    }
    
    func login() {
        auth.signIn(withEmail: username, password: password) { (result, error) in
            if error != nil {
                print("\(String(describing: error?.localizedDescription))")
                loginerrormessage = error!.localizedDescription
                self.loginError = true
                
            } else {
                print("Success login")
                self.pull_up = false
                self.signoutTapped = false
                self.showHome = true
                self.passedInUserName = self.username
                self.username.removeAll()
                self.password.removeAll()
                 UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
    
    func signup() {
        auth.createUser(withEmail: username, password: password) { (result, error) in
            if error != nil {
                self.joinnowErrorMessage = error!.localizedDescription
                self.joinnowError = true
                print(error?.localizedDescription ?? "")
            } else {
                print("Added new user")
                self.pull_up = false
                self.signoutTapped = false
                self.showHome = true
                self.passedInUserName = self.username
                self.username.removeAll()
                self.password.removeAll()
                 UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
    
    func reset_password(){
        auth.sendPasswordReset(withEmail: username) { (error) in
            if error != nil {
                print("\(error?.localizedDescription ?? "")")
                resetPassErrormessage = error!.localizedDescription
                self.resetPassError = true
            } else {
                self.username.removeAll()
                self.resetPass = true
                self.showForgotPasswordView = false
                self.pull_up = false
                print("Reset password link sent to: \(self.username)")
                 UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
            }
        }
    }
    
   
    
}

struct login_Previews: PreviewProvider {
    static var previews: some View {
        login()
    }
}
