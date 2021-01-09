//
//  searchbar.swift
//  Keeper
//
//  Created by Bhargin Kanani on 8/15/20.
//  Copyright © 2020 Bhargin Kanani. All rights reserved.
//

import SwiftUI

struct searchbar: View {
    @Binding var text: String
    @Binding var morph: Bool
    @State private var isEditing = false
 
    var body: some View {
        HStack {
 
            TextField("Search ...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)
                 
                        if isEditing {
                            
                            if text.count > 0 {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isEditing = true
                }
 
            if isEditing {
                Button(action: {
                    self.isEditing = false
                    self.text = ""
                    
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    self.morph = false
 
                }) {
                    Text("Cancel")
                }
                .foregroundColor(.blue)
                .padding(.trailing, 13)
                .transition(.move(edge: .trailing))
                .animation(.default)
            }
        }
        .frame(height: 40)
    }
  
}

struct searchbar_Previews: PreviewProvider {
    static var previews: some View {
        searchbar(text: .constant(""), morph: .constant(false))
    }
}
