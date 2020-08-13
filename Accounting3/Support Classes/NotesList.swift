//
//  NotesList.swift
//  Accounting3
//
//  Created by Bhargin Kanani on 5/1/20.
//  Copyright © 2020 pc1. All rights reserved.
//

import SwiftUI

class NotesList: ObservableObject{
    @Published var items = [Note]()
}
