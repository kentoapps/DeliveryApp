//
//  User.swift
//  delivery
//
//  Created by Bacelar on 2018-02-21.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

struct User {
    
    public let firstName: String?
    public let lastName: String?
    public let mobileNumber: String?
    public let dateOfBirth: Date?
    public let isMember: Bool
    public let email: String?
    public let totalPoint: Int
    public let address: [Address]?
    public let payment: [Payment]?

    public let coupon: [String : Bool]?
    
    var dictionary: [String: Any] {
        return [
            "firstName": firstName,
            "lastName": lastName,
            "mobileNumber": mobileNumber,
            "dateOfBirth": dateOfBirth as! Date,
            "email": email,
            "address": address,
            "payment": payment,
            "coupon": coupon ?? [:]
        ]
    }    
}
