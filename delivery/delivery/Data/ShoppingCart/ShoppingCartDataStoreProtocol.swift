//
//  ShoppingCartDataStoreProtocol.swift
//  delivery
//
//  Created by Bacelar on 2018-04-05.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift

protocol ShoppingCartDataStoreProtocol {
    func addProductShoppingCart(shoppingCart: ShoppingCartEntity) -> Completable
    func updateProductShoppingCart(shoppingCart: ShoppingCartEntity) -> Completable
    func fetchShoppingCart() -> Single<[ProductShoppingCartEntity]>
    func deleteShoppingCart() -> Completable
    func deleteProductFromShoppingCart(with primaryKey: String) -> Completable
    func productAlreadyInCart(with primaryKey: String) -> Bool
}


