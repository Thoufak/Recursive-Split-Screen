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
            attributes.append(getSeparatorAttributes(withAllowedSpace: allowedSpace))
            attributes.append(contentsOf: secondaryChild.getLayoutAttributes(withAllowedSpace: divided.slice))
        } else {
            let endScreenAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
            endScreenAttributes.frame = allowedSpace
            attributes.append(endScreenAttributes)
        }
        
        return attributes
    }
    
    private func getSeparatorAttributes(withAllowedSpace allowedSpace: CGRect) -> UICollectionViewLayoutAttributes {
        // FIXME:
        guard let separator = separator else { fatalError() }
        
        let sepAttrs = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: "Separator",
                                                        with: indexPath)
        sepAttrs.frame = separator.getFrame(forSuperViewFrame: allowedSpace)
        
        return sepAttrs
    }
    
    /// Splits the current EndScreenNode, and returns the secondaryChild (newely created endScreen)
    func split(bySeparator separator: Separator) -> SplitScreenTreeNode {
        self.separator = separator
        
        primaryChild = SplitScreenTreeNode()
        primaryChild!.parent = self
        primaryChild!.indexPathProvider = indexPathProvider
        primaryChild!.indexPath = indexPath
        
        self.indexPath = indexPathProvider.getNewIndexPath(forSection: 0)
        
        secondaryChild = SplitScreenTreeNode()
        secondaryChild!.parent = self
        secondaryChild!.indexPathProvider = indexPathProvider
        secondaryChild!.indexPath = indexPathProvider.getNewIndexPath(forSection: 0)
        
        return secondaryChild!
    }
}
