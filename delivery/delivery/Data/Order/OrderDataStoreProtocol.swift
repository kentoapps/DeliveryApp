//
//  DeliveryDataStoreProtocol.swift
//  delivery
//
//  Created by MATSUHISA MAI on 2018/03/12.
//  Copyright © 2018年 CICCC. All rights reserved.
//

import Foundation
import RxSwift

protocol OrderDataStoreProtocol {
    func fetchOrder(with userId: String) -> Single<[OrderEntity]>
    func saveOrder(_ order: OrderEntity) -> Completable //OrderEntity
    func fetchOrderDetail(with orderId: String) -> Single<OrderEntity>
}

