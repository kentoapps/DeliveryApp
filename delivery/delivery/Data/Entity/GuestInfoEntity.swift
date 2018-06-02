//
//  GuestInfoEntity.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-05-20.
//  Copyright © 2018 CICCC. All rights reserved.
//

import RealmSwift

class GuestInfoEntity: Object {
    @objc dynamic var id = 0
    @objc dynamic var firstName = ""
    @objc dynamic var lastName = ""
    @objc dynamic var mobileNumber = ""
    @objc dynamic var email = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

