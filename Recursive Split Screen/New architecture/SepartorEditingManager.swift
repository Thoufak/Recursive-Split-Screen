//
//  SepartorEditingManager.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 11/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import Foundation

class SepartorEditingManager {
    private(set) var isEditing = false
    private var separatorBeingEdited: Separator?
    
    func startEditing(_ separator: Separator) {
        isEditing = true
        separatorBeingEdited = separator
    }
    
    func stopEditing() {
        isEditing = false
        separatorBeingEdited = nil
    }
}
