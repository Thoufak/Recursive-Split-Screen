//
//  extensionNSLayoutConstraint.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 05/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    static func pinEdges(of firstView: UIView, toEdgesOf secondView: UIView) {
        firstView.translatesAutoresizingMaskIntoConstraints = false
        self.activate([
            firstView.leadingAnchor.constraint(equalTo: secondView.leadingAnchor),
            firstView.trailingAnchor.constraint(equalTo: secondView.trailingAnchor),
            firstView.topAnchor.constraint(equalTo: secondView.topAnchor),
            firstView.bottomAnchor.constraint(equalTo: secondView.bottomAnchor)
        ])
    }
    
    static func center(_ viewToBeCentered: UIView, in parentView: UIView) {
        viewToBeCentered.translatesAutoresizingMaskIntoConstraints = false
        self.activate([
            viewToBeCentered.centerXAnchor.constraint(equalTo: parentView.centerXAnchor),
            viewToBeCentered.centerYAnchor.constraint(equalTo: parentView.centerYAnchor)
        ])
    }
}
