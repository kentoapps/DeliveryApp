//
//  ProductCellCV.swift
//  delivery
//
//  Created by Bacelar on 2018-03-27.
//  Copyright © 2018 CICCC. All rights reserved.
//

import UIKit
import Kingfisher

class ProductCellCV: UICollectionViewCell {

    static var Identifier = "ProductCellCV"
    
    @IBOutlet weak var percentage: UILabel!
    @IBOutlet weak var oldPrice: BaseLabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var addCart: BaseButton!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        productImage.image = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    var product: Product? {
        didSet {
            guard let product = product else { return }
            self.name.text = product.name
            self.price.text = String(format:"%.2f", product.price)
            self.oldPrice.text = String(format:"%.2f", product.originalPrice)
            self.percentage.text = ("\(product.discountPercent) %")
            
            let imageUrlString = product.images[0]
            let imageUrl:URL = URL(string: imageUrlString)!
            
            let resource = ImageResource(downloadURL: imageUrl, cacheKey: product.name)
            self.productImage.kf.setImage(with: resource)
        }
        
    }
    
}
