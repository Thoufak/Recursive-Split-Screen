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
    var startX: CGFloat?
    var sepView: UIView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(didPan)))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didPan(gestureRecognizer: UIPanGestureRecognizer) {
        
        let proportion = ((startX ?? 0) + gestureRecognizer.translation(in: contentView).x) / contentView.bounds.width
        
        switch gestureRecognizer.state {
            case .began:
                startX = gestureRecognizer.location(in: contentView).x
                editingSeparator = Separator(proportion: proportion,
                                             orientation: .vertical)
                sepView = UIView(frame: CGRect(x: 0,
                                               y: 0,
                                               width: 8,
                                               height: contentView.bounds.height))
                sepView!.backgroundColor = .white
                contentView.addSubview(sepView!)
            case .changed:
                editingSeparator?.proportion = proportion
                sepView?.center = CGPoint(x: gestureRecognizer.location(in: contentView).x,
                                          y: contentView.bounds.height / 2)
            case .ended, .cancelled, .failed:
                viewSplitter.splitView(atIndexPath: indexPath,
                                       withSeparator: editingSeparator!)
                editingSeparator = nil
                sepView?.removeFromSuperview()
                sepView = nil
            default:
                break
        }
    }
}
