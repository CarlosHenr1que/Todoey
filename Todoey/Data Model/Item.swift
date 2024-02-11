//
//  Item.swift
//  Todoey
//
//  Created by Carlos Henrique Matos Borges on 22/01/24.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
}
