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
    
    static func getRandomOrientation() -> SeparatorOrientation {
        let options: [SeparatorOrientation] = [.horizontal, .vertical]
        
        return options.randomElement()!
    }
    
    static func getOrientationByLocationsOfTouches(_ touchLocation1: CGPoint,
                                                   _ touchLocation2: CGPoint) -> SeparatorOrientation {
        if abs(touchLocation2.x - touchLocation1.x) > abs(touchLocation2.y - touchLocation1.y) {
            return .vertical
        }
        
        return .horizontal
    }
}

class Separator {
    /// 0...1
    /// Indicates the primaryView's proportion (the secondaryView takes the rest of space)
    var proportion: CGFloat
    let orientation: SeparatorOrientation
    var thickness: CGFloat
    
    static let standardThickness: CGFloat = 16.0
    
    init(proportion: CGFloat,
         orientation: SeparatorOrientation,
         thickness: CGFloat = Separator.standardThickness) {
        self.proportion = proportion
        self.orientation = orientation
        self.thickness = thickness
    }
    
    func getFrame(forSuperViewFrame superViewFrame: CGRect) -> CGRect {
        let divided = superViewFrame.divided(by: self)
        
        switch orientation {
            case .horizontal:
                return CGRect(x: superViewFrame.minX,
                              y: divided.slice.minY - thickness / 2,
                              width: superViewFrame.size.width,
                              height: thickness)
            case .vertical:
                return CGRect(x: divided.slice.minX - thickness / 2,
                              y: superViewFrame.minY,
                              width: thickness,
                              height: superViewFrame.height)
        }
    }
    
    func getProportion(forTouchLocation touchLocation: CGPoint,
                       inSuperViewOfSize superViewSize: CGSize) -> CGFloat {
        return orientation == .vertical ?
            touchLocation.x / superViewSize.width :
            touchLocation.y / superViewSize.height
    }
    
    func getLayoutAttributes(withAllowedSpace allowedSpace: CGRect,
                             at indexPath: IndexPath) -> UICollectionViewLayoutAttributes {
        let sepAttrs = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: "Separator",
                                                        with: indexPath)
        sepAttrs.frame = getFrame(forSuperViewFrame: allowedSpace)
        
        return sepAttrs
    }
}
