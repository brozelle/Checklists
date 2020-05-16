//
//  ViewController.swift
//  Checklists
//
//  Created by Buck Rozelle on 5/12/20.
//  Copyright © 2020 buckrozelledotcomLLC. All rights reserved.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {

    //for the Checklist screen title.
    var checklist: Checklist!
    
    //items is a variable of ChecklistItem(s)
    //var items = [ChecklistItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //loadChecklistItems()
        title = checklist.name
        
        navigationItem.largeTitleDisplayMode = .never
        
    }
    
    //MARK:- Actions?
    
    //sets text for cell label from items array.
    func congfigureText(for cell: UITableViewCell,
                        with item: ChecklistItem) {
        
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    //handles checkmark
    func configureCheckmark(for cell: UITableViewCell,
                            with item: ChecklistItem) {
        let label = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            
            //obtains the ChecklistItem object user wants to edit.
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }

    //MARK:- Item Detail ViewController Delgates
    
    func itemDetailViewController(_ controller: ItemDetailViewController,
                                  didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index,
                                      section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                congfigureText(for: cell,
                               with: item)
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    //closes the Add Item screen.
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    //closes the Add Item screen.
    func itemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishAdding item: ChecklistItem) {
        
        let newRowIndex = checklist.items.count
        checklist.items.append(item)
        let indexPath = IndexPath(row: newRowIndex,
                                  section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths,
                             with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    
    // MARK:- Table View Delegate
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        //Remove the item from the data model
        checklist.items.remove(at: indexPath.row)
        
        //delete the item from the table view.
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths,
                             with: .automatic)
        
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
            if let cell = tableView.cellForRow(at: indexPath) {
                
                let item = checklist.items[indexPath.row]
                
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
        return checklist.items.count
    }
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem",
                                                     for: indexPath)
            let item = checklist.items[indexPath.row]
        
            congfigureText(for: cell,
                           with: item)
            
            configureCheckmark(for: cell,
                               with: item)
            return cell
    }

}
