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
        return 5
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let colors: [UIColor] = [
            #colorLiteral(red: 0.2466010237, green: 0.7337603109, blue: 0.09794580111, alpha: 1),
            #colorLiteral(red: 0.2063746569, green: 0.5824351285, blue: 0.8851179679, alpha: 1),
            #colorLiteral(red: 0.8572533312, green: 0.2916841071, blue: 0.253220252, alpha: 1),
            #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1),
            #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1),
            #colorLiteral(red: 0.443669592, green: 0.8423986483, blue: 0.8831705729, alpha: 1)
        ]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlainColorCollectionViewCell",
                                                      for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        
        let label = UILabel()
        label.text = "\(indexPath.row)"
        label.textColor = .white
        cell.contentView.addSubview(label)
        NSLayoutConstraint.center(label, in: cell.contentView)
        
        return cell
    }
}

