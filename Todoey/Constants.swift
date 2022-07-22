//
//  Constants.swift
//  Todoey
//
//  Created by Andres Court on 16/7/22.
//  Copyright © 2022 App Brewery. All rights reserved.
//

import Foundation

struct K{
    static let cellIdentifier = "ToDoItemCell"
    static let userDefaultsKey = "TodoListArray"
    static let itemsPListFile = "Items.plist"
    
    struct todoeyAlert {
        static let title = "Add new Todoey Item"
        static let message = ""
        static let action = "Add Item"
        static let placeholder = "Create new item"
    }
    
    struct categoryView{
        static let cellIdentifier = "CategoryCell"
        
        static public let goToItems = "GoToItems"
    }
    
    struct categoryAlert{
        static let title = "Add new Category"
        static let message = ""
        static let action = "Add Category"
        static let placeholder = "Create new Category"
    }
}
