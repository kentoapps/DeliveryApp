//
//  DataManagerAssembly.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/09.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Swinject

final class RepositoryAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ProductDetailRepositoryProtocol.self) { (_, dataStore: ProductDetailDataStoreProtocol) in
            ProductDetailRepository(dataStore: dataStore)
        }
        container.register(OrderRepositoryProtocol.self) { (_, dataStore: OrderDataStoreProtocol) in
            OrderRepository(dataStore: dataStore)
        }
//        container.register(UserRepositoryProtocol.self) { (_, dataStore: UserDataStoreProtocol) in
//            UserRepository(dataStore: dataStore)
//        }
        container.register(UserRepositoryProtocol.self) { (_, dataStore: UserDataStoreProtocol, guestDataStore: GuestDataStoreProtocol) in
            UserRepository(dataStore: dataStore, guestDataStore: guestDataStore)
        }
        container.register(ProductListRepositoryProtocol.self) { (_, dataStore: ProductListDataStoreProtocol) in
            ProductListRepository(dataStore: dataStore)
        }
        container.register(ReviewListRepositoryProtocol.self) { (_, dataStore: ReviewListDataStoreProtocol) in
            ReviewListRepository(dataStore: dataStore)
        }
        container.register(ReviewPostRepositoryProtocol.self) { (_, dataStore: ReviewPostDataStoreProtocol) in
            ReviewPostRepository(dataStore: dataStore)
        }
        container.register(ShoppingCartRepositoryProtocol.self) { (_, dataStore: ShoppingCartDataStoreProtocol) in
            ShoppingCartRepository(dataStore: dataStore)
        }
//        container.register(GuestRepositoryProtocol.self) { (_, dataStore: GuestDataStoreProtocol) in
//            GuestRepository(dataStore: dataStore)
//        }
    }
}
