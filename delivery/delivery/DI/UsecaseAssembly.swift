//
//  UsecaseAssembly.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/09.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Swinject

final class UsecaseAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ProductDetailUseCaseProtocol.self) { (_, repository: ProductDetailRepositoryProtocol, translator: ProductDetailTranslator) in
            ProductDetailUseCase(repository: repository, translator: translator)
        }
        
        container.register(OrderUseCaseProtocol.self) { (_, repository: OrderRepositoryProtocol, translator: OrderTranslator) in
            OrderUseCase(repository: repository, translator: translator)
        }

        container.register(UserUseCaseProtocol.self) { (_, repository: UserRepositoryProtocol, translator: UserTranslator) in
            UserUseCase(repository: repository, translator: translator)
        }
        container.register(UserUseCaseProtocol.self) { (_, repository: UserRepositoryProtocol, translator: UserTranslator) in
            UserUseCase(repository: repository, translator: translator)
        }
        container.register(ProductListUseCaseProtocol.self) { (_, repository: ProductListRepositoryProtocol, translator: ProductListTranslator) in
            ProductListUseCase(repository: repository, translator: translator)
        }
        container.register(ReviewListUseCaseProtocol.self) { (_, repository: ReviewListRepositoryProtocol, translator: ReviewTranslator) in
            ReviewListUseCase(repository: repository, translator: translator)
        }
        container.register(ReviewPostUseCaseProtocol.self) { (_, repository: ReviewPostRepositoryProtocol, translator: ReviewTranslator) in
            ReviewPostUseCase(repository: repository, translator: translator)
        }
        container.register(ShoppingCartUseCaseProtocol.self) { (_, repository: ShoppingCartRepositoryProtocol, translator: ShoppingCartTranslator) in
            ShoppingCartUseCase(repository: repository, translator: translator)
        }
    }
}

