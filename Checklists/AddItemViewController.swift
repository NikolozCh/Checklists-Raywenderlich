//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Nikoloz Chitashvili on 24.05.22.
//

import UIKit

class AddItemViewController: UITableViewController, UITextFieldDelegate {

    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) -> Void {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButton() -> Void {
        print("Hey bro, you have typed: \(textField.text!)")
        
        navigationController?.popViewController(animated: true)
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
