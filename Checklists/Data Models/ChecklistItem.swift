//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Nikoloz Chitashvili on 23.05.22.
//

import Foundation

class ChecklistItem: Equatable, Codable {
    var text: String
    var checked: Bool
    var dueDate: Date
    var shouldRemind: Bool
    var itemID: Int

    init() {
        text = ""
        checked = false
        dueDate = Date()
        shouldRemind = false
        itemID = DataModel.nextChecklistItem()
    }
    
    static func == (lhs: ChecklistItem, rhs: ChecklistItem) -> Bool {
        return lhs.text == rhs.text && lhs.checked == rhs.checked
    }
    
    // MARK: - Notification related stuff
    func scheduleNotification() {
        if shouldRemind && dueDate > Date() {
            print("We are scheduling it!")
        }
    }
}
