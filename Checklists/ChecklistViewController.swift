//
//  ViewController.swift
//  Checklists
//
//  Created by Buck Rozelle on 5/12/20.
//  Copyright © 2020 buckrozelledotcomLLC. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController {
    
    //items is a variable of ChecklistItem(s)
    var items = [ChecklistItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        
        let item1 = ChecklistItem()
        item1.text = "Walk the dog"
        items.append(item1)
        let item2 = ChecklistItem()
        item2.text = "Brush my teeth"
        item2.checked = true
        items.append(item2)
        let item3 = ChecklistItem()
        item3.text = "Learn iOS development"
        item3.checked = true
        items.append(item3)
        let item4 = ChecklistItem()
        item4.text = "Soccer practice"
        items.append(item4)
        let item5 = ChecklistItem()
        item5.text = "Eat ice cream"
        items.append(item5)
    }
    
    //MARK:- Actions
    //Add a new item to ChecklistItem()
    @IBAction func addItem() {
        let newRowIndex = items.count
        
        /*create a new ChecklistItem
         give it some text.
         put it into items at the end.
        */
        let item = ChecklistItem()
        item.text = "I am a new row"
        items.append(item)
        
        //let tableView know about this new object. create the object.
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        //Put it into a temp array.
        let indexPaths = [indexPath]
        //insert the new row with the new item.
        tableView.insertRows(at: indexPaths, with: .automatic)
    }

    //sets text for cell label from items array.
    func congfigureText(for cell: UITableViewCell,
                        with item: ChecklistItem) {
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    //handles checkmark
    func configureCheckmark(for cell: UITableViewCell,
                            with item: ChecklistItem) {
        
        if item.checked {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
    }
    
    // MARK:- Table View Delegate
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        //Remove the item from the data model
        items.remove(at: indexPath.row)
        
        //delete the item from the table view.
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
            if let cell = tableView.cellForRow(at: indexPath) {
                
                let item = items[indexPath.row]
                
                item.toggleChecked()
                configureCheckmark(for: cell,
                                   with: item)
            }
        
        tableView.deselectRow(at: indexPath,
                              animated: true)
    }

    // MARK:- Table View Data Source
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        
        //returns number of items in items.
        return items.count
    }
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem",
                                                     for: indexPath)
            let item = items[indexPath.row]
        
            congfigureText(for: cell,
                           with: item)
            configureCheckmark(for: cell,
                               with: item)
            return cell
    }

}
