//
//  CreateAlert.swift
//  Keeper
//
//  Created by Bhargin Kanani on 10/12/20.
//  Copyright © 2020 Bhargin Kanani. All rights reserved.
//

import SwiftUI

struct CreateAlert: View {
    @State var showAlert: Bool
    @State var message: String
    var body: some View {
        ZStack {
        Text("").alert(isPresented: self.$showAlert) {
            Alert(title: Text("Error!"), message: Text(self.message), dismissButton: .default(Text("Ok")))
        }
        }
           
    }
}

struct CreateAlert_Previews: PreviewProvider {
    static var previews: some View {
        CreateAlert(showAlert: true, message: "Testing error view")
    }
}

/*
db.collection("Test").whereField("Name", isEqualTo: name).getDocuments { (snapshot,err) in
    
    if err == nil {
        for document in snapshot!.documents{
            let docdata = document.data()
            
            if (docdata["Type"] as! String == "Plus"){
                self.plusAmount += docdata["amount"] as! Int
            }
            
            if (docdata["Type"] as! String == "Minus"){
                self.minusAmount += docdata["amount"] as! Int
            }
            
        }
    }
    
    else {
        self.showAlert = true
        self.message = "Error occured while retreiving \(name)'s data!"
    }
    
    
}
*/
