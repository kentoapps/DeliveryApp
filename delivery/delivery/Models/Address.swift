//
//  Address.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-02-20.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

struct Address {
    public let receiver: String
    public let address1: String
    public let address2: String
    public let city: String
    public let province: String
    public let postalCode: String
    public let country: String
    public let isDefault: Bool
    public let phoneNumber: String
    
    var dictionary: [String: Any] {
        return [
            "receiver": receiver,
            "address1": address1,
            "address2": address2,
            "city": city,
            "province": province,
            "postalCode": postalCode,
            "country": country,
            "isDefault": isDefault,
            "phoneNumber": phoneNumber
        ]
    }
    
    func changeDefault(isDefault: Bool) -> Address {
        return Address(receiver: self.receiver,
                       address1: self.address1,
                       address2: self.address2,
                       city: self.city,
                       province: self.province,
                       postalCode: self.postalCode,
                       country: self.country,
                       isDefault: isDefault,
                       phoneNumber: self.phoneNumber)
    }

}
