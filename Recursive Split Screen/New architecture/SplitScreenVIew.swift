//
//  SplitScreen.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 11/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

class SplitScreenVIew: UICollectionView {
    
    var splitScreenDelegate: SplitScreenDelegate
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: SplitScreenCollectionViewLayout())
        
        let dataManager = SplitScreenDataManager()
        dataManager.addRootNode()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
