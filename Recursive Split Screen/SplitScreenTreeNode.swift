//
//  File.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 05/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

protocol SplitScreenTreeNode {
    var allowedSpace: CGRect { get }
    func getLayoutAttributes() -> [UICollectionViewLayoutAttributes]
}
