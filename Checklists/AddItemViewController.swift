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
    
    func addItemViewControllerEditItem(
    _ controller: AddItemViewController,
    didFinishEditing item: ChecklistItem,
    itemIndex index: Int
    )
}


class AddItemViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    weak var delegate: AddItemViewControllerDelegate?
    var isEditingChecklists: Bool?
    var intEditing: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
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
        
        if isEditingChecklists! {
            delegate?.addItemViewControllerEditItem(self, didFinishEditing: item, itemIndex: intEditing!)
            return
        }
        delegate?.addItemViewController(self, didFinishAdding: item)
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
