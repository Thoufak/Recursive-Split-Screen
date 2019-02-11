//
//  UsageExample.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 11/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

class UserViewController: UIViewController {
    override func viewDidLoad() {
        let splitScreen = SplitScreenView()
        splitScreen.splitScreenDelegate = self
    }
}

extension UserViewController: SplitScreenDelegate {
    func willDisplayCell(_ cell: UICollectionViewCell, at indexPath: IndexPath) {
        let myColors: [UIColor] = [
            #colorLiteral(red: 0.6117647059, green: 0.8549019608, blue: 0.2509803922, alpha: 1),
            #colorLiteral(red: 0, green: 0.6117647059, blue: 0.6745098039, alpha: 1),
            #colorLiteral(red: 0.9960784314, green: 0.8039215686, blue: 0, alpha: 1),
            #colorLiteral(red: 1, green: 0.2745098039, blue: 0.1607843137, alpha: 1),
            #colorLiteral(red: 0.5843137255, green: 0.8980392157, blue: 0.7176470588, alpha: 1),
            #colorLiteral(red: 0.450756164, green: 0.2916669688, blue: 0.5148120241, alpha: 1),
            #colorLiteral(red: 0.9361913071, green: 0.5840523553, blue: 0, alpha: 1),
            #colorLiteral(red: 0.05882352941, green: 0.231372549, blue: 0.3647058824, alpha: 1),
        ]
        
        cell.backgroundColor = myColors[indexPath.item % myColors.count]
    }
    
    func willDisplaySeparatorView(_ separatorView: UICollectionReusableView) {
        separatorView.backgroundColor = .cyan
    }
}
