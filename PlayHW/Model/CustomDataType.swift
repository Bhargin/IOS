//
//  CustomDataType.swift
//  PlayHW
//
//  Created by Bhargin Kanani on 1/16/21.
//

import Foundation

struct CustomDataType: Codable {
    var Product_ID: Int
    var Product_Title: String
    var Product_Image_name: String
}

struct sectionData {
    var open: Bool
    var root_folder_name: String
    var data: [CustomDataType]
}
