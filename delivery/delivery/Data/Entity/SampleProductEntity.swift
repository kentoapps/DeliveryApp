//
//  ProductDetailEntity.swift
//  delivery
//
//  Created by Kento Uchida on 2018/02/24.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

struct SampleProductEntity {
    public let id: String
    public let name: String
    public let price: Double
    public let originalPrice: Double
    public let description: String
    
    init?(dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
            let id = dictionary["id"] as? String,
            let price = dictionary["price"] as? Double,
            let originalPrice = dictionary["originalPrice"] as? Double,
            let description = dictionary["description"] as? String else { return nil }
        
        self.id = id
        self.name = name
        self.price = price
        self.originalPrice = originalPrice
        self.description = description
    }
}

