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
    let initialSpace: CGRect
    var rootNode: SplitScreenTreeNode
    
    init(initialSpace: CGRect, rootNode: SplitScreenTreeNode) {
        self.initialSpace = initialSpace
        self.rootNode = rootNode
    }
    
    func getNumberOfScreens() -> Int {
        return 1 + rootNode.getNumberOfChildrenScreens()
    }
    
    func getNumberOfAllElements() -> Int {
        return getNumberOfScreens() * 2 - 1
    }
    
    func getLayoutAttributes() -> [UICollectionViewLayoutAttributes] {
        return rootNode.getLayoutAttributes(withAllowedSpace: initialSpace)
    }
    
    static func makeOneScreen() -> SplitScreenManager {
        return SplitScreenManager(initialSpace: UIApplication.shared.windows[0].frame,
                                    rootNode: EndNode())
    }
    
    //MARK: Make methods
    
    static func makeTest() -> SplitScreenManager {
        let newSeparator = Separator(proportion: 0.5, orientation: .vertical)
        let childContainer1 = ContainerNode(separator: Separator(proportion: 0.3,
                                                                orientation: .horizontal),
                                           olderNode: EndNode(),
                                           newerNode: EndNode()
                                            .getContainerContainingSelf(andNewNode: EndNode(),
                                                                        separatedBy: newSeparator))
        
        var childContainer2 = childContainer1
        childContainer2.separator.proportion = 0.2
        
        let rootContainerNode = ContainerNode(separator: Separator(proportion: 0.75,
                                                                   orientation: .vertical),
                                              olderNode: childContainer1,
                                              newerNode: childContainer2)
        
        return SplitScreenManager(initialSpace: UIApplication.shared.windows[0].frame,
                                    rootNode: rootContainerNode)
    }
    
    static func makeSecondTest() -> SplitScreenManager {
        let root = ContainerNode(separator: Separator(proportion: 0.5,
                                                      orientation: .vertical),
                                 olderNode: EndNode(),
                                 newerNode: EndNode()
                                    .getContainerContainingSelf(andNewNode: EndNode()
                                        .getContainerContainingSelf(andNewNode: EndNode()
                                            .getContainerContainingSelf(andNewNode: EndNode(),
                                                                        separatedBy: Separator(proportion: 0.3,
                                                                                               orientation: .vertical)),
                                                                    separatedBy: Separator(proportion: 0.5,
                                                                                           orientation: .horizontal)),
                                                                separatedBy: Separator(proportion: 0.9,
                                                                                       orientation: .horizontal))
                                 )

        return SplitScreenManager(initialSpace: UIApplication.shared.windows[0].frame,
                                    rootNode: root)
    }
}

extension SplitScreenManager: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // FIXME:
        //        let num = (collectionView.collectionViewLayout as! SplitCollectionViewLayout).splitScreenHierarchy.getNumberOfAllElements()
        let num = SplitScreenManager.makeSecondTest().getNumberOfAllElements()
        return num
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        assert(indexPath.row % 2 == 0)
        
        let colors: [UIColor] = [
            #colorLiteral(red: 0.2466010237, green: 0.7337603109, blue: 0.09794580111, alpha: 1),
            #colorLiteral(red: 0.2063746569, green: 0.5824351285, blue: 0.8851179679, alpha: 1),
            #colorLiteral(red: 0.8572533312, green: 0.2916841071, blue: 0.253220252, alpha: 1),
            #colorLiteral(red: 0.9607843161, green: 0.7058823705, blue: 0.200000003, alpha: 1),
            #colorLiteral(red: 0.09019608051, green: 0, blue: 0.3019607961, alpha: 1),
            #colorLiteral(red: 0.443669592, green: 0.8423986483, blue: 0.8831705729, alpha: 1)
        ]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlainColorCollectionViewCell",
                                                      for: indexPath)
        cell.backgroundColor = colors[indexPath.row / 2]
        
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
