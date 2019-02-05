//
//  Separator.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 05/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

enum SeparatorOrientation {
    case horizontal
    case vertical
    
    func getEdgeToOffsetFrom() -> CGRectEdge {
        switch self {
            case .horizontal:
                return .maxXEdge
            case .vertical:
                return .maxYEdge
        }
    }
}

struct Separator {
    // 0...1
    let proprotion: CGFloat
    let orientation: SeparatorOrientation
    var edgeToOffsetFrom: CGRectEdge { return orientation.getEdgeToOffsetFrom() }
}
