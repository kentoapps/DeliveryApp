//
//  BranchInventoryEntity.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-03-19.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

struct BranchInventoryEntity {
    public let quantity: Int
    public let name: String
    
    init?(dictionary: [String: Any]) {
        guard let name = dictionary["name"] as? String,
            let quantity = dictionary["quantity"] as? Int else { return nil }
        
        self.name = name
        self.quantity = quantity
    }
}
