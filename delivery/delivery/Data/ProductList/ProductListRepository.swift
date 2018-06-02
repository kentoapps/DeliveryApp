//
//  ProductListRepository.swift
//  delivery
//
//  Created by Bacelar on 2018-03-06.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift

protocol ProductListRepositoryProtocol{
    func fetchProductList(with keyword: String, by orderby: String, _ descending: Bool, filters: [String:Any]) -> Single<[ProductEntity]>
}

class ProductListRepository: ProductListRepositoryProtocol {
    private let dataStore: ProductListDataStoreProtocol
    
    init(dataStore: ProductListDataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    func fetchProductList(with keyword: String, by orderby: String, _ descending: Bool, filters: [String:Any]) -> Single<[ProductEntity]> {
        return dataStore.fetchProductList(with: keyword, by: orderby, descending, filters: filters)
    }


}
