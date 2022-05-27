//
//  ViewController.swift
//  Checklists
//
//  Created by Nikoloz Chitashvili on 22.05.22.
//

import UIKit

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
    var items = [ChecklistItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadChecklistItems()
        
//        print("Documents folder is: \(documentsDirectory())")
//        print("Checklist.plist file is: \(dataFilePath())")
    }
    
    // MARK: - Table View Data Source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistItem", for: indexPath)
        
        let item = items[indexPath.row]
        
        configureText(for: cell, with: item)
        configureCheckmark(for: cell, with: item)
        
        return cell
    }
    // Deselects the row and removes/add checkmark to the cell depending it has it or not
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.checked.toggle()
            configureCheckmark(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        saveChecklistItems()
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
        saveChecklistItems()
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
        let newRowNumber: Int = items.count
        items.append(item)
        tableView.insertRows(at: [IndexPath(row: newRowNumber, section: 0)], with: .automatic)
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
    }
    
    func itemDetailViewController(_ controller: ItemDetailViewController, didFinishEditing item: ChecklistItem) {
        if let index = items.firstIndex(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        navigationController?.popViewController(animated: true)
        saveChecklistItems()
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
                controller.itemToEdit = items[indexPath.row]
            }
        }
    }
    
    // MARK: - File save & load methods
    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    
    func saveChecklistItems() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(items)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        }
        catch {
            print("Error encoding item array: \(error.localizedDescription)")
        }
    }
    
    func loadChecklistItems() {
        let filePath = dataFilePath()
        // Trying to get data from the file with Data class
        if let dataFromFile = try? Data(contentsOf: filePath) {
            // Creating plist decoder instance constant
            let decoder = PropertyListDecoder()
            do {
                // Decoding data got from file with ChecklistItem Codable protocol
                items = try decoder.decode([ChecklistItem].self, from: dataFromFile)
            }
            catch {
                print("Error decoding item array: \(error.localizedDescription)")
            }
        }
    }
}
