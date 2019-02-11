//
//  SepartorEditingManager.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 11/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

class SepartorEditingManager {
    private(set) var isEditing = false
    var separatorBeingEdited: Separator?
    var parentBounds: CGRect?
    
    func startEditing(_ separator: Separator, parentBounds: CGRect) {
        isEditing = true
        separatorBeingEdited = separator
        self.parentBounds = parentBounds
    }
    
    func stopEditing() {
        isEditing = false
        separatorBeingEdited = nil
    }
}
