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
}