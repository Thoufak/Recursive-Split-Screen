//
//  ViewSplitter.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 11/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import Foundation

protocol ViewSplitter {
    func splitEndNode(atIndexPath indexPath: IndexPath, withSeparator separator: Separator)
}
