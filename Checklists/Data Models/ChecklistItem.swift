//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Nikoloz Chitashvili on 23.05.22.
//

import Foundation
import UserNotifications

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
    
    deinit {
        removeNotification()
    }
    
    static func == (lhs: ChecklistItem, rhs: ChecklistItem) -> Bool {
        return lhs.text == rhs.text && lhs.checked == rhs.checked
    }
    
    // MARK: - Notification related stuff
    func scheduleNotification() {
        removeNotification()
        if shouldRemind && dueDate > Date() {
            let content = UNMutableNotificationContent()
            content.title = "Reminder:"
            content.body = text
            content.sound = .default
            
            let calendar = Calendar(identifier: .gregorian)
            let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: dueDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(identifier: "\(itemID)", content: content, trigger: trigger)
            
            let center = UNUserNotificationCenter.current()
            center.add(request)
        }
    }
    func removeNotification() {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["\(itemID)"])
    }
}
