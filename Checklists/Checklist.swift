//
//  Checklist.swift
//  Checklists
//
//  Created by Nikoloz Chitashvili on 28.05.22.
//

import UIKit

class Checklist: Equatable {
    static func == (lhs: Checklist, rhs: Checklist) -> Bool {
        return lhs.name == rhs.name
    }
    
    var name: String
    var items: [ChecklistItem]
    
    init(listItemName name: String) {
        self.name = name
        self.items = [ChecklistItem]()
    }
}
