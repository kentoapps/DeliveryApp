//
//  ProductDetailDataStoreProtocol.swift
//  delivery
//
//  Created by Kento Uchida on 2018/02/24.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift

protocol ProductDetailDataStoreProtocol {
    func fetchProductDetail(_ productId: String) -> Single<ProductEntity>
    func fetchFrequentlyPurchasedWith(_ productId: String) -> Single<[ProductEntity]>
    func fetchRelatedTo(_ productId: String) -> Single<[ProductEntity]>
}
