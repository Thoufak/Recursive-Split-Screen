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
    var editingSeparator: Separator?
    var sepView: UIView?
    var isEditing = false
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//
//        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressWithTwoTouches))
//        longPressGestureRecognizer.numberOfTouchesRequired = 2
//        addGestureRecognizer(longPressGestureRecognizer)
//        
//        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
//        panGestureRecognizer.delegate = self
//        addGestureRecognizer(panGestureRecognizer)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    @objc func didPan(gestureRecognizer: UIPanGestureRecognizer) {
//        guard isEditing else { return }
//        
//        switch gestureRecognizer.state {
//            case .began, .changed:
//                let proportion = editingSeparator!.getProportion(forTouchLocation: gestureRecognizer.location(in: contentView),
//                                                                 inSuperViewOfSize: contentView.bounds.size)
//                editingSeparator?.proportion = proportion
//                sepView?.frame = editingSeparator!.getFrame(forSuperViewFrame: contentView.frame)
//
//            default:
//                break
//        }
//    }
//    
//    func finishEdtiting() {
//        isEditing = false
//        editingSeparator = nil
//        sepView?.removeFromSuperview()
//        sepView = nil
//    }
//    
//    @objc func didLongPressWithTwoTouches(gestureRecognizer: UILongPressGestureRecognizer) {
//        switch gestureRecognizer.state {
//            case .began:
//                isEditing = true
//
//                let orientation = SeparatorOrientation
//                    .getOrientationByLocationsOfTouches(gestureRecognizer.location(ofTouch: 0, in: contentView),
//                                                        gestureRecognizer.location(ofTouch: 1, in: contentView))
//                
//                editingSeparator = Separator(proportion: 0,
//                                             orientation: orientation)
//                editingSeparator?.proportion = editingSeparator!
//                    .getProportion(forTouchLocation: gestureRecognizer.location(in: contentView),
//                                   inSuperViewOfSize: contentView.bounds.size)
//                
//                sepView = UIView(frame: editingSeparator!.getFrame(forSuperViewFrame: contentView.frame))
//                sepView!.backgroundColor = .black
//                contentView.addSubview(sepView!)
//            
//            case .cancelled, .ended, .failed:
//                viewSplitter.splitView(atIndexPath: indexPath,
//                                       withSeparator: editingSeparator!)
//                finishEdtiting()
//            
//            default:
//                break
//        }
//    }
//}
//
//extension PlainColorCollectionViewCell: UIGestureRecognizerDelegate {
//    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
//        if gestureRecognizer is UIPanGestureRecognizer {
//            return (gestureRecognizer.numberOfTouches == 2) && isEditing
//        }
//        
//        return true
//    }
//    
//    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
//        return true
//    }
}
