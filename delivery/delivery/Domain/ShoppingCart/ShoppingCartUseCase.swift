//
//  ShoppingCartUseCase.swift
//  delivery
//
//  Created by Bacelar on 2018-04-05.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift

protocol ShoppingCartUseCaseProtocol {
    func deleteShoppingCart() -> Completable
    func addProductShoppingCart(shoppingCart: ShoppingCart) -> Completable
    func updateProductShoppingCart(shoppingCart: ShoppingCart) -> Completable
    func fetchShoppingCart() -> Single<[ProductShoppingCart]>
    func deleteProductFromShoppingCart(with primaryKey: String) -> Completable
    func productAlreadyInCart(with primaryKey: String) -> Bool
}

class ShoppingCartUseCase: ShoppingCartUseCaseProtocol {

    internal let repository: ShoppingCartRepositoryProtocol
    internal let translator: ShoppingCartTranslator
    
    init(repository: ShoppingCartRepositoryProtocol, translator: ShoppingCartTranslator) {
        self.repository = repository
        self.translator = translator
    }

    func deleteShoppingCart() -> Completable {
        return repository.deleteShoppingCart()
    }

    func addProductShoppingCart(shoppingCart: ShoppingCart) -> Completable {
        let shoppingCartEntity = translator.translate(shoppingCart)
        return repository.addProductShoppingCart(shoppingCart: shoppingCartEntity)
    }

    func updateProductShoppingCart(shoppingCart: ShoppingCart) -> Completable {
        let shoppingCartEntity = translator.translate(shoppingCart)
        return repository.updateProductShoppingCart(shoppingCart: shoppingCartEntity)
    }

    func fetchShoppingCart() -> Single<[ProductShoppingCart]> {
        return repository.fetchShoppingCart().map { (shoppingCartEntity) -> [ProductShoppingCart] in
            self.translator.translateShoppingCart(shoppingCartEntity)
        }
    }

    func deleteProductFromShoppingCart(with primaryKey: String) -> Completable {
        return repository.deleteProductFromShoppingCart(with: primaryKey)
    }

    func productAlreadyInCart(with primaryKey: String) -> Bool {
        return repository.productAlreadyInCart(with: primaryKey)
    }
}
