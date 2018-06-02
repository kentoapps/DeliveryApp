//
//  AlertError.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/22.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

struct AlertError {
    let title: String
    let message: String
    
    init(title: String = "Error", message: String) {
        self.title = title
        self.message = message
    }
}
