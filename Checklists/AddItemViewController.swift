//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Nikoloz Chitashvili on 24.05.22.
//

import UIKit

protocol AddItemViewControllerDelegate: AnyObject {
    func addItemViewControllerDidCancel(
    _ controller: AddItemViewController)

    func addItemViewController(
    _ controller: AddItemViewController,
    didFinishAdding item: ChecklistItem
    )
    
    func addItemViewController(
    _ controller: AddItemViewController,
    didFinishEditing item: ChecklistItem
    )
}


class AddItemViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    var itemToEdit: ChecklistItem?
    
    weak var delegate: AddItemViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) -> Void {
        delegate?.addItemViewControllerDidCancel(self)
    }
    
    @IBAction func doneButton() -> Void {
        print("Hey bro, you have typed: \(textField.text!)")
        let item: ChecklistItem = ChecklistItem()
        item.text = textField.text!
        
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.addItemViewController(self, didFinishEditing: item)
        }
        else {
            delegate?.addItemViewController(self, didFinishAdding: item)
        }
    }
    
    // MARK: - Table view delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    // MARK: - Text field delegated
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        let oldString = textField.text!
        let stringRange = Range(range, in: oldString)!
        let newString = oldString.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newString.isEmpty
        return true
    }
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}
