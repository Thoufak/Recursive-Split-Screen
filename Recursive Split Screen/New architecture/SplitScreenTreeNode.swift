//
//  SplitScreenTreeNodeNew.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 08/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

class SplitScreenTreeNode {
    weak var parent: SplitScreenTreeNode?
    var primaryChild: SplitScreenTreeNode?
    var secondaryChild: SplitScreenTreeNode?
    
    var separator: Separator?
    
    var indexPathProvider: IndexPathProvider!
    var indexPath: IndexPath!
    
    var allowedSpaceForLastConfiguration: CGRect?
    
    var isRootNode: Bool { return parent == nil }
    var isContainerNode: Bool { return separator != nil }
    var isEndScreen: Bool { return !isContainerNode }
    
    func getLayoutAttributes(withAllowedSpace allowedSpace: CGRect) -> [UICollectionViewLayoutAttributes] {
        allowedSpaceForLastConfiguration = allowedSpace
        var attributes = [UICollectionViewLayoutAttributes]()
        
        if isContainerNode {
            // FIXME:
            guard let separator = separator,
                  let primaryChild = primaryChild,
                  let secondaryChild = secondaryChild
                  else { fatalError() }
            let divided = allowedSpace.divided(by: separator)
            
            attributes.append(contentsOf: primaryChild.getLayoutAttributes(withAllowedSpace: divided.remainder))
            attributes.append(separator.getLayoutAttributes(withAllowedSpace: allowedSpace, at: indexPath))
            attributes.append(contentsOf: secondaryChild.getLayoutAttributes(withAllowedSpace: divided.slice))
        } else {
            let endScreenAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            endScreenAttributes.frame = allowedSpace
            attributes.append(endScreenAttributes)
        }
        
        return attributes
    }
    
    /// Splits the current end-screen-node (making it a container-node),
    /// and returns the secondaryChild (newely created end-screen-node)
    func split(bySeparator separator: Separator) -> SplitScreenTreeNode {
        func getNewChild() -> SplitScreenTreeNode {
            let child = SplitScreenTreeNode()
            child.parent = self
            child.indexPathProvider = indexPathProvider
            
            return child
        }
        
        self.separator = separator
        
        primaryChild = getNewChild()
        secondaryChild = getNewChild()
        
        // Primary child (end-screen-node) is assigned the old end-node's indexPath.
        // Current node (container-node) is assigned the next indexPath (row + 1)
        // Secondary child (end-screen-node) is assigned the next indexPath (row + 1)
        primaryChild!.indexPath   = indexPath
        self.indexPath            = indexPathProvider.next()
        secondaryChild!.indexPath = indexPathProvider.next()
        
        return secondaryChild!
    }
}
