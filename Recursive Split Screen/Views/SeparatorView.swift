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
    
    // more like an init
    func configure() {
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPan)))
    }
    
    @objc func didPan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
            case .began, .changed:
                separator.proportion = separator.getProportion(forTouchLocation: gesture.translation(in: self),
                                                               inSuperViewOfSize: CGSize(width: 150, height: 150))
                layoutUpdater.updateLayout()

            default:
                break
        }
    }
}
