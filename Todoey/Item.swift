//
//  Item.swift
//  Todoey
//
//  Created by Axel Hil on 14/07/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    
    @Persisted var title: String?
    @Persisted var checked = false
    @Persisted var date: TimeInterval?
    @Persisted (originProperty: "items") var parentItem: LinkingObjects<CategoryItem>
}
