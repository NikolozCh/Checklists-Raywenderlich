//
//  ListDetailViewController.swift
//  Checklists
//
//  Created by Nikoloz Chitashvili on 28.05.22.
//

import UIKit

protocol ListDetailViewControllerDelegate: AnyObject {
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController)
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishdAdding checklist: Checklist)
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet var textField: UITextField!
    @IBOutlet var doneBarButton: UIBarButtonItem!
    @IBOutlet var iconImage: UIImageView!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checklistToEdit: Checklist?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let checklistToEdit = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklistToEdit.name
            doneBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    // MARK: - navigation bar button IBActions
    @IBAction func cancelBarButton(_ sender: UIBarButtonItem) {
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    @IBAction func doneBarButtonAction() {
        if let checklistToEdit = checklistToEdit {
            checklistToEdit.name = textField.text!
            delegate?.listDetailViewController(self, didFinishEditing: checklistToEdit)
        }
        else {
            let checkList = Checklist(listItemName: textField.text!)
            delegate?.listDetailViewController(self, didFinishdAdding: checkList)
        }
    }
    
    // MARK: - table view overridden methods
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    // MARK: - text field delegate for enabling/disabling "Done" button
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentString: String = textField.text!
        let stringRange = Range(range, in: currentString)!
        let newText = currentString.replacingCharacters(in: stringRange, with: string)
        doneBarButton.isEnabled = !newText.isEmpty
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        doneBarButton.isEnabled = false
        return true
    }
}
