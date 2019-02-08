//
//  File.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 05/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

struct EndNode: SplitScreenTreeNode {
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
    
    func getNumberOfChildrenScreens() -> Int {
        return 0
    }
}
