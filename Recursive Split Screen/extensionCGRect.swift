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
        
        switch separator.edgeToOffsetFrom {
            case .maxXEdge, .minXEdge:
                length = self.size.width
            case .maxYEdge, .minYEdge:
                length = self.size.height
        }
        let distance = length * separator.proprotion
        
        return self.divided(atDistance: distance,
                            from: separator.edgeToOffsetFrom)
    }
}
