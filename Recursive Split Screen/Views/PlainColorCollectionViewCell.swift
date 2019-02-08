//
//  File.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 05/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

class PlainColorCollectionViewCell: UICollectionViewCell {
    var indexPath: IndexPath!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPan)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didPan(gestureRecognizer: UIPanGestureRecognizer) {
        print(gestureRecognizer.translation(in: self))
        print(indexPath.row)
    }
}
