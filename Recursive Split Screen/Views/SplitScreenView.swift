//
//  SplitScreenView.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 11/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

class SplitScreenView: UICollectionView {
    
    var splitScreenDelegate: SplitScreenDelegate? {
        didSet { dataManager?.splitScreenDelegate = splitScreenDelegate }
    }
    
    private var dataManager: SplitScreenDataManager?
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        let layout = SplitScreenCollectionViewLayout()
        super.init(frame: frame, collectionViewLayout: layout)
        
        register(EndScreenView.self,
                 forCellWithReuseIdentifier: "EndScreenView")
        register(SeparatorView.self,
                 forSupplementaryViewOfKind: "Separator",
                 withReuseIdentifier: "Separator")
        
        // FIXME: Should be getting allowedSpace from collectionView's frame
        dataManager = SplitScreenDataManager(allowedSpace: UIApplication.shared.windows[0].bounds,
                                             collectionView: self)
        delegate = dataManager
        dataSource = dataManager
        layout.layoutAttributesManager = dataManager
        
        isScrollEnabled = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
