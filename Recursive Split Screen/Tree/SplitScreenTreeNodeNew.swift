//
//  SplitScreenTreeNodeNew.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 08/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

class SplitScreenTreeNodeNew {
    weak var parent: SplitScreenTreeNodeNew?
    var primaryChild: SplitScreenTreeNodeNew?
    var secondaryChild: SplitScreenTreeNodeNew?
    
    var separator: Separator?
    var indexPathProvider: IndexPathProvider!
    var indexPath: IndexPath!
    
    var isRootNode: Bool { return parent == nil }
    var isContainerNode: Bool { return separator != nil }
    var isEndScreen: Bool { return !isContainerNode }
    
    func getLayoutAttributes(withAllowedSpace allowedSpace: CGRect) -> [UICollectionViewLayoutAttributes] {
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
        let divided = allowedSpace.divided(by: separator)
        
        let sepAttrs = UICollectionViewLayoutAttributes(forSupplementaryViewOfKind: "Separator",
                                                        with: indexPath)
        sepAttrs.frame = separator.getFrame(forSuperViewFrame: allowedSpace)
        
//        switch separator.orientation {
//            case .horizontal:
//                sepAttrs.frame = CGRect(x: allowedSpace.minX,
//                                        y: divided.slice.minY,
//                                        width: allowedSpace.width,
//                                        height: separator.thickness)
//
//            case .vertical:
//                sepAttrs.frame = CGRect(x: divided.slice.minX,
//                                        y: allowedSpace.minY,
//                                        width: separator.thickness,
//                                        height: allowedSpace.height)
//        }
        
        return sepAttrs
    }
    
    /// Splits the current EndScreenNode, and returns the secondaryChild (newely created endScreen)
    func split(bySeparator separator: Separator) -> SplitScreenTreeNodeNew {
        self.separator = separator
        
        primaryChild = SplitScreenTreeNodeNew()
        primaryChild!.parent = self
        primaryChild!.indexPathProvider = indexPathProvider
        primaryChild!.indexPath = indexPath
        
        self.indexPath = indexPathProvider.getNewIndexPath(forSection: 0)
        
        secondaryChild = SplitScreenTreeNodeNew()
        secondaryChild!.parent = self
        secondaryChild!.indexPathProvider = indexPathProvider
        secondaryChild!.indexPath = indexPathProvider.getNewIndexPath(forSection: 0)
        
        return secondaryChild!
    }
}
