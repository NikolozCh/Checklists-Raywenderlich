//
//  Checklist.swift
//  Checklists
//
//  Created by Nikoloz Chitashvili on 28.05.22.
//

import UIKit

class Checklist: NSObject {
    var name: String
    
    init(listItemName name: String) {
        self.name = name
        super.init()
    }
}
