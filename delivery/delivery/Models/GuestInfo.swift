//
//  GuestInfo.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-05-20.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

class GuestInfo {
    public var firstName = ""
    public var lastName = ""
    public var email = ""
    public var mobileNumber = ""
    
    init(firstName: String, lastName: String, email: String, mobileNumber: String) {
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.mobileNumber = mobileNumber
    }
}

