//
//  AccountFirebaseDataStore.swift
//  delivery
//
//  Created by Diego H. Vanni on 2018-03-12.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import Firebase

class AccountFirebaseDataStore: AccountDataStoreProtocol {
    let db = Firestore.firestore()
    
    func fetchAccount(_ id: Int) {
//        let account = db.collection("accountFromSpreadSheet").document("Accounts")
        
//        return AccountEntity(
//            accountId: 123456,
//            email: "user@test.ca",
//            password: "Password0",
//            token:"7c898981-f472-4000-b4ba-5f0b4330889d"
//        )
    }
}
