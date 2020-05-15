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
    var items = [ChecklistItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadChecklistItems()
        title = checklist.name
        
        navigationItem.largeTitleDisplayMode = .never
        
        print("Documents folder is \(documentsDirectory())")
        print("Data file path is \(dataFilePath())")
    }
    
    //MARK:- Saving/Loading data to/from a file.
    func saveChecklistItems() {
        //Create an instance of PropertyListEncoder
        let encoder = PropertyListEncoder()
        
        //Sets up a block to catch errors.
        do {
            //try to encode the items array.
            let data = try encoder.encode(items)
            //if the constant was created then write the data to a file.
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        //execute if an error was thrown.
        } catch {
            //print the error.
            print("Error encoding item array: \(error.localizedDescription)")
        }
        
    }
    
    func loadChecklistItems() {
        //put the results dataFilePath in a temp constant.
        let path = dataFilePath()
        //try to load the contents of Checklists.plist into a new data object
        if let data = try? Data(contentsOf: path) {
            //load the entire array its contents
            let decoder = PropertyListDecoder()
            
            do {
                //load the saved data back into items
                items = try decoder.decode([ChecklistItem].self, from: data)
            } catch {
                //if there was an error, print it in the console.
                print("Error decoding item array:  \(error.localizedDescription)")
            }
        }
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
    
    //gets the full path to the documents folder (or does it?)
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory,
                                             in: .userDomainMask)
        return paths[0]
    }
    
    //Uses documentsDirectory to construct the full path to the Checklists.plist file.
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        
        } else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            
            //obtains the ChecklistItem object user wants to edit.
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }

    //MARK:- Item Detail ViewController Delgates
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                congfigureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }
    
    //closes the Add Item screen.
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    //closes the Add Item screen.
    func itemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishAdding item: ChecklistItem) {
        
        let newRowIndex = items.count
        items.append(item)
        let indexPath = IndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths, with: .automatic)
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
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
        saveChecklistItems()
        
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
        saveChecklistItems()
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
