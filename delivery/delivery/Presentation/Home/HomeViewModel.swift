//
//  HomeViewModel.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-03-12.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift


class HomeViewModel: BaseViewModel {

// MARK: - Variables & Instances

    var arrOfTopSalesProduct = BehaviorRelay<[Product]>(value: [])
    var arrOfProductYouMayLike = BehaviorRelay<[Product]>(value: [])
    var arrOfNewProducts = BehaviorRelay<[Product]>(value: [])
    var arrOfTrendsKeyword = BehaviorRelay<[String]>(value: [])

    private let disposeBag: DisposeBag = DisposeBag()
    private let useCase: ProductListUseCaseProtocol
    private let useCaseShopping: ShoppingCartUseCaseProtocol
    
    public var qtyProductsCart = BehaviorRelay<String>(value: "")


// MARK: - Init

    init(useCase: ProductListUseCaseProtocol, useCaseShopping: ShoppingCartUseCaseProtocol) {
        self.useCase = useCase
        self.useCaseShopping = useCaseShopping
        self.arrOfTrendsKeyword.accept(["Easter", "Chocolate", "Heinz", "Test", "Jaewon"])
    }

// MARK: - Methods

    func fetchTopSales() {
        useCase.fetchProductList(with: "", by: "name", false, filters: [String:Any]())
            .subscribe(onSuccess: { (product) in
            self.arrOfTopSalesProduct.accept(product)
            }
            , onError: { (err) in print(err) })
            .disposed(by: disposeBag)
    }
    
    func fetchProductYouMayLike() {
        useCase.fetchProductList(with: "", by: "name", true, filters: [String:Any]())
            .subscribe(onSuccess: { (product) in
                self.arrOfProductYouMayLike.accept(product)
            }
                , onError: { (err) in print(err) })
            .disposed(by: disposeBag)
    }
    
    func fetchNewProducts() {
        useCase.fetchProductList(with: "", by: "brand", true, filters: [String:Any]())
            .subscribe(onSuccess: { (product) in
                self.arrOfNewProducts.accept(product)
            }
                , onError: { (err) in print(err) })
            .disposed(by: disposeBag)
    }
    
    func addProductShoppingCart(with shoppingCart: ShoppingCart){
        useCaseShopping.addProductShoppingCart(shoppingCart: shoppingCart)
            .subscribe(
                onCompleted: { self.fetchShoppingCartQty() },
                onError: { error in self.setError(error) }
            ).disposed(by: disposeBag)
    }
    
    func fetchShoppingCartQty() {
        useCaseShopping.fetchShoppingCart().subscribe(onSuccess: { (product) in
            self.qtyProductsCart.accept(String(product.count))
            print(self.qtyProductsCart.value)
        }, onError: { (err) in
            print(err)
        })
    }

    func productAlreadyInCart(with primaryKey: String)-> Bool {
        var result = false
        let realm = try! Realm()
        let shoppingCartExist = realm.objects(ShoppingCartEntity.self).filter("idProducts = '\(primaryKey)'")
        if shoppingCartExist.first != nil {
            result = true
        }
        return result
    }
}
