////
////  SplitScreenManager.swift
////  Recursive Split Screen
////
////  Created by Valeriy on 05/02/2019.
////  Copyright © 2019 Valeriy. All rights reserved.
////
//
//import UIKit
//
///// Tree hierarchy
//// If you don't inherit from NSOBject, the compiler gives an error:
//// "does not conform to protocol 'NSObjectProtocol'", and does
//// not allow making it the delegate and datasource of collectionView
//class SplitScreenManager: NSObject {
//    var collectionViewDif: UICollectionView!
//    let initialSpace: CGRect
//    var rootNode: SplitScreenTreeNode
//    var nextIndexPathRow = 0
//
//    init(initialSpace: CGRect, rootNode: SplitScreenTreeNode) {
//        self.initialSpace = initialSpace
//        self.rootNode = rootNode
//
//        super.init()
//
//        self.rootNode.indexPathProvider = self
//        self.rootNode.indexPath = getNewIndexPath(forSection: 0)
//    }
//
//    func getNumberOfAllElements() -> Int {
//        func getNumberOfChildren(of node: SplitScreenTreeNode) -> Int {
//            guard node.isContainerNode else { return 0 }
//
//            return 2 + getNumberOfChildren(of: node.primaryChild!) + getNumberOfChildren(of: node.secondaryChild!)
//        }
//
//        return 1 + getNumberOfChildren(of: rootNode)
//    }
//
//    func getLayoutAttributes() -> [UICollectionViewLayoutAttributes] {
//        var attrs = rootNode.getLayoutAttributes(withAllowedSpace: initialSpace)
//
//        return attrs
//    }
//
//    func getSplitScreenTreeNode(atIndexPath indexPath: IndexPath) -> SplitScreenTreeNode? {
//        var queue = [SplitScreenTreeNode]()
//        queue.append(rootNode)
//
//        while queue.count > 0 {
//            let currentNode = queue.first!
//            queue = Array(queue.dropFirst())
//
//            if currentNode.indexPath == indexPath {
//                return currentNode
//            }
//
//            if currentNode.isContainerNode {
//                queue.append(currentNode.primaryChild!)
//                queue.append(currentNode.secondaryChild!)
//            }
//        }
//
//        return nil
//    }
//
//    //MARK: Make methods
//
//    static func makeOneScreen() -> SplitScreenManager {
//        let root = SplitScreenTreeNode()
//        let newManager = SplitScreenManager(initialSpace: UIApplication.shared.windows[0].frame,
//                                            rootNode: root)
//        newManager.rootNode.indexPathProvider = newManager
//
//        return newManager
//    }
//
//    static func makeSecondTest() -> SplitScreenManager {
//        let root = SplitScreenTreeNode()
//        let newManager = SplitScreenManager(initialSpace: UIApplication.shared.windows[0].frame,
//                                            rootNode: root)
//        newManager.rootNode.indexPathProvider = newManager
//        root.split(bySeparator: Separator(proportion: 0.1, orientation: .horizontal))
//            .split(bySeparator: Separator(proportion: 0.1, orientation: .vertical))
//            .split(bySeparator: Separator(proportion: 0.5, orientation: .horizontal))
//            .split(bySeparator: Separator(proportion: 0.1, orientation: .vertical))
//            .split(bySeparator: Separator(proportion: 0.1, orientation: .horizontal))
//            .split(bySeparator: Separator(proportion: 0.1, orientation: .vertical))
//        root.separator?.proportion = 0.5
//
//        return newManager
//    }
//}
//
//extension SplitScreenManager: UICollectionViewDataSource, UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return getNumberOfAllElements()
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        assert(indexPath.row % 2 == 0)
//
//        let colors: [UIColor] = [
//            #colorLiteral(red: 0.6117647059, green: 0.8549019608, blue: 0.2509803922, alpha: 1),
//            #colorLiteral(red: 0, green: 0.6117647059, blue: 0.6745098039, alpha: 1),
//            #colorLiteral(red: 0.9960784314, green: 0.8039215686, blue: 0, alpha: 1),
//            #colorLiteral(red: 1, green: 0.2745098039, blue: 0.1607843137, alpha: 1),
//            #colorLiteral(red: 0.5843137255, green: 0.8980392157, blue: 0.7176470588, alpha: 1),
//            #colorLiteral(red: 0.450756164, green: 0.2916669688, blue: 0.5148120241, alpha: 1),
//            #colorLiteral(red: 0.9361913071, green: 0.5840523553, blue: 0, alpha: 1),
//            #colorLiteral(red: 0.05882352941, green: 0.231372549, blue: 0.3647058824, alpha: 1),
//        ]
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlainColorCollectionViewCell",
//                                                      for: indexPath)
//        cell.backgroundColor = colors[indexPath.row / 2 % colors.count]
////        cell.backgroundColor = UIColor(red: CGFloat.random(in: 0...1),
////                                       green: CGFloat.random(in: 0...1),
////                                       blue: CGFloat.random(in: 0...1),
////                                       alpha: 1)
//        (cell as! PlainColorCollectionViewCell).indexPath = indexPath
//        (cell as! PlainColorCollectionViewCell).viewSplitter = self
//
////        let label = UILabel()
////        label.text = "\(indexPath.row)"
////        label.textColor = .white
////        cell.contentView.addSubview(label)
////        NSLayoutConstraint.center(label, in: cell.contentView)
//
//        return cell
//    }
//
//    func collectionView(_ collectionView: UICollectionView,
//                        viewForSupplementaryElementOfKind kind: String,
//                        at indexPath: IndexPath) -> UICollectionReusableView {
//        let view = collectionView.dequeueReusableSupplementaryView(ofKind: "Separator",
//                                                                   withReuseIdentifier: "Separator",
//                                                                   for: indexPath)
//        view.backgroundColor = .black
//        // Separator views should always appear at the front
//        view.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude - 1)
//        (view as! SeparatorView).separator = getSplitScreenTreeNode(atIndexPath: indexPath)!.separator!
//        (view as! SeparatorView).layoutUpdater = self
//        (view as! SeparatorView).configure()
//
//        return view
//    }
//}
//
//extension SplitScreenManager: IndexPathProvider {
//    func getNewIndexPath(forSection section: Int) -> IndexPath {
//        defer { nextIndexPathRow += 1 }
//        return IndexPath(row: nextIndexPathRow, section: section)
//    }
//}
//
//protocol ViewSplitter {
//    func splitView(atIndexPath indexPath: IndexPath, withSeparator separator: Separator)
//}
//
//extension SplitScreenManager: ViewSplitter {
//    func splitView(atIndexPath indexPath: IndexPath, withSeparator separator: Separator) {
//        getSplitScreenTreeNode(atIndexPath: indexPath)!.split(bySeparator: separator)
//        collectionViewDif.reloadData()
//    }
//}
//
//protocol LayoutUpdater {
//    func updateLayout()
//}
//
//extension SplitScreenManager: LayoutUpdater {
//    func updateLayout() {
//        collectionViewDif.collectionViewLayout.invalidateLayout()
//    }
//}
