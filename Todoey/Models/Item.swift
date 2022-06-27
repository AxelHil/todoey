//
//  Item.swift
//  Todoey
//
//  Created by Axel Hil on 25/06/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

class Item: Codable {
    
    var title: String
    var checked = false
    
    init(for title: String) {
        self.title = title
    }
    
}
