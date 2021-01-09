//
//  SwiftUIView.swift
//  Keeper
//
//  Created by Bhargin Kanani on 9/2/20.
//  Copyright © 2020 Bhargin Kanani. All rights reserved.
//


        /*
         ZStack {
                   Color(#colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1))
                   
                   VStack(alignment: .center) {
                       Text("CURRENT BALANCE")
                           .font(Font.custom("Montserrat-Light", size: 15))
                           .foregroundColor(Color.white)
                       
                       Text("$ 32,465")
                           .font(Font.custom("OpenSans-Regular", size: 50))
                           .foregroundColor(Color.white)
                   }
                   .offset(y: screen.height - 1180)
                   
                   HStack (spacing: 140){
                       
                       HStack {
                           ZStack{
                               Circle()
                                   .frame(width: 25, height: 25)
                                   .foregroundColor(.white)
                               Image(systemName: "plus")
                                   .foregroundColor(.green)
                           }
                           .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                           .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                           
                           Text("INCOME")
                               .font(Font.custom("OpenSans-Regular", size: 20))
                               .foregroundColor(.white)
                           
                       }
                       
                       HStack {
                           
                           ZStack{
                               Circle()
                                   .frame(width: 25, height: 25)
                                   .foregroundColor(.white)
                               Image(systemName: "minus")
                                   .foregroundColor(.orange)
                           }
                           .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                           .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                           
                           Text("EXPENSE")
                               .font(Font.custom("OpenSans-Regular", size: 20))
                               .foregroundColor(.white)
                       }
                   }
                   .padding(.trailing, 10.0)
                   .offset(y: screen.height - 1080)
                   
                   HStack(spacing: 170) {
                       Text("$ 42,000")
                           .foregroundColor(.white)
                       
                       
                       Text("$ 12,421")
                           .foregroundColor(.white)
                   }
                   .font(Font.custom("OpenSans-Bold", size: 21))
                   .padding(.leading, 30.0)
                   .offset(y: screen.height - 1050)
                   
                   HStack(alignment: .bottom) {
                       
                       if (!self.morph) {
                       Button(action: {
                           self.blurTapped = true
                           self.cardUp = false
                       }) {
                           
                           ZStack{
                               Circle()
                                   .foregroundColor(.white)
                                   .frame(width: 45, height: 45)
                                   .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                                   .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                               
                               Image(systemName: "person.fill")
                                   .resizable()
                                   .frame(width: 20, height: 20)
                           }
                       }
                       .foregroundColor(.black)
                       .animation(.spring())
                       }
                       
                   
                      
                       Spacer()
                       
                       
                       Button(action: {
                           self.morph.toggle()
                           self.cardUp = false
                       }) {
                           
                           ZStack{
                               if (!self.morph) {
                                   RoundedRectangle(cornerRadius: self.morph ? 20 : 200)
                                       .foregroundColor(.white)
                                       .animation(.spring())
                                       .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 1)
                                       .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 10)
                                   
                                   
                                   Image(systemName: "magnifyingglass")
                                       .resizable()
                                       .frame(width: 20, height: 20)
                                       .opacity(self.morph ? 0 : 1)
                               }
                               
                               if (self.morph) {
                                   searchbar(text: $searchText, morph: self.$morph)
                                       .padding(.top, -30)
                                       .offset(y: 20)
                                   
                               }
                               
                           }
                           
                           
                       }
                       .foregroundColor(.black)
                       .frame(width: self.morph ? screen.width - 20: 45, height: self.morph ? 35: 45)
                       .offset(x: self.morph ? -3 : 0)
                       
                   }
                   .padding(.horizontal)
                   .offset(y: self.morph ? screen.height - 1280 : screen.height - 1260)
                   
                   
                   ScrollView(.vertical, showsIndicators: false){
                       VStack{
                           
                           listview(extend: self.$extend[0])
                               .onTapGesture {
                                   self.extend[0].toggle()
                           }
                           
                           listview(extend: self.$extend[1])
                               .onTapGesture {
                                   self.extend[1].toggle()
                           }
                           
                           listview(extend: self.$extend[2])
                               .onTapGesture {
                                   self.extend[2].toggle()
                           }
                           
                           listview(extend: self.$extend[3])
                               .onTapGesture {
                                   self.extend[3].toggle()
                           }
                           
                           listview(extend: self.$extend[4])
                               .onTapGesture {
                                   self.extend[4].toggle()
                           }
                           
                           listview(extend: self.$extend[5])
                               .onTapGesture {
                                   self.extend[5].toggle()
                           }
                           
                           listview(extend: self.$extend[6])
                               .onTapGesture {
                                   self.extend[6].toggle()
                           }
                           
                           listview(extend: self.$extend[7])
                               .onTapGesture {
                                   self.extend[7].toggle()
                           }
                           
                       }
                   }
                   .frame(width: screen.width, height: screen.height - 400)
                   .offset(y: screen.height - 770)
                   
                   
                   RoundedRectangle(cornerRadius: 20)
                       .foregroundColor(Color(#colorLiteral(red: 0.06666861188, green: 0.07661110688, blue: 0.07679647843, alpha: 1)))
                       .frame(width: screen.width, height: screen.height - 575)
                       .offset(y: self.cardUp ? 370 : 540)
                       .animation(.spring())
                   
                   RoundedRectangle(cornerRadius: 20)
                       .foregroundColor(.white)
                       .frame(width: screen.width - 470, height: screen.height - 890)
                       .offset(y: self.cardUp ? 225:390)
                       .animation(.spring())
                       .gesture(
                           DragGesture()
                               .onChanged({ gesture in
                                   self.dragOffset = gesture.translation
                               })
                               .onEnded({ _ in
                                   if self.dragOffset.height < 20 {
                                       self.morph = false
                                       self.cardUp = true
                                   } else {
                                       self.cardUp = false
                                   }
                               })
                   )
                   
               
                   
                   menuview(showAdd: self.$showAdd)
                       .offset(y: self.cardUp ? 320:600)
                       .frame(height: screen.height - 720)
                       .padding(.horizontal, 30.0)
                   
                   
                   
               }
                   
               .onTapGesture {
                   self.blurTapped = false
                   self.morph = false
                   self.cardUp = false
               }
               .frame(width: screen.width)
               .edgesIgnoringSafeArea(.all)
 */
    
/*

func getRecents() {
    
    var recentStamp = Timestamp()
    
    db.collection("Test").document("Recent").getDocument { (document, err) in
        if err == nil {
            if document != nil && document!.exists {
                let data = document!.data()
                recentStamp = data!["Time"] as! Timestamp
                print("Stamp = \(recentStamp.dateValue() - 14400)")
                
                
            }
            else {
                self.showErrorAlert = true
            }
        }
        else {
            self.showErrorAlert = true
        }
        
    }
    
    let today = Date()
    let modifiedDate = Calendar.current.date(byAdding: .minute, value: -30, to: today)!
    
    db.collection("Test").whereField("Time", isGreaterThan: modifiedDate).getDocuments { (docs, err) in
        
        if err == nil {
            for document in docs!.documents{
                
                print(document.documentID)
                
            }
        }
    }
}
*/
