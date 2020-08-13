//
//  ListNamesView.swift
//  Accounting3
//
//  Created by Bhargin Kanani on 6/11/20.
//  Copyright © 2020 pc1. All rights reserved.
//

import SwiftUI

struct ListNamesView: View {
    var name: String
    let screen = UIScreen.main.bounds
    
    var body: some View {
        ZStack {
            Color.white
            HStack {
                Text(name)
                    .padding(.leading)
                
                   
                    .frame(width: 400, height: 30, alignment: .leading)
                    .font(.system(size: 20))
                Spacer()
                   
               
                
            }
            
        }
        .frame(width: screen.width - 30, height: 30)

    }
}

struct ListNamesView_Previews: PreviewProvider {
    static var previews: some View {
        ListNamesView(name: "Test")
    }
}


