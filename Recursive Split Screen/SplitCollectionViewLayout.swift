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
    var splitScreenHierarchy = SplitScreenHierarchy.makeSecondTest()
//    var splitScreenHierarchy: SplitScreenHierarchy
    
//    override init(initialScreenHierarchy: SplitScreenHierarchy = SplitScreenHierarchy.makeOneScreen()) {
//        super.init()
//        splitScreenHierarchy = initialScreenHierarchy
//    }
    
    // MARK: Overrides
    
    override func prepare() {
        super.prepare()
        
        print("prepare called")
        
        layoutAttributesCache.removeAll()
        calculateLayoutAttributes()
    }
    
    override var collectionViewContentSize: CGSize {
        return UIApplication.shared.windows[0].bounds.size
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        print("in rect: \(rect)")
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
        return true
//        return collectionView?.bounds.size != newBounds.size
    }
    
    override func invalidateLayout() {
        super.invalidateLayout()
        
        print("inv")
    }
    
    // MARK:
    
    func calculateLayoutAttributes() {
        var copy = splitScreenHierarchy
        
        layoutAttributesCache = copy.rootNode
            .getLayoutAttributes(withAllowedSpace: splitScreenHierarchy.initialSpace)
    }
}
