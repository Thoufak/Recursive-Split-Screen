//
//  File.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 05/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

struct EndNode: SplitScreenTreeNode {
    var allowedSpace: CGRect
    var color: UIColor
    func getLayoutAttributes() -> [UICollectionViewLayoutAttributes] {
        
    }
}

struct ContainerNode: SplitScreenTreeNode {
    var allowedSpace: CGRect
    var children: [SplitScreenTreeNode]
    let separator: Separator
    
    mutating func addChild(_ node: SplitScreenTreeNode) {
        children.append(node)
    }
    
    func getLayoutAttributes() -> [UICollectionViewLayoutAttributes] {
        return children.flatMap { $0.getLayoutAttributes() }
    }
}
