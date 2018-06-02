//
//  ProductShoppingCartEntity.swift
//  delivery
//
//  Created by Bacelar on 2018-04-11.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

struct ProductShoppingCartEntity {
    
    public let product: ProductEntity
    public let quantity: Int
    
    init(product: ProductEntity,quantity: Int) {
        self.product = product
        self.quantity = quantity
    }
}
