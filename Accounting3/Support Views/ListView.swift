//
//  ListView.swift
//  Accounting3
//
//  Created by Bhargin Kanani on 5/7/20.
//  Copyright © 2020 pc1. All rights reserved.
//

import SwiftUI

struct ListView: View {
     var note: Note

    
    var splitDate: [String] {
        let exp = self.note.date.components(separatedBy: "/")
        return exp
    }
    
    var month: String {
        var abr = String()
        let month = self.splitDate[0]
        
        if month == "1" || month == "01" {
            abr = "Jan"
        }
        
        if month == "2" || month == "02" {
            abr = "Feb"
        }
        
        if month == "3" || month == "03" {
            abr = "Mar"
        }
        
        if month == "4" || month == "04" {
            abr = "Apr"
        }
        
        if month == "5" || month == "05" {
            abr = "May"
        }
        
        if month == "6" || month == "06" {
            abr = "Jun"
        }
        
        if month == "7" || month == "07" {
            abr = "Jul"
        }
        
        if month == "8" || month == "08" {
            abr = "Aug"
        }
        
        if month == "9" || month == "09" {
            abr = "Sep"
        }
        
        if month == "10" {
            abr = "Oct"
        }
        
        if month == "11" {
            abr = "Nov"
        }
        
        if month == "12" {
            abr = "Dec"
        }
        
        return abr
        
    }
    
    var body: some View {
        HStack {
            
          
            
            VStack {
                Text(self.month)
                Text(self.splitDate[1])
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 0)
                    .frame(width: 50, height: 50)
                    .foregroundColor(Color(#colorLiteral(red: 0.9423606995, green: 0.9423606995, blue: 0.9423606995, alpha: 1)))
                
                Text(self.splitDate[2])
                    .frame(width: 50, height: 50)
            }
        
            
            VStack(alignment: .leading, spacing: 5.0) {
                Text("\(note.name)")
                    .font(.system(size: 20, weight: .medium, design: .default))
                
                Text("\(note.additonalNote)")
                    .font(.system(size: 15, weight: .light, design: .default))
                    .frame(width: 190, alignment: .leading)
                
            }
            .frame(width: 190, alignment: .leading)
            
            
            
            VStack(alignment: .trailing) {
                
                if note.type == "Add" {
                    
                    if note.content.contains("- Cash -") {
                        Text("Cash")
                            .foregroundColor(.green)
                    }
                    
                    if note.content.contains("- Cheque -") {
                        Text("Cheque")
                            .foregroundColor(.green)
                    }
                    
                    Text("$\(String(format: "%.2f", self.note.value))")
                        .foregroundColor(.green)
                        .font(.system(size: 15))
                }
                
                if note.type == "Minus" {
                    if note.content.contains("- Cash -") {
                        Text("Cash")
                            .foregroundColor(.red)
                    }
                    
                    if note.content.contains("- Cheque -") {
                        Text("Cheque")
                            .foregroundColor(.red)
                    }
                    
                    
                    Text("$\(String(format: "%.2f", self.note.value))")
                        .foregroundColor(.red)
                        .font(.system(size: 15))
                }
                
                if note.type == "Pending" {
                    if note.content.contains("- Cash -") {
                        Text("Cash")
                            .foregroundColor(.yellow)
                    }
                    
                    if note.content.contains("- Cheque -") {
                        Text("Cheque")
                            .foregroundColor(.yellow)
                    }
                    
                    
                    Text("$\(String(format: "%.2f", self.note.value))")
                        .foregroundColor(.yellow)
                        .font(.system(size: 15))
                }
                
                
            }
            
            
            
        }
    }
}

struct ListView_Previews: PreviewProvider {
    static var previews: some View {
        ListView(note: Note(content: "Trial for List View", value: 500000.0, type: "Add", date: "5/6/18", name: "Chipotle", additionalNote: "Safi gave the payment cash."))
    }
}


