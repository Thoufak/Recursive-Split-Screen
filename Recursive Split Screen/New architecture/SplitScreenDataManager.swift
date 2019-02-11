//
//  SplitScreenDataManager.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 10/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

class SplitScreenDataManager: NSObject {
    var delegate: SplitScreenDelegate?
    
    private var rootNodes = [Int:SplitScreenTreeNode]()
    
    func addRootNode() {}
    
    func numberOfItems(inSection section: Int) -> Int {}
    
    func node(with indexPath: IndexPath) {}
    
    func layoutAttributes() {}
}

extension SplitScreenDataManager: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return rootNodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return numberOfItems(inSection: section)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EndScreenView",
                                                      for: indexPath) as! EndScreenView
//        cell.indexPath = indexPath
        delegate?.willDisplayCell(cell)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let separatorView = collectionView.dequeueReusableSupplementaryView(ofKind: "Separator",
                                                                            withReuseIdentifier: "Separator",
                                                                            for: indexPath)
        
        delegate?.willDisplaySeparatorView(separatorView)
        
        return separatorView
    }
}
