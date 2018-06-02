//
//  ProductListUseCase.swift
//  delivery
//
//  Created by Bacelar on 2018-03-13.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift


protocol ProductListUseCaseProtocol {
    func fetchProductList(with keyword: String, by orderby: String, _ descending: Bool, filters: [String:Any]) -> Single<[Product]>
    func fetchProduct(product: Product) -> Product
}

class ProductListUseCase: ProductListUseCaseProtocol {
    
    internal let repository: ProductListRepositoryProtocol
    internal let translator: ProductListTranslator
    var brands: [String]
    
    init(repository: ProductListRepositoryProtocol, translator: ProductListTranslator) {
        self.repository = repository
        self.translator = translator
        self.brands = [String]()
    }
    
    func fetchProductList(with keyword: String, by orderby: String, _ descending: Bool, filters: [String:Any]) -> Single<[Product]> {
        return repository.fetchProductList(with: keyword, by: orderby, descending, filters: filters).map { (entities) -> [Product] in
            self.translator.translate(entities)
        }        
    }
    
    func fetchProduct(product: Product) -> Product {
        return product
    }
    
}
