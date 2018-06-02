//
//  OrderDetailEntity.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-03-19.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

struct OrderDetailEntity{
    var pricePerItem: Double
    var quantity: Int
    var productId: String
    var productImage: String
    var productName: String
    
    init(pricePerItem: Double, quantity: Int, productId: String, productImage: String, productName: String) {
        self.pricePerItem = pricePerItem
        self.quantity = quantity
        self.productId = productId
        self.productImage = productImage
        self.productName = productName
    }
    
    var dictionary: [String: Any] {
        return [
            "pricePerItem": pricePerItem,
            "quantity": quantity,
            "productId": productId,
            "productImage": productImage,
            "productName": productName
        ]
    }
    
    init?(dictionary: [String: Any]) {
        guard let pricePerItem = dictionary["pricePerItem"] as? Double,
            let quantity = dictionary["quantity"] as? Int,
            let productId = dictionary["productId"] as? String,
            let productImage = dictionary["productImage"] as? String,
            let productName = dictionary["productName"] as? String  else { return nil }
        
        self.pricePerItem = pricePerItem
        self.quantity = quantity
        self.productId = productId
        self.productImage = productImage
        self.productName = productName
    }
}
