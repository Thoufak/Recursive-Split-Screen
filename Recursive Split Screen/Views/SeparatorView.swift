//
//  SeparatorView.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 07/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

class SeparatorView: UICollectionReusableView {
    
    var separator: Separator!
    var layoutUpdater: LayoutUpdater!
    var parentViewSize: CGSize
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPan)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didPan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
            case .began, .changed:
                let proportion = separator.getProportion(forTouchLocation: gesture.location(in: self),
                                                         withSuperViewSize: parentViewSize)
                print(proportion)
                separator.proportion = proportion
                layoutUpdater.reloadData()

            default:
                break
        }
    }
}
