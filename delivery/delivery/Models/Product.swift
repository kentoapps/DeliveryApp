//
//  Product.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-02-20.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

struct Product {
    public let averageRating: Double
    public let branch: [BranchInventory]
    public let brand: String
    public let description: String
    public let discountPercent: Int
    public let events: [String : Bool]
    public let images: [String]
    public let name: String
    public let originalPrice: Double
    public let price: Double
    public let category: String
    public let subCategory: String
    public let productId: String
    public var reviews: [Review]? = nil
    public let ratingCount: Int
    
    var dictionary: [String: Any] {
        return [
            "averageRating": averageRating,
            "branch": branch,
            "brand": brand,
            "description": description,
            "discountPercent": discountPercent,
            "event": events,
            "images": images,
            "name": name,
            "originalPrice": originalPrice,
            "price": price,
            "subCategory": subCategory,
            "category": category,
            "productId": productId
        ]
    }
}
