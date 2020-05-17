//
//  Checklist.swift
//  Checklists
//
//  Created by Buck Rozelle on 5/13/20.
//  Copyright © 2020 buckrozelledotcomLLC. All rights reserved.
//

import UIKit

class Checklist: NSObject, Codable {

    var name = ""
    var iconName = "No Icon"
    
    //creates a new array to hold ChecklistItem object.
    var items = [ChecklistItem]()
    
    // takes on parameter and places it into a property called name.
    init(name: String, iconName: String = "No Icon") {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    //counting unchecked items
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
    
}
