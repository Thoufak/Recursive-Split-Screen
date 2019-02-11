//
//  SplitScreenDataManager.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 10/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

class SplitScreenDataManager: NSObject {
    var splitScreenDelegate: SplitScreenDelegate?
    var allowedSpace: CGRect
    private var rootNodes = [Int:SplitScreenTreeNode]()
    
    init(allowedSpace: CGRect) {
        self.allowedSpace = allowedSpace
        super.init()
        
        addRootNode()
        addGestureRecognizers()
    }
    
    func addGestureRecognizers() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(didLongPressWithTwoTouches))
        longPressGestureRecognizer.numberOfTouchesRequired = 2
        collectionView.addGestureRecognizer(longPressGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(didPan))
        panGestureRecognizer.delegate = self
        collectionView.addGestureRecognizer(panGestureRecognizer)
    }
    
    func addRootNode() {
        let newTreeNode = SplitScreenTreeNode()
        let newSection = rootNodes.count
        newTreeNode.indexPathProvider = IndexPathProvider(section: newSection)
        newTreeNode.indexPath = newTreeNode.indexPathProvider.next()
        rootNodes.updateValue(newTreeNode, forKey: newSection)
    }
    
    func numberOfItems(inSection section: Int) -> Int? {
        func getNumberOfChildren(of node: SplitScreenTreeNode) -> Int {
            guard node.isContainerNode else { return 0 }
            
            return 2 + getNumberOfChildren(of: node.primaryChild!) + getNumberOfChildren(of: node.secondaryChild!)
        }
        
        guard let neededRootNode = rootNodes[section] else { return nil }
        
        return 1 + getNumberOfChildren(of: neededRootNode)
    }
    
    func node(with indexPath: IndexPath) -> SplitScreenTreeNode? {
        var queue = [SplitScreenTreeNode]()
        queue.append(rootNodes[indexPath.section]!)
        
        while queue.count > 0 {
            let currentNode = queue.first!
            queue = Array(queue.dropFirst())
            
            if currentNode.indexPath == indexPath {
                return currentNode
            }
            
            if currentNode.isContainerNode {
                queue.append(currentNode.primaryChild!)
                queue.append(currentNode.secondaryChild!)
            }
        }
        
        return nil
    }
    
    func layoutAttributes() -> [UICollectionViewLayoutAttributes] {
        return rootNodes.values.flatMap { $0.getLayoutAttributes(withAllowedSpace: allowedSpace) }
    }
}

extension SplitScreenDataManager: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return rootNodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return numberOfItems(inSection: section)!
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EndScreenView",
                                                      for: indexPath) as! EndScreenView
//        cell.indexPath = indexPath
        splitScreenDelegate?.willDisplayCell(cell, at: indexPath)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        let separatorView = collectionView.dequeueReusableSupplementaryView(ofKind: "Separator",
                                                                            withReuseIdentifier: "Separator",
                                                                            for: indexPath)
        
        splitScreenDelegate?.willDisplaySeparatorView(separatorView)
        
        return separatorView
    }
}

// MARK: Handling gestures

extension SplitScreenDataManager {
    @objc func didLongPressWithTwoTouches(gestureRecognizer: UILongPressGestureRecognizer) {
        
    }
    
    @objc func didPan(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
            case .began, .changed:
                node(with: <#T##IndexPath#>)
                separator.proportion = separator.getProportion(forTouchLocation: gesture.translation(in: self),
                                                               inSuperViewOfSize: CGSize(width: 150, height: 150))
                layoutUpdater.updateLayout()
            
            default:
                break
        }
    }
}

extension SplitScreenDataManager: UIGestureRecognizerDelegate {

}
