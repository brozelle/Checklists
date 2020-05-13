//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Buck Rozelle on 5/12/20.
//  Copyright © 2020 buckrozelledotcomLLC. All rights reserved.
//

import UIKit

//MARK:- defines AddItemViewControllerDelegate protocol
protocol AddItemViewControllerDelegate: class {
    
    //user presses cancel.
    func addItemViewControllerDidCancel(_ controller: AddItemViewController)
    
    //user presses done.
    func addItemViewController(_ controller: AddItemViewController,
                               didFinishAdding item: ChecklistItem)
}

class AddItemViewController: UITableViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    //a property that the view controller uses to refer to the delegate.
    weak var delegate: AddItemViewControllerDelegate?
    
    //MARK:- Actions
    @IBAction func cancel() {
        //Sends the message back to the delegate.
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func done() {
        print("Contents of the text field: \(textField.text!)")
        // Sends the message back to the delegate with an new ChecklistItem object.
        let item = ChecklistItem()
        item.text = textField.text!
        delegate?.addItemViewController(self, didFinishAdding: item)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.largeTitleDisplayMode = .never
        textField.becomeFirstResponder()
      
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
