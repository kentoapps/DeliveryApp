//
//  Review.swift
//  delivery
//
//  Created by Bacelar on 2018-02-21.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

struct Review {
    public let userId: String
    public let userName: String
    public let title: String?
    public let comment: String?
    public let rating: Double
//    public let productId: String
    public let date: Date
    
    var dictionary: [String: Any] {
        return [
            "userId": userId,
            "userName": userName,
            "title": title as Any,
            "comment": comment as Any,
            "rating": rating,
//            "productId": productId,
            "date": date
        ]
    }
}
