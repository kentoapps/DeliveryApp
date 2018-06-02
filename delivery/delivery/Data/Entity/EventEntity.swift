//
//  EventEntity.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-03-18.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

struct EventEntity {
    
    public let name: String
    public let dateStart: Date
    public let dateEnd: Date
    
    var dictionary: [String: Any] {
        return [
            "name": name,
            "dateStart": dateStart,
            "dateEnd": dateEnd
        ]
    }
}
