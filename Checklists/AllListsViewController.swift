//
//  AllListsTableViewController.swift
//  Checklists
//
//  Created by Nikoloz Chitashvili on 28.05.22.
//

import UIKit

class AllListsViewController: UITableViewController {

    let cellIdentifier: String = "ChecklistCell"
    let checklistSegueIdentifier: String = "ShowChecklist"
    var lists: [Checklist] = [Checklist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        var list = Checklist(listItemName: "Birthdays")
        lists.append(list)
        
        list = Checklist(listItemName: "Groceries")
        lists.append(list)
        
        list = Checklist(listItemName: "Cool Apps")
        lists.append(list)
        
        list = Checklist(listItemName: "To Do")
        lists.append(list)
    }

    // MARK: - tableView overridden methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel!.text = lists[indexPath.row].name
        cell.accessoryType = .detailDisclosureButton
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: checklistSegueIdentifier, sender: nil)
    }
}
