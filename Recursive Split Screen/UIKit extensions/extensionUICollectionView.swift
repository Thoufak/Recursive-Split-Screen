//
//  File.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 11/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

extension UICollectionView {
    func indexPathForSupplementaryView(ofKind kind: String, at point: CGPoint) -> IndexPath? {
        let visiblePaths = indexPathsForVisibleSupplementaryElements(ofKind: kind)
        
        for path in visiblePaths {
            guard let attributes = layoutAttributesForSupplementaryElement(ofKind: kind, at: path) else { continue }
            if attributes.frame.contains(point) {
                return path
            }
        }
        
        return nil
    }
}
