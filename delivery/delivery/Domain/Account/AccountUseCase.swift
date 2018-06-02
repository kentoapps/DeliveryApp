//
//  AccountUseCase.swift
//  delivery
//
//  Created by Diego H. Vanni on 2018-03-12.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

protocol AccountUseCaseProtocol {
    func fetchAccount(_ id: Int)
}

class AccountUseCase: AccountUseCaseProtocol {
    
    internal let repository: AccountRepositoryProtocol
    internal let translator: AccountTranslator
    
    init(repository: AccountRepositoryProtocol, translator: AccountTranslator) {
        self.repository = repository
        self.translator = translator
    }
    
    func fetchAccount(_ id: Int) {
//        let entity = repository.fetchAccount(id)
//        return translator.translate(entity)
    }
}
