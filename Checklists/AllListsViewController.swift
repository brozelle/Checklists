//
//  AllListsViewController.swift
//  Checklists
//
//  Created by Buck Rozelle on 5/13/20.
//  Copyright © 2020 buckrozelledotcomLLC. All rights reserved.
//

import UIKit

//make AllListsViewController the delegate for ListDetailViewController
class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {
    
    var dataModel: DataModel!
    
    //helps create a new table view cell.
    let cellIdentifier = "ChecklistCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //enable large titles.
        navigationController?.navigationBar.prefersLargeTitles = true
        
        
        //registers the cell identifier with the underlying table view.
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)

    }
    
    
    

    //MARK:- Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowChecklist" {
            
            let controller = segue.destination as! ChecklistViewController
            //passes the Checklist object from the tapped row to ChecklistViewController
            controller.checklist = sender as? Checklist
            
        } else if segue.identifier == "AddChecklist" {
            let controller = segue.destination as! ListDetailViewController
            controller.delegate = self
        }
        
    }
    
    //loads a view controller view the accessory button and pushes it to the navigation stack
    override func tableView(_ tableView: UITableView,
                            accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let controller = storyboard!.instantiateViewController (withIdentifier: "ListDetailViewController") as! ListDetailViewController
        controller.delegate = self
        
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
    // MARK:- List Detail View Controller Delegates
    
    func listDetailViewControllerDidCancel(
        _ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController( _ controller: ListDetailViewController,
                                   didFinishAdding checklist: Checklist) {
        
        let newRowIndex = dataModel.lists.count
        dataModel.lists.append(checklist)
        
        let indexPath = IndexPath(row: newRowIndex,
                                  section: 0)
        
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths,
                             with: .automatic)
        
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController( _ controller: ListDetailViewController,
                                   didFinishEditing checklist: Checklist) {
        
        if let index = dataModel.lists.index(of: checklist) {
            let indexPath = IndexPath(row: index,
                                      section: 0)
            
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel!.text = checklist.name
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view data source

    //Enables user to delete checklists.
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCell.EditingStyle,
                            forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        
        tableView.deleteRows(at: indexPaths,
                             with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }

    //Creates the prototype cell.
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //helps create the table view cell.
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier,
                                                 for: indexPath)
        //Fill in the cells for the rows.
        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        //cell.textLabel!.text = "List \(indexPath.row)"

        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            didSelectRowAt indexPath: IndexPath) {
        
        //sends the checklist object from the row the user tapped on
        let checklist = dataModel.lists[indexPath.row]
        
        //when a cell i selected, the Checklists scene is shown.
        performSegue(withIdentifier: "ShowChecklist",
                     sender: checklist)
    }
    
}
