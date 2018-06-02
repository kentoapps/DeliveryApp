//
//  AccountRepository.swift
//  delivery
//
//  Created by Diego H. Vanni on 2018-03-12.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

protocol AccountRepositoryProtocol{
    func fetchAccount(_ id: Int)
}

class AccountRepository: AccountRepositoryProtocol {
    
    private let dataStore: AccountDataStoreProtocol
    
    init(dataStore: AccountDataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    func fetchAccount(_ id: Int) {
//        return dataStore.fetchAccount(id)
    }
}
