//
//  ProductDetailRepository.swift
//  delivery
//
//  Created by Kento Uchida on 2018/02/24.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift

protocol ProductDetailRepositoryProtocol{
    func fetchProductDetail(_ productId: String) -> Single<ProductEntity>
    func fetchFrequentlyPurchasedWith(_ productId: String) -> Single<[ProductEntity]>
    func fetchRelatedTo(_ productId: String) -> Single<[ProductEntity]>
}

class ProductDetailRepository: ProductDetailRepositoryProtocol {
    
    private let dataStore: ProductDetailDataStoreProtocol
    
    init(dataStore: ProductDetailDataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    func fetchProductDetail(_ productId: String) -> Single<ProductEntity> {
        return dataStore.fetchProductDetail(productId)
    }
    
    func fetchFrequentlyPurchasedWith(_ productId: String) -> Single<[ProductEntity]> {
        return dataStore.fetchFrequentlyPurchasedWith(productId)
    }
    
    func fetchRelatedTo(_ productId: String) -> Single<[ProductEntity]> {
        return dataStore.fetchRelatedTo(productId)
    }
}
