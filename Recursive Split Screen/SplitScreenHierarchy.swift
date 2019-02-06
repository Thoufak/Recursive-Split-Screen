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
    
    static func makeTest() -> SplitScreenHierarchy {
        let child1 = EndNode()
        let child2 = EndNode()
        
        let childContainer = ContainerNode(separator: Separator(proprotion: 0.3,
                                                                orientation: .horizontal),
                                           olderNode: child1,
                                           newerNode: child2)
        
        var rootContainerNode = ContainerNode(separator: Separator(proprotion: 0.25,
                                                                   orientation: .vertical),
                                              olderNode: child1,
                                              newerNode: childContainer)
        
        //
        let newEndNode = EndNode()
        let newSeparator = Separator(proprotion: 0.5, orientation: .vertical)
        rootContainerNode.olderNode = (rootContainerNode.olderNode as! EndNode)
            .getContainerContainingSelf(andNewNode: newEndNode, separatedBy: newSeparator)
        
        //
        return SplitScreenHierarchy(size: UIApplication.shared.windows[0].bounds.size,
                                    rootNode:  rootContainerNode)
    }
}
