//
//  OrderUseCase.swift
//  delivery
//
//  Created by MATSUHISA MAI on 2018/03/12.
//  Copyright © 2018年 CICCC. All rights reserved.
//

import Foundation
import RxSwift

protocol OrderUseCaseProtocol {
    func fetchOrder(with userId: String) -> Single<[Order]>
    func saveOrder(_ order: Order) -> Completable
    func fetchOrderDetail(with orderId : String) -> Single<Order>
//    func fetchOrderProduct(with productId: String) -> Single<Product>

}

class OrderUseCase: OrderUseCaseProtocol {
    internal let repository: OrderRepositoryProtocol
    internal let translator: OrderTranslator
//    internal let translator2: OrderTranslator
    
    init(repository: OrderRepositoryProtocol, translator: OrderTranslator) {
        self.repository = repository
        self.translator = translator
//        self.translator2 = translator2
    }
    
    func fetchOrder(with userId: String) -> Single<[Order]> {
        return repository.fetchOrder(with:userId)
            .map({ entities -> [Order] in
                self.translator.translate(entities)
            })
    }
    
    func saveOrder(_ order: Order) -> Completable {
        return repository.saveOrder(translator.translateToEntity(order))
    }

    func fetchOrderDetail(with orderId: String) -> Single<Order> {
        return repository.fetchOrderDetail(with: orderId)
            .map { entity in
                self.translator.translate2(entity)
            }
    }
//    func fetchOrderProduct(with productId: String) -> Single<Product> {
//        return repository.fetchOrderProduct(with: productId)
//            .map({ entity in
//                self.translator.translate2(entity)
//            })
//    }    
}
