//
//  Validation.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-05-16.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

class Validation {
    static func validateEmail(email: String) -> Bool {
        let REGEX: String
        REGEX = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: email)
    }
    
    static func validatePassword(password: String) -> Bool {
        let REGEX: String
        REGEX = "(?=.*[A-Z])(?=.*[0-9])(?=.*[a-z]).{8,}"
        return NSPredicate(format: "SELF MATCHES %@", REGEX).evaluate(with: password)
    }
}
