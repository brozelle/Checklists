//
//  IconPickerViewController.swift
//  Checklists
//
//  Created by Buck Rozelle on 5/16/20.
//  Copyright © 2020 buckrozelledotcomLLC. All rights reserved.
//

import UIKit

//delegate protocol is uses to communicate with other objects
protocol IconPickerViewControllerDelegate: class {
    func iconPicker(_ picker: IconPickerViewController,
                    didPick iconName: String)
}

class IconPickerViewController: UITableViewController {
    
    let icons = [ "No Icon", "Appointments", "Birthdays", "Chores",
                  "Drinks", "Folder", "Groceries", "Inbox", "Photos", "Trips" ]
    
    weak var delegate: IconPickerViewControllerDelegate?

    
    // MARK:- Table View Delegates
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return icons.count
    }

    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //get a table view cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "IconCell",
                                                     for: indexPath)
            let iconName = icons[indexPath.row]
        
            //give it a title
            cell.textLabel!.text = iconName
            //give it an image
            cell.imageView!.image = UIImage(named: iconName)
            return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let delegate = delegate {
            let iconName = icons[indexPath.row]
            delegate.iconPicker(self, didPick: iconName)
        }
    }
    
}
