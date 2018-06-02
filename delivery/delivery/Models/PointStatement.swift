//
//  PointStatement.swift
//  delivery
//
//  Created by Bacelar on 2018-02-21.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

struct PointStatement {
    public let consumedPoints: Int
    public let earnedPoints: Int
    
    var dictionary: [String: Any] {
        return[
            "consumedPoints": consumedPoints,
            "earnedPoints": earnedPoints
        ]
    }
    
    init?(dictionary: [String: Any]) {
        guard let consumedPoints = dictionary["consumedPoints"] as? Int,
            let earnedPoints = dictionary["earnedPoints"] as? Int
            else { return nil }
        
        self.consumedPoints = consumedPoints
        self.earnedPoints = earnedPoints
    }
}
