//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Nikoloz Chitashvili on 24.05.22.
//

import UIKit

class AddItemViewController: UITableViewController {

    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.largeTitleDisplayMode = .never
    }
    
    @IBAction func cancelButton(_ sender: UIBarButtonItem) -> Void {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func doneButton(_ sender: UIBarButtonItem) -> Void {
        
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Table view delegates
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
}
