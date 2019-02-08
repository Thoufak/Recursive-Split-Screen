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
    var viewSplitter: ViewSplitter!
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTap(gestureRecognizer: UITapGestureRecognizer) {
        print("Split \(indexPath.row)")
        viewSplitter.splitView(atIndexPath: indexPath,
                               withSeparator: Separator(proportion: 0.5,
                                                        orientation: .vertical))
    }
}
