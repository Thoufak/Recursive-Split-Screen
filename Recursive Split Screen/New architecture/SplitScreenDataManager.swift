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
    
    func reloadData() {
        collectionView.reloadData()
    }
}

// MARK: ViewSplitter

extension SplitScreenDataManager {
    func splitEndNode(atIndexPath indexPath: IndexPath, withSeparator separator: Separator) {
        guard let neededNode = node(with: indexPath) else { return }
        guard neededNode.isEndScreen else { return }
        
        neededNode.split(bySeparator: separator)
        collectionView.reloadData()
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
                                                      for: indexPath)
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
    // Separator editing (start)
    @objc func didLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        
        switch gestureRecognizer.state {
            case .began:
                print("didLongPress began")
                guard let containerIndexPath = collectionView
                    .indexPathForSupplementaryView(ofKind: "Separator",
                                                   at: location)
                    else { print(1) ; return }
                guard let containerForEditing = node(with: containerIndexPath) else { print(2) ; return }
                guard let separatorForEditing = containerForEditing.separator else { print(3) ; return }
                print("4 (success)")
                separtorEditingManager.startEditing(separatorForEditing)
//                updateLayout()
            
            case .cancelled, .failed, .ended:
                print("didLongPress .cancelled, .failed, .ended")
                separtorEditingManager.stopEditing()
            
            default:
                break
        }
    }
    
    // Separator insertion
    @objc func didLongPressWIthTwoTouches(gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        
        switch gestureRecognizer.state {
            case .began:
                print("didLongPressWIthTwoTouches began")
                guard let endViewIndexPath = collectionView.indexPathForItem(at: location) else { return }
                    let touch1location = gestureRecognizer.location(ofTouch: 0, in: collectionView)
                    let touch2location = gestureRecognizer.location(ofTouch: 1, in: collectionView)
                
                // Guard: touches are within the same EndView
                guard collectionView.indexPathForItem(at: touch1location) ==
                    collectionView.indexPathForItem(at: touch2location)
                    else { return }
                
                print("didLongPressWIthTwoTouches are within the same EndView")
        
                let orientation = SeparatorOrientation.getOrientationByLocationsOfTouches(touch1location,
                                                                                          touch2location)
                let separator = Separator(proportion: 0, orientation: orientation)
                // FIXME:
                separator.proportion = separator.getProportion(forTouchLocation: location,
                                                               inSuperViewOfSize: collectionView.bounds.size)
                separtorEditingManager.startEditing(separator)
                splitEndNode(atIndexPath: endViewIndexPath, withSeparator: separator)
                reloadData()
            
            case .cancelled, .failed, .ended:
                print("didLongPressWithTwoTouches .cancelled, .failed, .ended")
                separtorEditingManager.stopEditing()
            
            default:
                break
        }
    }
    
    // Separator editing
    @objc func didPan(gestureRecognizer: UIPanGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        
        switch gestureRecognizer.state {
            case .began, .changed:
                print("didPan .began, .changed")
                guard separtorEditingManager.isEditing else { return }
                let newProportion = separtorEditingManager.separatorBeingEdited!
                    .getProportion(forTouchLocation: location,
                                   inSuperViewOfSize: collectionView.bounds.size)
                separtorEditingManager.separatorBeingEdited!.proportion = newProportion
                updateLayout()
            
            default:
                break
        }
    }
}

extension SplitScreenDataManager: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // FIXME:
        return true
    }
}
