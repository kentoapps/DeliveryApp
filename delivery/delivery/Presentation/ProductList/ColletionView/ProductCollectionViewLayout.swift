//
//  ProductCollectionViewLayout.swift
//  delivery
//
//  Created by Bacelar on 2018-03-28.
//  Copyright © 2018 CICCC. All rights reserved.
//

import UIKit

class ProductGridFlowLayout: UICollectionViewFlowLayout {
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    func setupLayout() {
        minimumInteritemSpacing = 1
        minimumLineSpacing = 1
        scrollDirection = .vertical
    }
    
    
    override var itemSize: CGSize {
        set {
            
        }
        get {
            let padding: CGFloat =  25
            let collectionViewSize = self.collectionView!.frame.size.width - padding
            
            return CGSize(width: 150, height: 200)
        }
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        return collectionView!.contentOffset
    }

}
