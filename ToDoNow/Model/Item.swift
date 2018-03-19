//
//  Item.swift
//  ToDoNow
//
//  Created by Scott P Galbraith on 3/18/18.
//  Copyright © 2018 SIBOC Sports, LLC. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title : String = ""
    @objc dynamic var done : Bool = false
    @objc dynamic var dateCreated : Date?
    var parentCategory = LinkingObjects(fromType: Category.self, property: "items")
    
}
