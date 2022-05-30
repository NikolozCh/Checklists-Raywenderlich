//
//  AllListsTableViewController.swift
//  Checklists
//
//  Created by Nikoloz Chitashvili on 28.05.22.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {

    let cellIdentifier: String = "ChecklistCell"
    let checklistSegueIdentifier: String = "ShowChecklist"
    let editChecklistSegueID: String = "EditChecklist"
    let addChecklistSegueID: String  = "AddChecklist"
    var lists: [Checklist] = [Checklist]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        loadChecklists()
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
        let checklist = lists[indexPath.row]
        performSegue(withIdentifier: checklistSegueIdentifier, sender: checklist)
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let checklist = lists[indexPath.row]
        performSegue(withIdentifier: editChecklistSegueID, sender: checklist)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            lists.remove(at: indexPath.row)
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
        let newItemIndex: Int = lists.count
        lists.append(checklist)
        let newItemIndexPath = IndexPath(row: newItemIndex, section: 0)
        tableView.insertRows(at: [newItemIndexPath], with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    func listDetailViewController(_ controller: ListDetailViewController, didFinishEditing checklist: Checklist) {
        if let itemIndex = lists.firstIndex(of: checklist) {
            if let cell = tableView.cellForRow(at: IndexPath(item: itemIndex, section: 0)) {
                cell.textLabel!.text = checklist.name
            }
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - File save & load methods
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }

    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }

    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        }
        catch {
            print("Error encoding lists array: \(error.localizedDescription)")
        }
    }

    func loadChecklists() {
        let filePath = dataFilePath()
        // Trying to get data from the file with Data class
        if let dataFromFile = try? Data(contentsOf: filePath) {
            // Creating plist decoder instance constant
            let decoder = PropertyListDecoder()
            do {
                // Decoding data got from file with ChecklistItem Codable protocol
                lists = try decoder.decode([Checklist].self, from: dataFromFile)
            }
            catch {
                print("Error decoding lists array: \(error.localizedDescription)")
            }
        }
    }
}
