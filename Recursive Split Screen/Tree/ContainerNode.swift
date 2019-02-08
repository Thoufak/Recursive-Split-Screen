//
//  File.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 08/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

struct ContainerNode: SplitScreenTreeNode {
    var separator: Separator
    var olderNode: SplitScreenTreeNode
    var newerNode: SplitScreenTreeNode
    
    mutating func getLayoutAttributes(withAllowedSpace allowedSpace: CGRect) -> [UICollectionViewLayoutAttributes] {
        let divided = allowedSpace.divided(by: separator)
        
        let attr1 = olderNode.getLayoutAttributes(withAllowedSpace: divided.remainder)
        
        let sepWidth: CGFloat = 8.0
        let sepAttrs = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: "Separator",
                                                        with: IndexPathIterator.shared.next())
        switch separator.orientation {
        case .horizontal:
            sepAttrs.frame = CGRect(x: allowedSpace.minX,
                                    y: divided.slice.minY,
                                    width: allowedSpace.width,
                                    height: sepWidth)
            
        case .vertical:
            sepAttrs.frame = CGRect(x: divided.slice.minX,
                                    y: allowedSpace.minY,
                                    width: sepWidth,
                                    height: allowedSpace.height)
        }
        sepAttrs.alpha = 0.3
        
        
        let attr2 = newerNode.getLayoutAttributes(withAllowedSpace: divided.slice)
        
        var fullAttrs = [attr1, attr2].flatMap { $0 }
        fullAttrs.append(sepAttrs)
        
        return fullAttrs
    }
    
    func getNumberOfChildrenScreens() -> Int {
        return 2 + olderNode.getNumberOfChildrenScreens() + newerNode.getNumberOfChildrenScreens()
    }
}

class IndexPathIterator {
    let values: [IndexPath] = (0...10).map { IndexPath(row: $0, section: 0) }
    var index = 0
    static let shared = IndexPathIterator()
    
    func next() -> IndexPath {
        defer { index += 1 }
        return values[index]
    }
    
    private init() {}
}