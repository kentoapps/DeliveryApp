//
//  OrderDetail.swift
//  delivery
//
//  Created by Sara N on 2018-02-20.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

struct OrderDetail{
    public var pricePerItem: Double
    public var quantity: Int
    public var productId: String
    public var productImage: String
    public var productName: String
    
    var dictionary: [String: Any] {
        return [
            "pricePerItem": pricePerItem,
            "quantity": quantity,
            "productId": productId,
            "productImage": productImage,
            "productName": productName
        ]
    }
    
    //    init(pricePerItem: Double, quantity: Int, productId: String) {
    //        self.pricePerItem = pricePerItem
    //        self.quantity = quantity
    //        self.productId = productId
    //    }
    
    init?(dictionary: [String: Any]) {
        guard let pricePerItem = dictionary["pricePerItem"] as? Double,
            let quantity = dictionary["quantity"] as? Int,
            let productId = dictionary["productId"] as? String,
            let productImage = dictionary["productImage"] as? String,
            let productName = dictionary["productName"] as? String else { return nil }
        
        self.pricePerItem = pricePerItem
        self.quantity = quantity
        self.productId = productId
        self.productImage = productImage
        self.productName = productName
    }
}

