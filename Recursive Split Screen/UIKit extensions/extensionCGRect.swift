//
//  extensionCGRect.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 05/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

extension CGRect {
    func divided(by separator: Separator) -> (slice: CGRect, remainder: CGRect) {
        var length: CGFloat!
        
        switch separator.orientation {
            case .horizontal:
                length = size.height
            case .vertical:
                length = size.width
        }
        let distance = length * separator.proportion
        
        return self.divided(atDistance: distance,
                            from: separator.edgeToOffsetFrom)
    }
}
