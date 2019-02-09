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
    var editingSeparator: Separator?
    var startPoint: CGPoint?
    var sepView: UIView?
    var isEditing = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressWithTwoTouches))
        longPressGestureRecognizer.numberOfTouchesRequired = 2
        addGestureRecognizer(longPressGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        panGestureRecognizer.delegate = self
        addGestureRecognizer(panGestureRecognizer)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didPan(gestureRecognizer: UIPanGestureRecognizer) {
        var proportion: CGFloat = 0
        
//        switch editingSeparator!.orientation {
//            case .horizontal:
//                proportion = ((startPoint?.y ?? 0) + gestureRecognizer.translation(in: contentView).y) / contentView.bounds.height
//            case .vertical:
//                proportion = ((startPoint?.x ?? 0) + gestureRecognizer.translation(in: contentView).x) / contentView.bounds.width
//        }
        
        switch gestureRecognizer.state {
            case .began, .changed:
                proportion = editingSeparator!.getProportion(forTouchLocation: gestureRecognizer.location(in: contentView),
                                                             inSuperView: contentView)
                editingSeparator?.proportion = proportion
                sepView?.frame = editingSeparator!.getFrame(forSuperViewFrame: contentView.frame)
            
            case .ended:
                viewSplitter.splitView(atIndexPath: indexPath,
                                       withSeparator: editingSeparator!)
                finishEdtiting()
            
            case .cancelled, .failed:
                finishEdtiting()
            
            default:
                break
        }
    }
    
    func finishEdtiting() {
        isEditing = false
        editingSeparator = nil
        sepView?.removeFromSuperview()
        sepView = nil
    }
    
    @objc func didLongPressWithTwoTouches(gestureRecognizer: UILongPressGestureRecognizer) {
        switch gestureRecognizer.state {
            case .began:
                isEditing = true
                startPoint = gestureRecognizer.location(in: contentView)

                let orientation = SeparatorOrientation
                    .getOrientationByLocationsOfTouches(gestureRecognizer.location(ofTouch: 0, in: contentView),
                                                        gestureRecognizer.location(ofTouch: 1, in: contentView))
                
//                let proportion =
//                switch orientation {
//                    case .horizontal:
//                        proportion = startPoint!.y / contentView.bounds.height
//
//                        sepView = editingSeparator!.getView(forSuperviewFrame: contentView.frame)
//                    case .vertical:
//                        proportion = startPoint!.x / contentView.bounds.width
//                }
                
                editingSeparator = Separator(proportion: 0,
                                             orientation: orientation)
                editingSeparator?.proportion = editingSeparator!
                    .getProportion(forTouchLocation: gestureRecognizer.location(in: contentView),
                                   withSuperViewSize: contentView.bounds.size)
                
                sepView = UIView(frame: editingSeparator!.getFrame(forSuperViewFrame: contentView.frame))
                sepView!.backgroundColor = .black
                contentView.addSubview(sepView!)
            
            case .cancelled, .ended, .failed:
                // FIXME: LOngTapping without Panning produces unexpected behaviour
//                finishEdtiting()
                print()
            default:
                break
        }
    }
}

extension PlainColorCollectionViewCell: UIGestureRecognizerDelegate {
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer {
            return (gestureRecognizer.numberOfTouches == 2) && isEditing
        }
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
