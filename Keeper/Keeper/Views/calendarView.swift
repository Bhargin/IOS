//
//  AddVIew.swift
//  Keeper
//
//  Created by Bhargin Kanani on 8/15/20.
//  Copyright © 2020 Bhargin Kanani. All rights reserved.
//

import SwiftUI

struct calendarView: View {
    @State var pickerDate = Date()
    @State var dragOffset = CGSize.zero
    @State var showPicker = false
    @State var cardUp = false
    @State var description: String = ""
    @State var amount: String = ""
    @State var selectorIndex = 0
    let choice = ["Cash", "Cheque"]
    
    var body: some View {
        ZStack {
            DatePicker("",selection: self.$pickerDate, displayedComponents: .date)
                .padding(.horizontal, 55)
                .offset(x: 0, y: screen.height - 1085)
                .animation(.spring())
            
            RoundedRectangle(cornerRadius: self.showPicker ? 10:0)
                .foregroundColor(Color(#colorLiteral(red: 0.4620226622, green: 0.8382837176, blue: 1, alpha: 1)))
                .frame(width: screen.width, height: 180)
                .offset(y: -365)
            
            /*
             
             Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
             Image(systemName: "arrow.left")
             .resizable()
             }
             .frame(width: 35, height: 30)
             .foregroundColor(.white)
             .offset(x: screen.width - (screen.width + 160), y: screen.height - (screen.height + 380))
             */
            
            
            /*
             .gesture(
             DragGesture()
             .onChanged({ gesture in
             self.dragOffset = gesture.translation
             })
             .onEnded({ _ in
             if self.dragOffset.width > -20 {
             self.showPicker = false
             } else {
             self.showPicker = true
             }
             })
             )
             */
            Button(action: {
                UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                self.showPicker.toggle()
            }) {
                HStack {
                    Text("25")
                        .fontWeight(.semibold)
                        .font(.system(size: 40))
                    
                    Spacer()
                    Text("January")
                        .fontWeight(.semibold)
                        .font(.system(size: 40))
                    Spacer()
                    Text("2020")
                        .fontWeight(.semibold)
                        .font(.system(size: 40))
                }
            }
                
            .foregroundColor(.white)
            .padding(.horizontal, 40)
            .offset(y: screen.height - 1200)
            .animation(.spring())
            
            ZStack {
                
                RoundedRectangle(cornerRadius: self.showPicker ? 10:0)
                    .foregroundColor(Color(#colorLiteral(red: 1, green: 0.7803921569, blue: 0.1725490196, alpha: 1)))
                    .frame(width: screen.width, height: 720)
                    .animation(.spring())
                
                HStack (spacing: 70) {
                    VStack(alignment: .leading, spacing: 5) {
                        HStack{
                            
                            Text("Client:")
                                .fontWeight(.bold)
                            
                        }
                        .foregroundColor(.white)
                        
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                VStack(spacing: 10){
                                    
                                    withYouView(name: "Bhargin")
                                        .frame(width: 80, height: 80)
                                    
                                    Text("Bhargin Kanani")
                                        .foregroundColor(.black)
                                        .font(Font.custom("OpenSans-Regular", size: 19))
                                    
                                }
                                
                            }
                        }
                        .foregroundColor(.white)
                        .frame(width: 160, height: 130)
                    }
                    
                    VStack(alignment: .leading) {
                        ZStack {
                            Rectangle()
                                .frame(height: 3)
                                .foregroundColor(.white)
                                .offset(x:-20, y: 12)
                            
                            Image(systemName: "dollarsign.square")
                                .resizable()
                                .frame(width:27, height: 27)
                                .foregroundColor(.white)
                                .offset(x: -83)
                            
                            TextField("Enter Amount", text: self.$amount)
                                .padding(.leading)
                                .foregroundColor(.white)
                        }
                        .frame(width: 150, height: 35)
                        .offset(x: -25)
                        
                        ZStack {
                            Rectangle()
                                .frame(height: 3)
                                .foregroundColor(.white)
                                .frame(width: 200)
                                .offset(x:-20, y: 12)
                            
                            Image(systemName: "square.and.pencil")
                                .resizable()
                                .frame(width:27, height: 27)
                                .foregroundColor(.white)
                                .offset(x: -107)
                            
                            TextField("Enter Note", text: self.$description)
                                .padding(.leading)
                                .foregroundColor(.white)
                        }
                        .frame(width: 150, height: 35)
                        
                        
                    }
                    .offset(y: -13)
                    
                }
                .padding(.horizontal, 25)
                .offset(y: -240)
                
                Picker("Numbers", selection: $selectorIndex) {
                    ForEach(0 ..< choice.count) { index in
                        Text(self.choice[index]).tag(index)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .frame(width: 200)
                .offset(x: 90, y: -180)
                
                if (self.amount.count > 0) {
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/) {
                        ZStack{
                            RoundedRectangle(cornerRadius: 10)
                            Text("Save")
                                .foregroundColor(.black)
                                .font(.system(size: 25))
                        }
                    }
                    .frame(width: screen.width - 70, height: 50)
                    .offset(y: -80)
                    .foregroundColor(.white)
                    .animation(.easeInOut)
                }
            }
            .offset(y: self.showPicker ? 245:80)
            .animation(.spring())
            
            /*
             .gesture(
             DragGesture()
             .onChanged({ gesture in
             self.dragOffset = gesture.translation
             })
             .onEnded({ _ in
             if self.dragOffset.width < 20 {
             self.showPicker = true
             } else {
             self.showPicker = false
             }
             })
             )
             */
            
            
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(#colorLiteral(red: 0.06666861188, green: 0.07661110688, blue: 0.07679647843, alpha: 1)))
                .frame(width: screen.width, height: screen.height - 575)
                .offset(y: self.cardUp ? 400 : 580)
                .animation(.spring())
            
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(.white)
                .frame(width: screen.width - 470, height: screen.height - 890)
                .offset(y: self.cardUp ? 255:430)
                .animation(.spring())
                .gesture(
                    DragGesture()
                        .onChanged({ gesture in
                            self.dragOffset = gesture.translation
                        })
                        .onEnded({ _ in
                            if self.dragOffset.height < 20 {
                                self.cardUp = true
                            } else {
                                self.cardUp = false
                            }
                        })
            )
            
            
            
            menuview(showAdd: .constant(false))
                .offset(y: self.cardUp ? 350:600)
                .frame(height: screen.height - 720)
                .padding(.horizontal, 40.0)
                .animation(.spring())
            
        }
        .edgesIgnoringSafeArea(.all)
        .onTapGesture {
            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        }
        
        
    }
    
}

struct calendarView_Previews: PreviewProvider {
    static var previews: some View {
        calendarView()
    }
}
