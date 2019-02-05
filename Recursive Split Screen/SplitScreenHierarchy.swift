//
//  SplitScreenHierarchy.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 05/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

/// Tree hierarchy

struct SplitScreenHierarchy {
    let size: CGSize
    var rootNode: SplitScreenTreeNode
}

protocol SplitScreenTreeNode {
    var children: [SplitScreenTreeNode] { get set }

    mutating func addChild(_ node: SplitScreenTreeNode)
}

extension SplitScreenTreeNode {
    mutating func addChild(_ node: SplitScreenTreeNode) {
        children.append(node)
    }
}
