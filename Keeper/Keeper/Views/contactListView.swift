//
//  listview.swift
//  Keeper
//
//  Created by Bhargin Kanani on 8/13/20.
//  Copyright © 2020 Bhargin Kanani. All rights reserved.
//

import SwiftUI

struct contactListView: View {
    let textcolors = [#colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1)]
    let info: String
    let mobile: String
    @Binding var extend:Bool
    
    
    var body: some View {
        ZStack {
            
            
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor( Color(#colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)))
                .frame(width: screen.width - 10, height: self.extend ? 120 : 70)
            
            
            
            VStack{
                HStack(alignment: .center, spacing: 10) {
                    withYouView(name: self.info)
                        .frame(width: 50, height: 45)
                  
                    VStack(alignment: .leading, spacing: 0) {
                        Text("\(self.info)")
                            .font(Font.custom("TTFirsNeue-DemiBold", size: 19))
                            .foregroundColor(.black)
                        Text("\(self.mobile)")
                            .font(Font.custom("TTFirsNeue-Light", size: 13))
                            .foregroundColor(.black)
                    }
                    Spacer()
                   
                }
                .padding(.horizontal, 5)
                .frame(width: screen.width - 10, height: 70)
                
                Spacer()
            }
            .frame(width: screen.width - 10, height: self.extend ? 120 : 70)
            
            HStack {
               
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Image(systemName: "pencil")
                        .resizable()
                }
                .foregroundColor(.black)
                .frame(width: 17, height: 17)
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    Image(systemName: "trash")
                        .resizable()
                }
                .foregroundColor(.black)
                .frame(width: 17, height: 20)
                
            }
            .offset(x: self.extend ? 160 : 500, y: 40)
            .animation(.spring())
            
            RoundedRectangle(cornerRadius: 5)
                .frame(width: screen.width - 20 , height: 2)
                .offset(y: self.extend ? 65 : 40)
                .foregroundColor(.white)
        }
        .frame(width: screen.width - 10, height: self.extend ? 120 : 70)
        .edgesIgnoringSafeArea(.all)
    }
}

struct contactListView_Previews: PreviewProvider {
    static var previews: some View {
        contactListView(info: "test", mobile: "+1 201-754-3975", extend: .constant(false))
    }
}
