//
//  ChecklistItem.swift
//  Checklists
//
//  Created by Nikoloz Chitashvili on 23.05.22.
//

import Foundation

class ChecklistItem: Equatable {
    static func == (lhs: ChecklistItem, rhs: ChecklistItem) -> Bool {
        return lhs.text == rhs.text && lhs.checked == rhs.checked
    }
    
    var text: String!  = ""
    var checked: Bool! = false
}
