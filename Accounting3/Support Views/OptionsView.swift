//
//  OptionsView.swift
//  Accounting3
//
//  Created by Bhargin Kanani on 5/1/20.
//  Copyright © 2020 pc1. All rights reserved.
//

import SwiftUI

struct OptionsView: View {
    var content: String
    
    var body: some View {
        ZStack{
           
            RoundedRectangle(cornerRadius: 5)
                .foregroundColor(.white)
            
            Text("What Do you want to do with note:")
                .font(.headline)
                .fontWeight(.heavy)
                .multilineTextAlignment(.center)
                .offset(y: -50)
            
            Text(content)
                .offset(y: -10)
    
          
            
            
        }
        .frame(width: 350, height: 220)
        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
        .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
        
    }
}

struct OptionsView_Previews: PreviewProvider {
    static var previews: some View {
        OptionsView(content: "Gold for Cash")
    }
}
