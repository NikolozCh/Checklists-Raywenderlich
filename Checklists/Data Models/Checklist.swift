//
//  Checklist.swift
//  Checklists
//
//  Created by Nikoloz Chitashvili on 28.05.22.
//

import UIKit

class Checklist: Equatable, Codable {
    static func == (lhs: Checklist, rhs: Checklist) -> Bool {
        return lhs.name == rhs.name
    }
    
    var name: String
    var items: [ChecklistItem]
    var iconName: String!
    
    init(listItemName name: String) {
        self.name = name
        self.items = [ChecklistItem]()
        self.iconName = ""
    }
    
    func countUncheckedItems() -> Int {
        var count = 0
        for item in items where !item.checked {
            count += 1
        }
        return count
    }
}
