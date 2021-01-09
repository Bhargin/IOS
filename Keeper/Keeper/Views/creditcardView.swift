//
//  creditcardView.swift
//  Keeper
//
//  Created by Bhargin Kanani on 9/10/20.
//  Copyright © 2020 Bhargin Kanani. All rights reserved.
//

import SwiftUI
import FirebaseFirestore

struct creditcardView: View {
    let db = Firestore.firestore()
    @State var totalBal = 0.00
    var userNameInFromHome: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
            
            Image("cardtitle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 180, height: 100)
                .offset(x: -130, y: -60)
            
            HStack {
                VStack {
                    Image(systemName: "dollarsign.circle")
                        .foregroundColor(.white)
                    Spacer()
                    
                }
                .frame(height: 25)
                Text(String(format: "%.2f", self.totalBal))
                    .foregroundColor(.white)
                    .font(Font.custom("TTFirsNeue-DemiBold", size: 38))
                    .onTapGesture {
                        self.getbalance()
                    }
                    .onAppear{
                        self.getbalance()
                    }
                Spacer()
            }
            .frame(width: 350)
            .offset(y: 0)
           
            
            HStack {
                Text(userNameInFromHome)
                    .foregroundColor(.white)
                    .font(Font.custom("TTFirsNeue-Light", size: 23))
                Spacer()
                Image("logo2")
                .resizable()
                    .aspectRatio(contentMode: .fit)
                .frame(width: 120, height: 120)
                    .offset(x: 20)
                
                
            }
            .frame(width: 350, height: 50)
            .padding(.horizontal)
            .offset(y: 70)
        }
        .frame(width: 350, height: 210)
    }
    
    
    func getbalance() {
        db.collection(userNameInFromHome).document("Balance").getDocument { (DocumentSnapshot, err) in
            if err == nil {
                let data = DocumentSnapshot!.data()
                if data != nil {
                self.totalBal = data!["balance"] as! Double
                }
            }
        }
    }
}

struct creditcardView_Previews: PreviewProvider {
    static var previews: some View {
        creditcardView(userNameInFromHome: "bkanani@terpmail.umd.edu")
    }
}
