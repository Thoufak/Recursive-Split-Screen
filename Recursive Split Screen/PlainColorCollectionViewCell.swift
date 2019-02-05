//
//  File.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 05/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

class PlainColorCollectionViewCell: UICollectionViewCell {
    let availableColors: [UIColor] = [.green, .blue, .yellow, .cyan, .red]
    
    func setRandomColor() {
        backgroundColor = availableColors.randomElement()!
    }
}
