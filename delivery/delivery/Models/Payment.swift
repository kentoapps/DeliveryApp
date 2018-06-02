//
//  Payment.swift
//  delivery
//
//  Created by Sara N on 2018-02-20.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

struct Payment {
    public let cardNumber: String
    public let holderName: String
    public let expiryDate: Date
    public let isDefault: Bool
    
    var dictionary: [String: Any] {
        return [
            "cardNumber": cardNumber,
            "holderName": holderName,
            "expiryDate": expiryDate,
            "isDefault": isDefault
        ]
    }
}
