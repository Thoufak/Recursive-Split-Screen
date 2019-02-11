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
    
    func startEditing(_ separator: Separator) {
        isEditing = true
        separatorBeingEdited = separator
    }
    
    func stopEditing() {
        isEditing = false
        separatorBeingEdited = nil
    }
    
//    func setSeparatorProportion(to newProportion: CGFloat) {
//        guard isEditing else { return }
//        separatorBeingEdited!.proportion = newProportion
//    }
}
