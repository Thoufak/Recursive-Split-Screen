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
    var id = 0
    
    // more like an init
    func configure() {
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPan)))
        id = Int(arc4random())
        print("configured for \(id)")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        print("reused")
        id = 0
        
//        removeGestureRecognizer(gestureRecognizers![0])
    }
    
    @objc func didPan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
            case .began, .changed:
//                let proportion = separator.getProportion(forTouchLocation: gesture.location(in: self),
//                                                         inSuperView: )
                // test purposes:
                separator.proportion = separator.orientation == .vertical ?
                    abs(gesture.translation(in: self).x) / 150 :
                    abs(gesture.translation(in: self).y) / 150
                
                layoutUpdater.updateLayout()

            default:
                break
        }
    }
}
