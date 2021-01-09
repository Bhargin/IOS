//
//  withYouView.swift
//  Keeper
//
//  Created by Bhargin Kanani on 8/17/20.
//  Copyright © 2020 Bhargin Kanani. All rights reserved.
//

import SwiftUI

struct withYouView: View {
    
    var name: String
    
    var body: some View {
        ZStack{
            Circle()
            .foregroundColor(Color(#colorLiteral(red: 1, green: 0.768627451, blue: 0.1725490196, alpha: 1)))
            
            Text(name.prefix(1))
                .font(Font.custom("Roboto-Regular", size: 27))
                .foregroundColor(.white)
        }
        
    }
}

struct withYouView_Previews: PreviewProvider {
    static var previews: some View {
        withYouView(name: "Bhargin")
    }
}
