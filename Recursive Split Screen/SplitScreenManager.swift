//
//  SplitScreenManager.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 05/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

/// Tree hierarchy
// If you don't inherit from NSOBject, the compiler says:
// "does not conform to protocol 'NSObjectProtocol'", and does
// not allow making it the delegate and datasource of collectionView
class SplitScreenManager: NSObject {
    var collectionViewDif: UICollectionView!
    let initialSpace: CGRect
    var rootNode: SplitScreenTreeNodeNew
    var nextIndexPathRow = 0
    
    init(initialSpace: CGRect, rootNode: SplitScreenTreeNodeNew) {
        self.initialSpace = initialSpace
        self.rootNode = rootNode
        
        super.init()
        
        self.rootNode.indexPathProvider = self
    }
    
    func getNumberOfAllElements() -> Int {
        func getNumberOfChildren(of node: SplitScreenTreeNodeNew) -> Int {
            guard node.isContainerNode else { return 0 }
            
            return 2 + getNumberOfChildren(of: node.primaryChild!) + getNumberOfChildren(of: node.secondaryChild!)
        }
        
        return 1 + getNumberOfChildren(of: rootNode)
    }
    
    func getLayoutAttributes() -> [UICollectionViewLayoutAttributes] {
        var attrs = rootNode.getLayoutAttributes(withAllowedSpace: initialSpace)
        print(attrs.map { $0.indexPath })
        return attrs
    }
    
    func getSplitScreenTreeNode(atIndexPath indexPath: IndexPath) -> SplitScreenTreeNodeNew? {
        var queue = [SplitScreenTreeNodeNew]()
        queue.append(rootNode)
        
        while queue.count > 0 {
            let currentNode = queue.first!
            queue = Array(queue.dropFirst())
            
            if currentNode.cellIndexPath == indexPath {
                return currentNode
            }
            
            if currentNode.isContainerNode {
                queue.append(currentNode.primaryChild!)
                queue.append(currentNode.secondaryChild!)
            }
        }
        
        return nil
    }
    
    //MARK: Make methods

    static func makeSecondTest() -> SplitScreenManager {
        let root = SplitScreenTreeNodeNew()
        let newManager = SplitScreenManager(initialSpace: UIApplication.shared.windows[0].frame,
                                            rootNode: root)
        newManager.rootNode.indexPathProvider = newManager
        root.split(bySeparator: Separator(proportion: 0.1, orientation: .horizontal))
            .split(bySeparator: Separator(proportion: 0.1, orientation: .vertical))
            .split(bySeparator: Separator(proportion: 0.5, orientation: .horizontal))
            .split(bySeparator: Separator(proportion: 0.1, orientation: .vertical))
            .split(bySeparator: Separator(proportion: 0.1, orientation: .horizontal))
            .split(bySeparator: Separator(proportion: 0.1, orientation: .vertical))
        root.separator?.proportion = 0.5
        
        return newManager
    }
}

extension SplitScreenManager: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("allNum: \(getNumberOfAllElements())")
        return getNumberOfAllElements()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
//        let colors: [UIColor] = [
//            #colorLiteral(red: 0.2466010237, green: 0.7337603109, blue: 0.09794580111, alpha: 1),
//            #colorLiteral(red: 0.2063746569, green: 0.5824351285, blue: 0.8851179679, alpha: 1),
//            #colorLiteral(red: 0.8572533312, green: 0.2916841071, blue: 0.253220252, alpha: 1),
//            #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1),
//            #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1),
//            #colorLiteral(red: 0.443669592, green: 0.8423986483, blue: 0.8831705729, alpha: 1),
//        ]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlainColorCollectionViewCell",
                                                      for: indexPath)
//        cell.backgroundColor = colors[indexPath.row / 2]
        cell.backgroundColor = UIColor(red: CGFloat.random(in: 0...1),
                                       green: CGFloat.random(in: 0...1),
                                       blue: CGFloat.random(in: 0...1),
                                       alpha: 1)
        (cell as! PlainColorCollectionViewCell).indexPath = indexPath
        (cell as! PlainColorCollectionViewCell).viewSplitter = self
        
        let label = UILabel()
        label.text = "\(indexPath.row)"
        label.textColor = .white
        cell.contentView.addSubview(label)
        NSLayoutConstraint.center(label, in: cell.contentView)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 viewForSupplementaryElementOfKind kind: String,
                                 at indexPath: IndexPath) -> UICollectionReusableView {
        let view = collectionView.dequeueReusableSupplementaryView(ofKind: "Separator",
                                                                   withReuseIdentifier: "Separator",
                                                                   for: indexPath)
        view.backgroundColor = .white
        
        return view
    }
}

extension SplitScreenManager: IndexPathProvider {
    func getNewIndexPath(forSection section: Int) -> IndexPath {
        defer { nextIndexPathRow += 1 }
        return IndexPath(row: nextIndexPathRow, section: section)
    }
}

protocol ViewSplitter {
    func splitView(atIndexPath indexPath: IndexPath, withSeparator separator: Separator)
}

extension SplitScreenManager: ViewSplitter {
    func splitView(atIndexPath indexPath: IndexPath, withSeparator separator: Separator) {
        getSplitScreenTreeNode(atIndexPath: indexPath)!.split(bySeparator: separator)
        collectionViewDif.reloadData()
    }
}
