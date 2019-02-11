//
//  IndexPathProvider.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 11/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import Foundation

class IndexPathProvider {
    private var index = 0
    private var section: Int
    
    func next() -> IndexPath {
        defer { index += 1 }
        return IndexPath(item: index, section: section)
    }
    
    init(section: Int) {
        self.section = section
    }
}
