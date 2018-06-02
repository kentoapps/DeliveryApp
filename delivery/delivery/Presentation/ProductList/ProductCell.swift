//
//  ProductListModel.swift
//  delivery
//
//  Created by Bacelar on 2018-03-19.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift

class ProductCell: UITableViewCell {
    
    static var Identifier = "ProductCell"
        
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var oldPrice: UILabel!


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
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

