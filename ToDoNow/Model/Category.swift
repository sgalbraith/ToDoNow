//
//  Category.swift
//  ToDoNow
//
//  Created by Scott P Galbraith on 3/18/18.
//  Copyright © 2018 SIBOC Sports, LLC. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    @objc dynamic var name : String = ""
    @objc dynamic var bgColor : String = ""
    let items = List<Item>()
    
}
