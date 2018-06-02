//
//  ProductListViewModelCV.swift
//  delivery
//
//  Created by Bacelar on 2018-03-27.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ProductListViewModelCV: BaseViewModel {
    
    private var useCase: ProductListUseCaseProtocol
    
    var productsList = BehaviorRelay<[Product]>(value: [])
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(useCase: ProductListUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func fetchProductList(){
        useCase.fetchProductList()
            .subscribe(
                onSuccess: { (product) in
                    self.productsList.accept(product)
            }, onError: { (error) in
                print(error.localizedDescription)}
            ) .disposed(by: disposeBag)
    }
    
}
