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
        
        collectionView.register(PlainColorCollectionViewCell.self,
                                forCellWithReuseIdentifier: "PlainColorCollectionViewCell")
        collectionView.collectionViewLayout = SplitCollectionViewLayout()
    }
}

// Delegate and dataSource
extension CollectionViewController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let colors: [UIColor] = [.green, .cyan]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlainColorCollectionViewCell",
                                                      for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        
        return cell
    }
}

