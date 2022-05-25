//
//  ViewController.swift
//  Checklists
//
//  Created by Nikoloz Chitashvili on 22.05.22.
//

import UIKit

class ChecklistViewController: UITableViewController, AddItemViewControllerDelegate {
    var items = [ChecklistItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let item1 = ChecklistItem()
        item1.text = "Walk the dog"
        items.append(item1)

        let item2 = ChecklistItem()
        item2.text = "Brush my teeth"
        item2.checked = true
        items.append(item2)

        let item3 = ChecklistItem()
        item3.text = "Learn iOS development"
        item3.checked = true
        items.append(item3)

        let item4 = ChecklistItem()
        item4.text = "Soccer practice"
        items.append(item4)

        let item5 = ChecklistItem()
        item5.text = "Eat ice cream"
        items.append(item5)
        
        let item6 = ChecklistItem()
        item6.text = "iOS development is fun!"
        item6.checked = true
        items.append(item6)
        
        let item7 = ChecklistItem()
        item7.text = "Please, learn programming"
        item7.checked = true
        items.append(item7)
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
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        items.remove(at: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    // MARK: - Configuration methods
    func configureCheckmark(
        for cell: UITableViewCell,
        with item: ChecklistItem
    ) -> Void {
        if item.checked {
            cell.accessoryType = .checkmark
        }
        else {
            cell.accessoryType = .none
        }
    }
    func configureText(
        for cell: UITableViewCell,
        with item: ChecklistItem
    ) -> Void {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    // MARK: - Add Item View Controller's Delegate functions
    func addItemViewControllerDidCancel(_ controller: AddItemViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addItemViewController(_ controller: AddItemViewController, didFinishAdding item: ChecklistItem) {
        let newRowNumber: Int = items.count
        items.append(item)
        tableView.insertRows(at: [IndexPath(row: newRowNumber, section: 0)], with: .automatic)
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
      if segue.identifier == "AddItem" {
        let controller = segue.destination as! AddItemViewController
        controller.delegate = self
      }
    }
}
