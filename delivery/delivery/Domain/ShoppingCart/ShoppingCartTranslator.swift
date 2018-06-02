//
//  ShoppingCartTranslator.swift
//  delivery
//
//  Created by Bacelar on 2018-04-05.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

class ShoppingCartTranslator: TranslatorProtocol {
    func translate(_ shoppingCart: ShoppingCart) -> ShoppingCartEntity {
    
        let shopping = ShoppingCartEntity()
        shopping.quantity = shoppingCart.quantity
        shopping.idProducts = shoppingCart.idProducts
        
        return shopping
    }
    
    
    func translateShoppingCart(_ shoppingCartEntity: [ProductShoppingCartEntity]) -> [ProductShoppingCart] {
        
        let productTranslator = ProductDetailTranslator()
        var products = [ProductShoppingCart]()
        
        for shoppingCart in shoppingCartEntity {
            let product = productTranslator.translate(shoppingCart.product)
            products.append(ProductShoppingCart(product: product,quantity: shoppingCart.quantity))
        }
        return products
    }
}
