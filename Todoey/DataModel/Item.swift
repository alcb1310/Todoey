//
//  ItemModel.swift
//  Todoey
//
//  Created by Andres Court on 18/7/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation


//class Item: Encodable, Decodable {
class Item: Codable {
    var title: String = ""
    var done: Bool  = false
}
