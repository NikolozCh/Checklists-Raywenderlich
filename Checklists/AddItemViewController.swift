//
//  AddItemViewController.swift
//  Checklists
//
//  Created by Nikoloz Chitashvili on 24.05.22.
//

import UIKit

class AddItemViewController: UITableViewController {

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
}
