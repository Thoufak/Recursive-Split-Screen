//
//  IndexPathProvider.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 08/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

protocol IndexPathProvider {
    mutating func getNewIndexPath(forSection section: Int) -> IndexPath
}
