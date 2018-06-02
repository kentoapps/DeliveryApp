//
//  ProductGridFlowLayout.swift
//  delivery
//
//  Created by Bacelar on 2018-03-29.
//  Copyright © 2018 CICCC. All rights reserved.
//

import UIKit

class GridLayout: UICollectionViewFlowLayout {
    
    var numberOfColumns: Int = 3
    var itemHeight: CGFloat = 260.0
    
    init(numberOfColumns: Int, itemHeight: CGFloat = 260.0) {
        super.init()
        minimumLineSpacing = 1
        minimumInteritemSpacing = 1
        
        self.itemHeight = itemHeight
        self.numberOfColumns = numberOfColumns
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var itemSize: CGSize {
        get {
            if let collectionView = collectionView {
                let itemWidth: CGFloat = (collectionView.frame.width/CGFloat(self.numberOfColumns)) - self.minimumInteritemSpacing
                let adjustedHeight = itemHeight - (collectionView.contentInset.top + collectionView.contentInset.bottom) - (sectionInset.top + sectionInset.bottom)
                return CGSize(width: itemWidth, height: adjustedHeight)
            }
            
            // Default fallback
            return CGSize(width: 100, height: 100)
        }
        set {
            super.itemSize = newValue
        }
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
}

