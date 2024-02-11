//
//  Category.swift
//  Todoey
//
//  Created by Carlos Henrique Matos Borges on 22/01/24.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name: String = ""
    @objc dynamic var color: String = ""
    let items = List<Item>()
}
