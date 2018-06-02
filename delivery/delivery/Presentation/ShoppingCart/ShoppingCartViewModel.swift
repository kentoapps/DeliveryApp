//
//  ShoppingCartViewModel.swift
//  delivery
//
//  Created by Bacelar on 2018-04-12.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ShoppingCartViewModel: BaseViewModel {
    
    private var useCase: ShoppingCartUseCaseProtocol
    
    public var subTotal = BehaviorRelay<String>(value: "0.0")
    public var discount = BehaviorRelay<String>(value: "0.0")
    public var hsttax = BehaviorRelay<String>(value: "0.0")
    public var total = BehaviorRelay<String>(value: "0.0")
    public var productsShoppingCart = BehaviorRelay<[ProductShoppingCart]>(value: [])
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(useCase: ShoppingCartUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func fetchShoppingCartList(){
        useCase.fetchShoppingCart()
            .subscribe(
                onSuccess: { (productsList) in

                    self.productsShoppingCart.accept(productsList)
                    
                    self.calculateSubTotal()
                    
            }, onError: { (error) in
                print(error.localizedDescription)}
            ) .disposed(by: disposeBag)
        
    }
    
    func deleteShoppingCart() {
        useCase.deleteShoppingCart()
            .subscribe(
                onCompleted: { },
                onError: { error in self.setError(error) }
            ).disposed(by: disposeBag)
    }
    
    func deleteProductFromShoppingCart(with primaryKey: String){
        useCase.deleteProductFromShoppingCart(with: primaryKey)
            .subscribe(
                onCompleted: { },
                onError: { error in self.setError(error) }
            ).disposed(by: disposeBag)
    }
    
    func calculateSubTotal(){
        let shoppingCart = productsShoppingCart.value
        
        var preSubTotal = 0.0
        
        for item in shoppingCart {
            preSubTotal = preSubTotal + item.total
        }
        subTotal.accept("$ \(String(format:"%.2f", preSubTotal))")
        
        discount.accept("$ \(String(format:"%.2f", 0))")
        hsttax.accept("$ \(String(format:"%.2f", 0))")
        
        total.accept("$ \(String(format:"%.2f", preSubTotal))")
    }
    
    func updateProductShoppingCart(with shoppingCart: ShoppingCart){
        useCase.updateProductShoppingCart(shoppingCart: shoppingCart)
            .subscribe(
                onCompleted: { },
                onError: { error in self.setError(error) }
            ).disposed(by: disposeBag)
    }
        
}
