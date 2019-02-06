//
//  File.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 05/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

struct EndNode: SplitScreenTreeNode {
    var color: UIColor!
    
    func getLayoutAttributes(withAllowedSpace allowedSpace: CGRect) -> [UICollectionViewLayoutAttributes] {
        // FIXME: pass correct inxedPath
        let attributes = UICollectionViewLayoutAttributes(forCellWith: IndexPathIterator.shared.next())
        attributes.frame = allowedSpace
        
        return [attributes]
    }
    
    func getContainerContainingSelf(andNewNode newNode: SplitScreenTreeNode,
                                    separatedBy separator: Separator) -> ContainerNode {
        return ContainerNode(separator: separator,
                             olderNode: self,
                             newerNode: newNode)
    }
}

struct ContainerNode: SplitScreenTreeNode {
    var separator: Separator
    // children
    var olderNode: SplitScreenTreeNode
    var newerNode: SplitScreenTreeNode

    mutating func getLayoutAttributes(withAllowedSpace allowedSpace: CGRect) -> [UICollectionViewLayoutAttributes] {
        let divided = allowedSpace.divided(by: separator)

        return [olderNode.getLayoutAttributes(withAllowedSpace: divided.remainder),
                newerNode.getLayoutAttributes(withAllowedSpace: divided.slice)]
            .flatMap { $0 }
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
