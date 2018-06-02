//
//  TranslatorAssembly.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/09.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Swinject

final class TranslatorAssembly: Assembly {
    func assemble(container: Container) {
        container.register(ProductDetailTranslator.self) { _ in
            ProductDetailTranslator()
        }
        container.register(OrderTranslator.self) { _ in
            OrderTranslator()
        }
        container.register(UserTranslator.self) { _ in
            UserTranslator()
        }
        container.register(UserTranslator.self) { _ in
            UserTranslator()
        }
        container.register(ProductListTranslator.self) { _ in
            ProductListTranslator()
        }
        container.register(ReviewTranslator.self) { _ in
            ReviewTranslator()
        }
        container.register(ShoppingCartTranslator.self) { _ in
            ShoppingCartTranslator()
        }
    }
}
