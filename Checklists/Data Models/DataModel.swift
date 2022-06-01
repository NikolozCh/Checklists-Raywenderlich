//
//  DataModel.swift
//  Checklists
//
//  Created by Nikoloz Chitashvili on 30.05.22.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    init() {
        loadChecklists()
        registerDefaults()
        handleFirstTime()
        handleOldReminders()
    }
    
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
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

    func saveChecklists() {
        let encoder = PropertyListEncoder()
        do {
            let data = try encoder.encode(lists)
            try data.write(to: dataFilePath(), options: Data.WritingOptions.atomic)
        }
        catch {
//            print("Error encoding lists array: \(error.localizedDescription)")
            // do nothing
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
                sortChecklists()
            }
            catch {
                // print("Error decoding lists array: \(error.localizedDescription)")
                // do nothing
            }
        }
    }
    // MARK: - UserDefaults
    func registerDefaults() {
        let dict = [
            "ChecklistIndex": -1,
            "FirstTime": true
        ] as [String: Any]
        UserDefaults.standard.register(defaults: dict)
    }
    
    
    func handleFirstTime() {
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")
        
        if firstTime {
            let checklist = Checklist(listItemName: "List")
            lists.append(checklist)
            
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: "FirstTime")
        }
    }
    func handleOldReminders() {
        for list in lists {
            for item in list.items {
                if item.dueDate < Date() { item.shouldRemind = false }
            }
        }
    }
    // MARK: - General stuff [sorting]
    func sortChecklists() {
        lists.sort { list1, list2 in
            return list1.name.localizedStandardCompare(list2.name) == .orderedAscending
        }
    }
    
    // MARK: - Checklist item notification id helper
    class func nextChecklistItem() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        return itemID
    }
}
