//
//  SplitScreenDataManager.swift
//  Recursive Split Screen
//
//  Created by Valeriy on 10/02/2019.
//  Copyright © 2019 Valeriy. All rights reserved.
//

import UIKit

class SplitScreenDataManager: NSObject {
    private var collectionView: UICollectionView
    private var allowedSpace: CGRect
    private var rootNodes = [Int:SplitScreenTreeNode]()
    var splitScreenDelegate: SplitScreenDelegate?
    private var separtorEditingManager = SepartorEditingManager()
    
    
    init(allowedSpace: CGRect, collectionView: UICollectionView) {
        self.allowedSpace = allowedSpace
        self.collectionView = collectionView
        super.init()
        
        addRootNode()
        addGestureRecognizers()
    }
    
    private func addGestureRecognizers() {
        // Editing
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                                      action: #selector(didLongPress))
        collectionView.addGestureRecognizer(longPressGestureRecognizer)

        // Splitting
        let longPressWithTwoTouchesGestureRecognizer = UILongPressGestureRecognizer(target: self,
                                                                                    action: #selector(didLongPressWIthTwoTouches))
        longPressWithTwoTouchesGestureRecognizer.numberOfTouchesRequired = 2
        collectionView.addGestureRecognizer(longPressWithTwoTouchesGestureRecognizer)

        // TODO: multiscreen feature
        let trippleTapGestureRecognizer = UITapGestureRecognizer(target: self,
                                                                 action: #selector(didTrippleTap))
        trippleTapGestureRecognizer.numberOfTouchesRequired = 3
        collectionView.addGestureRecognizer(trippleTapGestureRecognizer)
        
        // Pan
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(didPan))
        panGestureRecognizer.delegate = self
        collectionView.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func addRootNode() {
        let newTreeNode = SplitScreenTreeNode()
        let newSection = rootNodes.count
        newTreeNode.indexPathProvider = IndexPathProvider(section: newSection)
        newTreeNode.indexPath = newTreeNode.indexPathProvider.next()
        rootNodes.updateValue(newTreeNode, forKey: newSection)
    }
    
    private func numberOfItems(inSection section: Int) -> Int? {
        func getNumberOfChildren(of node: SplitScreenTreeNode) -> Int {
            guard node.isContainerNode else { return 0 }
            
            return 2 + getNumberOfChildren(of: node.primaryChild!) + getNumberOfChildren(of: node.secondaryChild!)
        }
        
        guard let neededRootNode = rootNodes[section] else { return nil }
        
        return 1 + getNumberOfChildren(of: neededRootNode)
    }
    
    private func node(with indexPath: IndexPath) -> SplitScreenTreeNode? {
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
    
    private func frameOfContainerNode(with indexPath: IndexPath) -> CGRect? {
        func unionFramesOfChildren(ofContainerNodeAt indexPath: IndexPath) -> CGRect? {
            guard let neededNode = node(with: indexPath) else { return nil }
            guard neededNode.isContainerNode else { return nil }
            
            let primaryChildNodeIndexPath = neededNode.primaryChild!.indexPath!
            let secondaryChildNodeIndexPath = neededNode.secondaryChild!.indexPath!
            
            let primaryChildFrame = node(with: primaryChildNodeIndexPath)!.isEndScreen ?
                                    collectionView.layoutAttributesForItem(at: primaryChildNodeIndexPath)!.frame :
                                    unionFramesOfChildren(ofContainerNodeAt: primaryChildNodeIndexPath)
            
            let secondaryChildFrame = node(with: secondaryChildNodeIndexPath)!.isEndScreen ?
                                      collectionView.layoutAttributesForItem(at: secondaryChildNodeIndexPath)!.frame :
                                      unionFramesOfChildren(ofContainerNodeAt: secondaryChildNodeIndexPath)
            
            return primaryChildFrame!.union(secondaryChildFrame!)
        }

        return unionFramesOfChildren(ofContainerNodeAt: indexPath)
    }
    
    private func frameOfEndNode(with indexPath: IndexPath) -> CGRect? {
        guard let neededNode = node(with: indexPath) else { return nil }
        guard neededNode.isEndScreen else { return nil }
        
        return collectionView.layoutAttributesForItem(at: indexPath)!.frame
    }
}

// MARK: LayoutAttributesManager

extension SplitScreenDataManager: LayoutAttributesManager {
    var sectionBorderThickness: CGFloat { return 48 }
    
    func contentSize() -> CGSize {
        let sectionsTotalHeight = CGFloat(rootNodes.count) * allowedSpace.height
        let bordersTotalHeight = (CGFloat(rootNodes.count) - 1) * sectionBorderThickness
        
        return CGSize(width: allowedSpace.width, height:  sectionsTotalHeight + bordersTotalHeight)
    }
    
    func layoutAttributes() -> [UICollectionViewLayoutAttributes] {
        var attributes = [UICollectionViewLayoutAttributes]()

        for (sectionindex, rootNode) in rootNodes {
            let y = CGFloat(sectionindex) * (allowedSpace.height + sectionBorderThickness)
            let sectionAllowedSpace = allowedSpace.offsetBy(dx: 0, dy: y)
            attributes.append(contentsOf: rootNode.getLayoutAttributes(withAllowedSpace: sectionAllowedSpace).compactMap { $0 })
        }

        return attributes
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

extension SplitScreenDataManager: ViewSplitter {
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
        return rootNodes.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
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
    /// Separator editing (start)
    @objc func didLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        
        switch gestureRecognizer.state {
            case .began:
                guard let containerIndexPath = collectionView
                    .indexPathForSupplementaryView(ofKind: "Separator",
                                                   at: location)
                    else { return }
                guard let containerForEditing = node(with: containerIndexPath) else { return }
                guard let separatorForEditing = containerForEditing.separator else { return }
                separtorEditingManager.startEditing(separatorForEditing,
                                                    parentBounds: frameOfContainerNode(with: containerIndexPath)!)
            
            case .cancelled, .failed, .ended:
                separtorEditingManager.stopEditing()
            
            default:
                break
        }
    }
    
    /// Separator insertion
    @objc func didLongPressWIthTwoTouches(gestureRecognizer: UILongPressGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        
        switch gestureRecognizer.state {
            case .began:
                guard let endViewIndexPath = collectionView.indexPathForItem(at: location) else { return }
                // Guard: the node can split
                guard node(with: endViewIndexPath)?.canSplit ?? false else {
                    print("Maximum recursion level has been reached.")
                    return
                }
                
                let touch1location = gestureRecognizer.location(ofTouch: 0, in: collectionView)
                let touch2location = gestureRecognizer.location(ofTouch: 1, in: collectionView)
                
                // Guard: touches are within the same EndView
                guard collectionView.indexPathForItem(at: touch1location) ==
                    collectionView.indexPathForItem(at: touch2location)
                    else { return }
        
                let orientation = SeparatorOrientation.getOrientationByLocationsOfTouches(touch1location,
                                                                                          touch2location)
                let separator = Separator(proportion: 0, orientation: orientation)
                separtorEditingManager.startEditing(separator,
                                                    parentBounds: frameOfEndNode(with: endViewIndexPath)!)
                splitEndNode(atIndexPath: endViewIndexPath, withSeparator: separator)
                
                separator.proportion = separator.getProportion(forTouchLocation: location ,
                                                               inSuperViewWithFrame: separtorEditingManager.parentBounds!)
                reloadData()
            
            case .cancelled, .failed, .ended:
                separtorEditingManager.stopEditing()
            
            default:
                break
        }
    }
    
    /// Separator editing
    @objc func didPan(gestureRecognizer: UIPanGestureRecognizer) {
        let location = gestureRecognizer.location(in: collectionView)
        
        switch gestureRecognizer.state {
            case .began, .changed:
                guard separtorEditingManager.isEditing else { return }
                let newProportion = separtorEditingManager.separatorBeingEdited!
                    .getProportion(forTouchLocation: location,
                                   inSuperViewWithFrame: separtorEditingManager.parentBounds!)
                separtorEditingManager.separatorBeingEdited!.proportion = newProportion
                updateLayout()
            
            default:
                break
        }
    }

    @objc func didTrippleTap() {
        addRootNode()
        UIView.performWithoutAnimation {
            collectionView.insertSections(IndexSet(arrayLiteral: rootNodes.count - 1))
        }
    }
}

extension SplitScreenDataManager: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer,
                           shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        print("gestureRecognizer: \(gestureRecognizer)")
        print("otherGestureRecognizer: \(otherGestureRecognizer)")
        return true
    }
}
