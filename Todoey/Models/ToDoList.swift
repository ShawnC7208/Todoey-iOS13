//
//  ToDoList.swift
//  Todoey
//
//  Created by Shawn Chandwani on 7/3/20.
//  Copyright © 2020 App Brewery. All rights reserved.
//

import Foundation

class ToDoList: Codable {
    var ToDoListItemName: String
    var Checked: Bool = false
    
    init(_ ToDoListItem: String, _ Checked: Bool) {
        self.ToDoListItemName = ToDoListItem
        self.Checked = Checked
    }
}
