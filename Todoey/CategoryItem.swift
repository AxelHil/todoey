//
//  Data.swift
//  Todoey
//
//  Created by Axel Hil on 13/07/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class CategoryItem: Object {
    
    @Persisted var title: String?
    
    @Persisted var colour: String
    
    @Persisted var items: List<Item>
        
}


