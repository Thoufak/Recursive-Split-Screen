//
//  SplitScreen.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 11/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

class SplitScreenView: UICollectionView {
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: SplitScreenCollectionViewLayout())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
