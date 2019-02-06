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
                return .maxYEdge
            case .vertical:
                return .maxXEdge
        }
    }
}

struct Separator {
    // 0...1
    var proprotion: CGFloat
    let orientation: SeparatorOrientation
    var edgeToOffsetFrom: CGRectEdge { return orientation.getEdgeToOffsetFrom() }
}
