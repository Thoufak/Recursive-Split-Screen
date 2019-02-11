//
//  SplitScreenDelegate.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 11/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

protocol SplitScreenDelegate {
    func willDisplayCell(_ cell: UICollectionViewCell)
    func willDisplaySeparatorView(_ separatorView: UICollectionReusableView)
}
