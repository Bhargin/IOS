//
//  menuview.swift
//  Keeper
//
//  Created by Bhargin Kanani on 8/15/20.
//  Copyright © 2020 Bhargin Kanani. All rights reserved.
//

import SwiftUI

struct menuview: View {
    @Binding var showAdd: Bool
    var body: some View {
        HStack{
            VStack(alignment: .leading, spacing: 25){
                Button(action: {
                    self.showAdd.toggle()
                }) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .cornerRadius(20)
                                .foregroundColor(Color(#colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)))
                            Image(systemName: "calendar")
                                .foregroundColor(.blue)
                        }
                        Text("Calendar")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                }
                
                Button(action: {}) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color(#colorLiteral(red: 0.9764705896, green: 0.885292062, blue: 0.7300393314, alpha: 1)))
                            Image(systemName: "person.3")
                                .foregroundColor(.orange)
                        }
                        Text("Contacts")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                }
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color(#colorLiteral(red: 0.7625320204, green: 0.8862745166, blue: 0.7454780122, alpha: 1)))
                            Image(systemName: "line.horizontal.3.decrease")
                                .foregroundColor(.green)
                        }
                        Text("Filter")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                }
            }
            Spacer()
            VStack(alignment: .leading, spacing: 25) {
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color(#colorLiteral(red: 1, green: 0.6871279548, blue: 0.6320098643, alpha: 1)))
                            Image(systemName: "person.badge.plus")
                                .foregroundColor(.red)
                        }
                        Text("Add Person")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                }
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(Color(#colorLiteral(red: 0.9229809895, green: 0.7150234549, blue: 1, alpha: 1)))
                            Image(systemName: "creditcard")
                                .foregroundColor(.purple)
                        }
                        Text("Billing")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                }
                
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                    HStack(spacing: 10) {
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                            Image(systemName: "square.and.arrow.up")
                                .foregroundColor(.white)
                        }
                        Text("Share")
                            .fontWeight(.semibold)
                            .foregroundColor(.white)
                    }
                }
            }
        }
    }
}

struct menuview_Previews: PreviewProvider {
    static var previews: some View {
        menuview(showAdd: .constant(false))
    }
}
