//
//  OrderViewModel.swift
//  delivery
//
//  Created by MATSUHISA MAI on 2018/03/12.
//  Copyright © 2018年 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class OrderViewModel : BaseViewModel{
    public var arrOfOrder = BehaviorRelay<[SectionModel<String, Order>]>(value: [])
    
    var isEmpty = BehaviorRelay(value: false)
    
    private var useCase: OrderUseCaseProtocol
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(useCase: OrderUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func fetchOrder(with userId: String) {
        useCase.fetchOrder(with: userId)
            .subscribe(
                onSuccess: { model in
                    
                    if model.count != 0 {
                    var currentOrder: [Order] = []
                    var pastOrder: [Order] = []
                    model.forEach({ (order) in
                        if (order.status == "delivered") {
                            pastOrder.append(order)
                        } else {
                            currentOrder.append(order)
                        }
                    })
                    self.arrOfOrder.accept([
                        SectionModel(model: "Current Order", items:currentOrder),
                        SectionModel(model: "Past Order", items: pastOrder)])
                    } else {
                        self.arrOfOrder.accept([])
                        self.isEmpty.accept(true)
                    }
            }, onError: { (error) in
                self.arrOfOrder.accept([])
                self.isEmpty.accept(true)
                print(error.localizedDescription)}
            ).disposed(by: disposeBag)
    }
}

