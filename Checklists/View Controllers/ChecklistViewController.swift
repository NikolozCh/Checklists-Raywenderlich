//
//  ViewController.swift
//  Checklists
//
//  Created by Nikoloz Chitashvili on 22.05.22.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var checkList: Checklist!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        loadChecklistItems()
        
        title = checkList.name
        
//        print("Documents folder is: \(documentsDirectory())")
//        print("Checklist.plist file is: \(dataFilePath())")
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checkList.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = checkList.items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    // Deselects the row and removes/add checkmark to the cell depending it has it or not
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checkList.items[indexPath.row]
            item.checked.toggle()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
//        saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        checkList.items.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
//        saveChecklistItems()
    }
    
//    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//        print("Accessory Tapped On: \(indexPath.row)")
//    }
    
    // MARK: - Configuration methods
    func configureCheckmark(
        for cell: UITableViewCell,
        with item: ChecklistItem
    ) -> Void {
        let checkmarkLabel = cell.viewWithTag(1001) as! UILabel
        
        if item.checked {
            checkmarkLabel.text = "✓"
        }
        else {
            checkmarkLabel.text = ""
        }
    }
    func configureText(
        for cell: UITableViewCell,
        with item: ChecklistItem
    ) -> Void {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    // MARK: - Item Detail View Controller's Delegate functions
    func itemDetailViewControllerDidCancel(_ controller: ItemDetailViewController) {
        navigationController?.popViewController(animated: true)
//        saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishAdding item: ChecklistItem) {
        let newRowNumber: Int = checkList.items.count
        checkList.items.append(item)
        tableView.insertRows(at: [IndexPath(row: newRowNumber, section: 0)], with: .automatic)
        navigationController?.popViewController(animated: true)
         // saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = checkList.items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        // saveChecklistItems()
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
        }
        else if segue.identifier == "EditItem" {
            let controller = segue.destination as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checkList.items[indexPath.row]
            }
        }
    }
}
