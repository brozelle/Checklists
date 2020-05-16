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
    
    //creates a new array to hold ChecklistItem object.
    var items = [ChecklistItem]()
    
    // takes on parameter and places it into a property called name.
    init(name: String) {
        self.name = name
        super.init()
    }
    
}
