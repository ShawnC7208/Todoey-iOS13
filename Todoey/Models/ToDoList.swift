//
//  ToDoList.swift
//  Todoey
//
//  Created by Shawn Chandwani on 7/7/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoList: Object {
    @objc dynamic var toDoListItemName: String = ""
    @objc dynamic var checked: Bool = false
    @objc dynamic var dateCreated: Date?
    var parentCategory = LinkingObjects(fromType: ToDoCategory.self, property: "toDoList")
}
