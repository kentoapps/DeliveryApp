//
//  orderDetailCell.swift
//  delivery
//
//  Created by MATSUHISA MAI on 2018/05/18.
//  Copyright © 2018年 CICCC. All rights reserved.
//

import UIKit
import Kingfisher

class OrderDetailCell: UITableViewCell {
    
    static var Identifier = "OrderDetailCell"

    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var quantityPerItem: UILabel!
    @IBOutlet weak var pricePerItem: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = nil
    }
    
    var orderDetail : OrderDetail?{
        didSet{
            guard orderDetail != nil else{
                return
            }
            let imageUrlString = orderDetail?.productImage
            let imageUrl: URL = URL(string: imageUrlString!)!
            let resource = ImageResource(downloadURL: imageUrl, cacheKey: imageUrlString)
            self.productImage.kf.setImage(with: resource)
            
            self.productName.text = orderDetail?.productName
            self.quantityPerItem.text = String(orderDetail!.quantity)
            self.pricePerItem.text = "\(orderDetail!.pricePerItem)"
        }
    }

}
