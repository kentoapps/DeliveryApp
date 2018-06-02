//
//  PaymentEntity.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-03-18.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

struct PaymentEntity {
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
    
    init?(dictionary: [String: Any]) {
        guard let cardNumber = dictionary["cardNumber"] as? String,
            let holderName = dictionary["holderName"] as? String,
            let expiryDate = dictionary["expiryDate"] as? Date,
            let isDefault = dictionary["isDefault"] as? Bool else { return nil }
        
        self.cardNumber = cardNumber
        self.holderName = holderName
        self.expiryDate = expiryDate
        self.isDefault = isDefault
    }
    
    init(cardNumber: String, holderName: String, expiryDate: Date, isDefault: Bool) {
        self.cardNumber = cardNumber
        self.holderName = holderName
        self.expiryDate = expiryDate
        self.isDefault = isDefault
    }
}
