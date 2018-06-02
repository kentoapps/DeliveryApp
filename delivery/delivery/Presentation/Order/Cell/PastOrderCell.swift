//
//  PastOrderCell.swift
//  delivery
//
//  Created by MATSUHISA MAI on 2018/04/12.
//  Copyright © 2018年 CICCC. All rights reserved.
//

import UIKit
import Kingfisher


class PastOrderCell: UITableViewCell {

    static var Identifier = "PastOrderCell"
    
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var purchasedDate: UILabel!
    @IBOutlet weak var status: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = nil
    }
    
    var order : Order?{
        didSet{
            guard order != nil else {
                return
            }
            
            let imageUrlString = order?.orderDetail[0].productImage
            let imageUrl: URL = URL(string: imageUrlString!)!
            let resource = ImageResource(downloadURL: imageUrl, cacheKey: imageUrlString)
            self.productImage.kf.setImage(with: resource)
            
            self.productName.text = order?.orderDetail[0].productName
            self.quantity.text = String(order!.orderDetail.count)
            self.totalPrice.text = String(format:"%.2f", (order?.totalPrice)! - (order?.couponDiscount)!)
        }
    }
}

//Rounded rectangle
@IBDesignable
class BorderLabel: UILabel {
    @IBInspectable var borderWidth : CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor : UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
    
    @IBInspectable var cornerRadius : CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var topInset: CGFloat = 5.0
    @IBInspectable var bottomInset: CGFloat = 5.0
    @IBInspectable var leftInset: CGFloat = 5.0
    @IBInspectable var rightInset: CGFloat = 5.0
    
    override func drawText(in rect: CGRect) {
        let insets = UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        super.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
    }
    
    //padding
    override var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            contentSize.height += topInset + bottomInset
            contentSize.width += leftInset + rightInset
            return contentSize
        }
    }
}
