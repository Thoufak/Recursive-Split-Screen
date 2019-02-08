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
    let initialSpace: CGRect
    var rootNode: SplitScreenTreeNode
    
    func getNumberOfScreens() -> Int {
        return 1 + rootNode.getNumberOfChildrenScreens()
    }
    
    func getNumberOfAllElements() -> Int {
        return getNumberOfScreens() * 2 - 1
    }
    
    static func makeOneScreen() -> SplitScreenHierarchy {
        return SplitScreenHierarchy(initialSpace: UIApplication.shared.windows[0].frame,
                                    rootNode: EndNode())
    }
    
    static func makeTest() -> SplitScreenHierarchy {
        let newSeparator = Separator(proportion: 0.5, orientation: .vertical)
        let childContainer1 = ContainerNode(separator: Separator(proportion: 0.3,
                                                                orientation: .horizontal),
                                           olderNode: EndNode(),
                                           newerNode: EndNode()
                                            .getContainerContainingSelf(andNewNode: EndNode(),
                                                                        separatedBy: newSeparator))
        
        var childContainer2 = childContainer1
        childContainer2.separator.proportion = 0.2
        
        let rootContainerNode = ContainerNode(separator: Separator(proportion: 0.75,
                                                                   orientation: .vertical),
                                              olderNode: childContainer1,
                                              newerNode: childContainer2)
        
        return SplitScreenHierarchy(initialSpace: UIApplication.shared.windows[0].frame,
                                    rootNode: rootContainerNode)
    }
    
    static func makeSecondTest() -> SplitScreenHierarchy {
        let root = ContainerNode(separator: Separator(proportion: 0.5,
                                                      orientation: .vertical),
                                 olderNode: EndNode(),
                                 newerNode: EndNode()
                                    .getContainerContainingSelf(andNewNode: EndNode()
                                        .getContainerContainingSelf(andNewNode: EndNode()
                                            .getContainerContainingSelf(andNewNode: EndNode(),
                                                                        separatedBy: Separator(proportion: 0.3,
                                                                                               orientation: .vertical)),
                                                                    separatedBy: Separator(proportion: 0.5,
                                                                                           orientation: .horizontal)),
                                                                separatedBy: Separator(proportion: 0.9,
                                                                                       orientation: .horizontal))
                                 )

        return SplitScreenHierarchy(initialSpace: UIApplication.shared.windows[0].frame,
                                    rootNode: root)
    }
}
