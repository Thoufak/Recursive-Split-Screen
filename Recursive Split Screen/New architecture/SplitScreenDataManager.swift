//
//  SplitScreenDataManager.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 10/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

class SplitScreenDataManager: NSObject {
    var collectionView: UICollectionView
    var allowedSpace: CGRect
    private var rootNodes = [Int:SplitScreenTreeNode]()
    var splitScreenDelegate: SplitScreenDelegate?
    var separtorEditingManager = SepartorEditingManager()
    
    
    init(allowedSpace: CGRect, collectionView: UICollectionView) {
        self.allowedSpace = allowedSpace
        self.collectionView = collectionView
        super.init()
        
        addRootNode()
        addGestureRecognizers()
        
        rootNodes[0]?.split(bySeparator: Separator(proportion: 0.25,
                                                   orientation: .horizontal))
    }
    
    func addGestureRecognizers() {
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                                      action: #selector(didLongPress))
        collectionView.addGestureRecognizer(longPressGestureRecognizer)
        
        let longPressWithTwoTouchesGestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                                                    action: #selector(didLongPressWIthTwoTouches))
        longPressWithTwoTouchesGestureRecognizer.numberOfTouchesRequired = 2
        collectionView.addGestureRecognizer(longPressWithTwoTouchesGestureRecognizer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(didPan))
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
}

// MARK: LayoutAttributesManager

extension SplitScreenDataManager: LayoutAttributesManager {
    func layoutAttributes() -> [UICollectionViewLayoutAttributes] {
        return rootNodes.values.flatMap { $0.getLayoutAttributes(withAllowedSpace: allowedSpace) }
    }
}

// MARK: LayoutUpdater

extension SplitScreenDataManager: LayoutUpdater {
    func updateLayout() {
        collectionView.collectionViewLayout.invalidateLayout()
    }
}


// MARK: UICollectionViewDataSource & UICollectionViewDataSource

extension SplitScreenDataManager: UICollectionViewDataSource, UICollectionViewDelegate {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        print("sections: \(rootNodes.count)")
        return rootNodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        print("items: \(numberOfItems(inSection: section))")
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
    @objc func didLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        
        switch gestureRecognizer.state {
            case .began:
                if let containerIndexPath = collectionView
                    .indexPathForSupplementaryView(ofKind: "Separator",
                                                   at: location) {
                    guard let containerForEditing = node(with: containerIndexPath) else { return }
                    guard let separatorForEditing = containerForEditing.separator else { return }
                    separatorForEditing.proportion = 0.1
                    updateLayout()
                    
                }
            
            default:
                break
        }
    }
    
    @objc func didLongPressWIthTwoTouches(gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        
        switch gestureRecognizer.state {
            case .began:
                guard let EndViewIndexPath = collectionView.indexPathForItem(at: location) else { return }
                    let touch1location = gestureRecognizer.location(ofTouch: 0, in: collectionView)
                    let touch2location = gestureRecognizer.location(ofTouch: 1, in: collectionView)
                
                    // Guard: touches are within the same EndView
                    guard collectionView.indexPathForItem(at: touch1location) ==
                        collectionView.indexPathForItem(at: touch2location)
                        else { return }
            
            
            
            default:
                break
        }
    }
    
    @objc func didPan(gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
            case .began, .changed:
            print()
//                guard let containerViewIndexPath =
//                node(with: <#T##IndexPath#>)?.separator
//                separator.proportion = separator.getProportion(forTouchLocation: gesture.translation(in: self),
//                                                               inSuperViewOfSize: CGSize(width: 150, height: 150))
//                layoutUpdater.updateLayout()
            
            default:
                break
        }
    }
}

extension SplitScreenDataManager: UIGestureRecognizerDelegate {

}
