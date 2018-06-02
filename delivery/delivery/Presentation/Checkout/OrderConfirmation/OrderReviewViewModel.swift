//
//  OrderReviewViewModel.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-05-14.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class OrderReviewViewModel: BaseViewModel {
    
    private let useCase: OrderUseCaseProtocol
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(useCase: UserUseCaseProtocol) {
        self.useCase = useCase
    }
}
