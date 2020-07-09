//
//  ToDoCategory.swift
//  Todoey
//
//  Created by Shawn Chandwani on 7/7/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation
import RealmSwift

class ToDoCategory: Object {
    @objc dynamic var name: String = ""
    let toDoList = List<ToDoList>()
}
