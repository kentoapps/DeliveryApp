//
//  GuestAddressEntity.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-05-21.
//  Copyright © 2018 CICCC. All rights reserved.
//

import RealmSwift

class GuestAddressEntity: Object {
    @objc dynamic var id = 0
    @objc dynamic var receiver: String = ""
    @objc dynamic var address1: String = ""
    @objc dynamic var address2: String = ""
    @objc dynamic var city: String = ""
    @objc dynamic var province: String = ""
    @objc dynamic var postalCode: String = ""
    @objc dynamic var country: String = ""
    @objc dynamic var isDefault: Bool = true
    @objc dynamic var phoneNumber: String = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
