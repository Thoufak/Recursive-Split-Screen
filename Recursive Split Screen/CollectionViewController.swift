////
////  ViewController.swift
////  Recursive Split Screen
////
////  Created by Valeriy on 05/02/2019.
////  Copyright © 2019 Valeriy. All rights reserved.
////
//
//import UIKit
//
//class CollectionViewController: UICollectionViewController {
//
//    var tempCollectionView: UICollectionView!
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        let mainSplitScreenHierarchy = SplitScreenManager.makeOneScreen()
//        mainSplitScreenHierarchy.collectionViewDif = collectionView
//
//        collectionView.collectionViewLayout = SplitCollectionViewLayout()
//        (collectionView.collectionViewLayout as! SplitCollectionViewLayout).splitScreenHierarchy = mainSplitScreenHierarchy
//
//        collectionView.register(PlainColorCollectionViewCell.self,
//                                forCellWithReuseIdentifier: "PlainColorCollectionViewCell")
//        collectionView.register(SeparatorView.self,
//                                forSupplementaryViewOfKind: "Separator",
//                                withReuseIdentifier: "Separator")
//
//        collectionView.delegate = mainSplitScreenHierarchy
//        collectionView.dataSource = mainSplitScreenHierarchy
//
//        tempCollectionView = collectionView
//        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTap))
//        collectionView.addGestureRecognizer(gesture)
//    }
//
//    @objc func didTap(gestureRecognizer: UITapGestureRecognizer) {
//        let loc = gestureRecognizer.location(in: view)
//        print("Item: \(tempCollectionView.indexPathForItem(at: loc))")
//        print("Supplementary view: \(tempCollectionView.indexPathForSupplementaryView(ofKind: "Separator", at: loc))")
//    }
//}
//
//extension UICollectionView {
//    func indexPathForSupplementaryView(ofKind kind: String, at point: CGPoint) -> IndexPath? {
//        let visibleIndexPaths = indexPathsForVisibleSupplementaryElements(ofKind: "Separator")
//
//        for indexPath in visibleIndexPaths {
//            let attributes = layoutAttributesForSupplementaryElement(ofKind: "Separator", at: indexPath)
//            if attributes?.frame.contains(point) ?? false { return indexPath }
//        }
//
//        return nil
//    }
//}
//
