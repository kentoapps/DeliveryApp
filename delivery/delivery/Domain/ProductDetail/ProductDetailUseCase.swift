//
//  ProductDetailUseCase.swift
//  delivery
//
//  Created by Kento Uchida on 2018/02/24.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift

protocol ProductDetailUseCaseProtocol {
    func fetchProductDetail(_ productId: String) -> Single<Product>
    func fetchFrequentlyPurchasedWith(_ productId: String) -> Single<[Product]>
    func fetchRelatedTo(_ productId: String) -> Single<[Product]>
}

class ProductDetailUseCase: ProductDetailUseCaseProtocol {
    
    internal let repository: ProductDetailRepositoryProtocol
    internal let translator: ProductDetailTranslator
    
    init(repository: ProductDetailRepositoryProtocol, translator: ProductDetailTranslator) {
        self.repository = repository
        self.translator = translator
    }

    func fetchProductDetail(_ productId: String) -> Single<Product> {
        return repository.fetchProductDetail(productId)
            .map { entity in
                self.translator.translate(entity)
            }
    }
    
    func fetchFrequentlyPurchasedWith(_ productId: String) -> Single<[Product]> {
        return repository.fetchFrequentlyPurchasedWith(productId)
            .map { entity in
                self.translator.translateList(from: entity)
            }
    }
    
    func fetchRelatedTo(_ productId: String) -> Single<[Product]> {
        return repository.fetchRelatedTo(productId)
            .map { entity in
                self.translator.translateList(from: entity)
        }
    }
}
