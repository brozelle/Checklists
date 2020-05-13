//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by Buck Rozelle on 5/12/20.
//  Copyright © 2020 buckrozelledotcomLLC. All rights reserved.
//

import UIKit

//MARK:- defines ItemDetailViewControllerDelegate protocol
protocol ItemDetailViewControllerDelegate: class {
    
    //user presses cancel.
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController)
    
    //user presses done after adding.
    func itemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishAdding item: ChecklistItem)
    
    //user presses done after editing.
    func itemDetailViewController(_ controller: ItemDetailViewController,
                               didFinishEditing item: ChecklistItem)
}



class ItemDetailViewController: UITableViewController, UITextFieldDelegate {
    
    //? because the itemToEdit can be nil
    var itemToEdit: ChecklistItem?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    //a property that the view controller uses to refer to the delegate.
    weak var delegate: ItemDetailViewControllerDelegate?
    
    //MARK:- Actions
    @IBAction func cancel() {
        //Sends the message back to the delegate.
        delegate?.itemDetailViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        print("Contents of the text field: \(textField.text!)")
        
        //checks if itemToEdit has an object
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditing: item)
    
        } else {
            // if not, then user is adding a new ChecklistItem object.
            let item = ChecklistItem()
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishAdding: item)
    }
}
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        textField.becomeFirstResponder()
        
        //Changes the title of the itemDetailViewController to Edit Item.
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            //for edit mode.
            doneBarButton.isEnabled = true
        }
      
    }
    
    //MARK:- Table View Delegate Methods
    //Keeps the cell from being selected when entering text.
    override func tableView(_ tableView: UITableView,
                            willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    //MARK:- Text Field Delegates
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        
        //figure out what the new text will be.
        let oldText = textField.text!
        let stringRange = Range(range, in:oldText)!
        let newText = oldText.replacingCharacters(in: stringRange,
                                                  with: string)
        
        //if it is empty, then enable or disable accordingly.
        if newText.isEmpty {
            doneBarButton.isEnabled = false
        } else {
            doneBarButton.isEnabled = true
        }
        return true
    }
    
    //Handles the clear button so that he done button is disabled.
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }

}
