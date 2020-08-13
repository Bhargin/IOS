//
//  DateView.swift
//  Accounting3
//
//  Created by pc1 on 3/29/20.
//  Copyright © 2020 pc1. All rights reserved.
//
import SwiftUI

struct DateView: View {
    var name: String
    var amount: String
    var color: UIColor
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundColor(Color(#colorLiteral(red: 0.9826791883, green: 0.9699133039, blue: 0.9521804452, alpha: 0.9529644692)))
                .frame(width: 400, height: 30)
           RoundedRectangle(cornerRadius: 0)
                .foregroundColor(Color(color))
                .frame(width: -10, height: 30)
            .offset(x: -195)
           
            
            HStack {
                Text(name)
                Spacer()
                Text(amount)
                .foregroundColor(Color(color))
            }
            .padding(.horizontal)
           
        }
        .frame(width: 400, height: 40)
    }
}

struct DateView_Previews: PreviewProvider {
    static var previews: some View {
        DateView(name: "CashLand", amount: "$20", color:.red)
    }
}

