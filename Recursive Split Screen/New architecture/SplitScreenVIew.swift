//
//  SplitScreen.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 11/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

class SplitScreenVIew: UICollectionView {
    
    var splitScreenDelegate: SplitScreenDelegate? {
        didSet { dataManager.splitScreenDelegate = splitScreenDelegate }
    }
    
    var dataManager: SplitScreenDataManager!
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: SplitScreenCollectionViewLayout())
        
        // FIXME:
        
        register(EndScreenView.self,
                 forCellWithReuseIdentifier: "EndScreenView")
        register(SeparatorView.self,
                 forSupplementaryViewOfKind: "Separator",
                 withReuseIdentifier: "Separator")
        
        dataManager = SplitScreenDataManager(allowedSpace: UIApplication.shared.keyWindow!.bounds)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
