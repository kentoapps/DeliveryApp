//
//  CollectionViewCell.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-03-26.
//  Copyright © 2018 CICCC. All rights reserved.
//

import UIKit
import Kingfisher

class CollectionViewCell: UICollectionViewCell {

    
    static var Identifier = "CollectionViewCell"

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var discountPercentLabel: UILabel!
    @IBOutlet weak var addCart: UIButton!
    
    var item: Product? {
        didSet {
            guard let item = item else { return }
            nameLabel.text = item.name
            if item.discountPercent > 0 {
                discountPercentLabel.text = "\(item.discountPercent)%"
                priceLabel.text = "$\(item.price)"
                originalPriceLabel.text = "$\(item.originalPrice)"
            } else {
                priceLabel.text = "$\(item.price)"
                originalPriceLabel.text = ""
                discountPercentLabel.text = ""
            }
            let imageUrlString = item.images[0]
            let imageUrl:URL = URL(string: imageUrlString)!
            
            let resource = ImageResource(downloadURL: imageUrl, cacheKey: item.name)
            self.productImage.kf.setImage(with: resource)
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
