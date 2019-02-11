////
////  SplitCollectionViewLayout.swift
////  Recursive Split Screen
////
////  Created by Valeriy on 05/02/2019.
////  Copyright © 2019 Valeriy. All rights reserved.
////
//
//import Foundation
//
//import UIKit
//
//class SplitCollectionViewLayout: UICollectionViewLayout {
//    var layoutAttributesCache = [UICollectionViewLayoutAttributes]()
//    var splitScreenHierarchy: SplitScreenManager!
//    
//    // MARK: Overrides
//    
//    override func prepare() {
//        super.prepare()
//        
//        layoutAttributesCache.removeAll()
//        calculateLayoutAttributes()
//    }
//    
//    override var collectionViewContentSize: CGSize {
//        return UIApplication.shared.windows[0].bounds.size
//    }
//    
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        var visibleLayoutAttributes = [UICollectionViewLayoutAttributes]()
//        
//        for attributes in layoutAttributesCache {
//            if attributes.frame.intersects(rect) {
//                visibleLayoutAttributes.append(attributes)
//            }
//        }
//        
//        return visibleLayoutAttributes
//    }
//    
//    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        return layoutAttributesCache[indexPath.row]
//    }
//    
//    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        return collectionView?.bounds.size != newBounds.size
//    }
//    
//    // MARK:
//    
//    func calculateLayoutAttributes() {
//        layoutAttributesCache = splitScreenHierarchy.getLayoutAttributes()
//    }
//}
