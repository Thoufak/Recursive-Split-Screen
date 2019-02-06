//
//  SplitCollectionViewLayout.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 05/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import Foundation

import UIKit

class SplitCollectionViewLayout: UICollectionViewLayout {
    var layoutAttributesCache = [UICollectionViewLayoutAttributes]()
    
    override func prepare() {
        super.prepare()
        
        layoutAttributesCache.removeAll()
//        calculateLayoutAttributes(for: SplitScreenHierarchy.makeTest())
        calculateTestAttrs()
    }
    
    override var collectionViewContentSize: CGSize {
        return UIApplication.shared.windows[0].bounds.size
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        print("rect: \(rect)")
        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for attributes in layoutAttributesCache {
            if attributes.frame.intersects(rect) {
                visibleLayoutAttributes.append(attributes)
            }
        }
        
        return visibleLayoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        print("indexPath: \(indexPath)")
        return layoutAttributesCache[indexPath.row]
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
    
    // MARK:
    
//    func calculateLayoutAttributes(for hierarchy: SplitScreenHierarchy) {
////        let currentNode = hierarchy.rootNode
//
//    }
    
    func calculateTestAttrs() {
        var attrs = [UICollectionViewLayoutAttributes]()
        for row in 0...1 {
            attrs.append(UICollectionViewLayoutAttributes.init(forCellWith: IndexPath(row: row, section: 0)))
        }
        
        attrs[0].frame = CGRect(x: 0,
                                y: 0,
                                width: collectionViewContentSize.width * 0.3,
                                height: collectionViewContentSize.height)
        attrs[1].frame = CGRect(x: collectionViewContentSize.width * 0.3,
                                y: 0,
                                width: collectionViewContentSize.width * 0.7,
                                height: collectionViewContentSize.height)
        layoutAttributesCache.append(contentsOf: attrs)
    }
}
