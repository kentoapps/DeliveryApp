//
//  NomnomError.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/22.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

enum NomnomError : Error {
    case alert(message: String)
    case network(code: String, message: String, log: String)
    case noData(message: String)
    case invalidInput(message: String)
    case invalidPassword(message: String)
}
