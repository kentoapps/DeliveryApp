//
//  ShoppingCartCell.swift
//  delivery
//
//  Created by Bacelar on 2018-04-12.
//  Copyright © 2018 CICCC. All rights reserved.
//

import UIKit
import Kingfisher

class ShoppingCartCell: UICollectionViewCell {
    
    static var Identifier = "ShoppingCartCell"
    
    @IBOutlet weak var quantityButton: UIButton!
    @IBOutlet weak var deleteProduct: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var oldPrice: BaseLabel!
    @IBOutlet weak var percentage: UILabel!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()

        productImage.image = nil
    }
    
    var productShoppingCart: ProductShoppingCart? {
        didSet {
            guard let shoppingCart = productShoppingCart else { return }
            self.name.text = shoppingCart.product.name
            self.price.text = String(format:"%.2f", shoppingCart.product.price)
            self.oldPrice.text = String(format:"%.2f", shoppingCart.product.originalPrice)
            self.percentage.text = ("\(shoppingCart.product.discountPercent) %")
            
            let imageUrlString = shoppingCart.product.images[0]
            let imageUrl:URL = URL(string: imageUrlString)!
            
            let resource = ImageResource(downloadURL: imageUrl, cacheKey: shoppingCart.product.name)
            self.productImage.kf.setImage(with: resource)
        }
    }
}

