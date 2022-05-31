//
//  AllListsTableViewController.swift
//  Checklists
//
//  Created by Nikoloz Chitashvili on 28.05.22.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate {

    let cellIdentifier: String = "ChecklistCell"
    let checklistSegueIdentifier: String = "ShowChecklist"
    let editChecklistSegueID: String = "EditChecklist"
    let addChecklistSegueID: String  = "AddChecklist"
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
    }

    // MARK: - tableView overridden methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        cell.textLabel!.text = dataModel.lists[indexPath.row].name
        cell.accessoryType = .detailDisclosureButton
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UserDefaults.standard.set(indexPath.row, forKey: "ChecklistIndex")
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: checklistSegueIdentifier, sender: checklist)
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: editChecklistSegueID, sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            dataModel.lists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    // MARK: - Segue prepare overridden method
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == checklistSegueIdentifier {
            let vController = segue.destination as! ChecklistViewController
            vController.checkList = sender as? Checklist
        }
        else if segue.identifier == addChecklistSegueID {
            let vController = segue.destination as! ListDetailViewController
            vController.delegate = self
        }
        else if segue.identifier == editChecklistSegueID {
            let vController = segue.destination as! ListDetailViewController
            vController.delegate = self
            vController.checklistToEdit = sender as? Checklist
        }
    }
    
    // MARK: - List detail protocol delegate methods
    func listDetailViewControllerDidCancel(_ controller: ListDetailViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishdAdding checklist: Checklist) {
        let newItemIndex: Int = dataModel.lists.count
        dataModel.lists.append(checklist)
        let newItemIndexPath = IndexPath(row: newItemIndex, section: 0)
        tableView.insertRows(at: [newItemIndexPath], with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        if let itemIndex = dataModel.lists.firstIndex(of: checklist) {
            if let cell = tableView.cellForRow(at: IndexPath(item: itemIndex, section: 0)) {
                cell.textLabel!.text = checklist.name
            }
        }
        navigationController?.popViewController(animated: true)
    }
    // MARK: - Navigation Controller delegate methods
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // If navigation controller shows the AllListsView this means user pressed the back button
        if viewController === self {
            UserDefaults.standard.set(-1, forKey: "ChecklistIndex")
        }
    }
}
