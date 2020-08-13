//
//  SwiftUIView.swift
//  Accounting3
//
//  Created by Bhargin Kanani on 4/29/20.
//  Copyright © 2020 pc1. All rights reserved.
//

import SwiftUI

struct Test: View {
    @State var array = [Note]()
   @State var input = String()
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter you note", text: self.$input)
                .padding(.leading)
                
                List {
                    ForEach(self.array.indices, id: \.self){ text in
                        Text(self.array[text].id.uuidString)
                    }
                }
            }
        .navigationBarTitle(Text("Notes"))
        .navigationBarItems(trailing:
                Button(action: {
                    let entry = Note(content: self.input, value: 10.0, type: "Add", date: "23/08/2020", name: "Jacky", additionalNote: "nil")
                    self.array.append(entry)
                    print(entry.id)
                }) {
                Image(systemName: "plus")
                .resizable()
            }
                .frame(width: 30, height: 30)
            )
                
         
            
        }
    }
}

struct Test_Previews: PreviewProvider {
    static var previews: some View {
        Test()
    }
}
