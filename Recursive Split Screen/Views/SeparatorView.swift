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
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
////        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPan)))
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
//    @objc func didPan(gesture: UIPanGestureRecognizer) {
//        switch gesture.state {
//            case .changed:
//                let translation = gesture.translation(in: self).x
//                let proportion = translation / 320
//
//                separator.proportion = proportion
//                var coll = UIApplication.shared.windows[0].rootViewController as! CollectionViewController
//                print(coll.collectionView(coll.collectionView, numberOfItemsInSection: 0))
//                var lay = coll.collectionViewLayout as! SplitCollectionViewLayout
//                print(lay)
//                print(lay.layoutAttributesCache)
//                print(proportion)
//
//            default:
//                break
//        }
//    }
}
