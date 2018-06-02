//
//  PointStatementEntity.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-03-19.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

struct PointStatementEntity {
    public let earnedPoint: Int
    public let consumedPoint: Int
    
    var dictionary: [String: Any] {
        return [
            "earnedPoint": earnedPoint,
            "consumedPoint": consumedPoint
        ]
    }
    
    init?(dictionary: [String: Any]) {
        guard let earnedPoint = dictionary["earnedPoint"] as? Int,
            let consumedPoint = dictionary["consumedPoint"] as? Int else { return nil }
        
        self.earnedPoint = earnedPoint
        self.consumedPoint = consumedPoint
    }
}
