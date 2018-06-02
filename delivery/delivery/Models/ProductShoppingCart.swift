//
//  ProductShoppingCart.swift
//  delivery
//
//  Created by Bacelar on 2018-04-13.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

struct ProductShoppingCart {
    
    public let product: Product
    public var quantity: Int
    public var total: Double {
        return product.price * Double(quantity)
    }
    
    init(product: Product,quantity: Int) {
        self.product = product
        self.quantity = quantity
    }
}
