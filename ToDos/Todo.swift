//
//  Todo.swift
//  ToDos
//
//  Created by Ronnie Voss on 7/6/15.
//  Copyright (c) 2015 Ronnie Voss. All rights reserved.
//

import UIKit

class Todo: NSObject, NSCoding {
    
    let itemName: String
    //var completed: Bool
    
    init(itemName: String) {
        self.itemName = itemName
        //self.completed = completed
    }
    
    required init?(coder aDecoder: NSCoder) {
        itemName = aDecoder.decodeObject(forKey: "itemName") as! String
        //completed = aDecoder.decodeObject(forKey: "completed") as! Bool
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(itemName, forKey: "itemName")
        //aCoder.encode(completed, forKey: "completed")
    }
    
}
