//
//  ProductDetailViewModel.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/05.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ProductDetailViewModel : BaseViewModel {
    // MARK: - BehaviorRelay
    // Overview
    var images = BehaviorRelay<[String]>(value: [])
    var name = BehaviorRelay(value: "")
    var price = BehaviorRelay(value: "")
    var originalPrice = BehaviorRelay(value: "")
    var discountRate = BehaviorRelay(value: "")
    
    // Review
    var reviewAverage = BehaviorRelay(value: 0.0)
    var reviewNum = BehaviorRelay(value: "(0)")
    
    var review1Title = BehaviorRelay(value: "")
    var review1User = BehaviorRelay(value: "")
    var review1Rating = BehaviorRelay(value: 0.0)
    var review1Comment = BehaviorRelay(value: "")
    var review2Title = BehaviorRelay(value: "")
    var review2User = BehaviorRelay(value: "")
    var review2Rating = BehaviorRelay(value: 0.0)
    var review2Comment = BehaviorRelay(value: "")
    var reviewMore = BehaviorRelay(value: false)
    
    var description = BehaviorRelay(value: "")
    
    var frequentlyPurchasedWith = BehaviorRelay<[Product]>(value: [])
    var relatedTo = BehaviorRelay<[Product]>(value: [])
    
    var numOfProduct = BehaviorRelay(value: 1)
    
    var numOfProducntInShoppingCart = BehaviorRelay(value: 0)
    var onCompleteAddingMessage = BehaviorRelay(value: "")
    
    // MARK: - Private Properties
    private let useCase: ProductDetailUseCaseProtocol
    private let shoppingCartUseCase: ShoppingCartUseCaseProtocol
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Initializer
    init(useCase: ProductDetailUseCaseProtocol, shoppingCartUseCase: ShoppingCartUseCaseProtocol) {
        self.useCase = useCase
        self.shoppingCartUseCase = shoppingCartUseCase
    }
    
    // MARK: - Public Fuctions
    func fetchProductDetail(_ productId: String) {
        useCase.fetchProductDetail(productId)
            .subscribe(
                onSuccess: { model in self.setValues(of: model) },
                onError: { error in self.setError(error) }
            ).disposed(by: disposeBag)
    }
    
    func fetchFrequentlyPurchasedWith(_ productId: String) {
        useCase.fetchFrequentlyPurchasedWith(productId)
            .subscribe(
                onSuccess: { models in
                    self.frequentlyPurchasedWith.accept(models) },
                onError: { error in self.setError(error) }
            ).disposed(by: disposeBag)
    }
    
    func fetchRelatedTo(_ productId: String) {
        useCase.fetchRelatedTo(productId)
            .subscribe(
                onSuccess: { models in
                    self.relatedTo.accept(models) },
                onError: { error in self.setError(error) }
            ).disposed(by: disposeBag)
    }
    
    func changeNumOfProduct(isIncrement: Bool) {
        if isIncrement {
            if numOfProduct.value >= 99 { return }
            numOfProduct.accept(numOfProduct.value + 1)
        } else {
            if numOfProduct.value <= 1 { return }
            numOfProduct.accept(numOfProduct.value - 1)
        }
    }
    
    func addToCart(_ productId: String) {
        let shoppingCart = ShoppingCart()
        shoppingCart.idProducts = productId
        shoppingCart.quantity = numOfProduct.value
        shoppingCartUseCase.addProductShoppingCart(shoppingCart: shoppingCart)
            .subscribe(
                onCompleted: { self.onCompleteAddingToCart() },
                onError: { error in self.setError(error) })
            .disposed(by: disposeBag)
    }
    
    func fetchShoppingCartQty() {
        shoppingCartUseCase.fetchShoppingCart()
            .subscribe(
                onSuccess: { products in
                    self.numOfProducntInShoppingCart.accept(products.count) },
                onError: { error in self.setError(error) }
        ).disposed(by: disposeBag)
    }

    // MARK: - Private Fuctions
    private func setValues(of model: Product) {
        self.images.accept(model.images)
        self.name.accept(model.name)
        self.price.accept(String(format: "$%0.2f", model.price))
        self.originalPrice.accept(String(format: "$%0.2f", model.originalPrice))
        if model.discountPercent == 0 {
            discountRate.accept("")
        } else {
            discountRate.accept("↓\(model.discountPercent)%")
        }
        
        // Review
        self.reviewAverage.accept(round(model.averageRating * 10) / 10)
        
        if let reviews = model.reviews {
            reviewNum.accept("(\(reviews.count))")
            if reviews.count == 1 {
                setValuesToReview1(reviews[0])
            } else if reviews.count >= 2 {
                setValuesToReview1(reviews[0])
                setValuesToReview2(reviews[1])
                if reviews.count >= 3 { self.reviewMore.accept(true) }
            }
        }
        
        self.description.accept(model.description)
    }
    
    private func setValuesToReview1(_ review: Review) {
        self.review1User.accept(review.userName)
        self.review1Title.accept(review.title ?? "")
        self.review1Rating.accept(review.rating)
        self.review1Comment.accept(review.comment ?? "")
    }
    
    private func setValuesToReview2(_ review: Review) {
        self.review2User.accept(review.userName)
        self.review2Title.accept(review.title ?? "")
        self.review2Rating.accept(review.rating)
        self.review2Comment.accept(review.comment ?? "")
    }
    
    private func onCompleteAddingToCart() {
        onCompleteAddingMessage.accept("Succeed to add!")
    }
}
