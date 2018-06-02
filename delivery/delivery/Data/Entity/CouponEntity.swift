//
//  CouponEntity.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-03-18.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

struct CouponEntity {
    
    public let name: String
    public let code: String
    public let dateStart: Date
    public let dateEnd: Date
    public let discount: Int
    public let discountType: String
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "code": code,
            "dateStart": dateStart,
            "dateEnd": dateEnd,
            "discount": discount,
            "discountType": discountType
        ]
    }
    
    init?(dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
            let code = dictionary["code"] as? String,
            let dateStart = dictionary["dateStart"] as? Date, //this part...?
            let dateEnd = dictionary["dateEnd"] as? Date, // and this part.....!
            let discount = dictionary["name"] as? Int,
            let discountType = dictionary["discountType"] as? String else { return nil }
        
        self.name = name
        self.code = code
        self.dateStart = dateStart
        self.dateEnd = dateEnd
        self.discount = discount
        self.discountType = discountType
    }
}
