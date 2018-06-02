//
//  ShoppingCartRepository.swift
//  delivery
//
//  Created by Bacelar on 2018-04-05.
//  Copyright © 2018 CICCC. All rights reserved.
//
import Foundation
import RxSwift

protocol ShoppingCartRepositoryProtocol{
    func deleteShoppingCart() -> Completable
    func addProductShoppingCart(shoppingCart: ShoppingCartEntity) -> Completable
    func updateProductShoppingCart(shoppingCart: ShoppingCartEntity) -> Completable
    func fetchShoppingCart() -> Single<[ProductShoppingCartEntity]>
    func deleteProductFromShoppingCart(with primaryKey: String) -> Completable
    func productAlreadyInCart(with primaryKey: String)-> Bool
}

class ShoppingCartRepository: ShoppingCartRepositoryProtocol {
    
    private let dataStore: ShoppingCartDataStoreProtocol
    
    init(dataStore: ShoppingCartDataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    func addProductShoppingCart(shoppingCart: ShoppingCartEntity) -> Completable {
        return dataStore.addProductShoppingCart(shoppingCart: shoppingCart)
    }
    
    func updateProductShoppingCart(shoppingCart: ShoppingCartEntity) -> Completable {
        return dataStore.updateProductShoppingCart(shoppingCart: shoppingCart)
    }
    
    func fetchShoppingCart() -> Single<[ProductShoppingCartEntity]> {
        return dataStore.fetchShoppingCart()
    }
    
    func deleteShoppingCart() -> Completable {
        return dataStore.deleteShoppingCart()
    }
    
    func deleteProductFromShoppingCart(with primaryKey: String) -> Completable{
        return dataStore.deleteProductFromShoppingCart(with: primaryKey)
    }
    
    func productAlreadyInCart(with primaryKey: String) -> Bool {
        return dataStore.productAlreadyInCart(with: primaryKey)
    }
}
