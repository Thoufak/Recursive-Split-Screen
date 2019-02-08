//
//  ViewController.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 05/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

class CollectionViewController: UICollectionViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainSplitScreenHierarchy = SplitScreenManager.makeSecondTest()
        
        collectionView.collectionViewLayout = SplitCollectionViewLayout()
        (collectionView.collectionViewLayout as! SplitCollectionViewLayout).splitScreenHierarchy = mainSplitScreenHierarchy
        
        collectionView.register(PlainColorCollectionViewCell.self,
                                forCellWithReuseIdentifier: "PlainColorCollectionViewCell")
        collectionView.register(SeparatorView.self,
                                forSupplementaryViewOfKind: "Separator",
                                withReuseIdentifier: "Separator")
        
        collectionView.delegate = mainSplitScreenHierarchy
        collectionView.dataSource = mainSplitScreenHierarchy
    }
}

