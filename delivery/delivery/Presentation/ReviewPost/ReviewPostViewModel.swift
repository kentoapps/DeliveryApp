//
//  ReviewPostViewModel.swift
//  delivery
//
//  Created by Kento Uchida on 2018/05/11.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ReviewPostViewModel: BaseViewModel {
    
    var rating = BehaviorRelay<Double>(value: 0.0)
    var userName = BehaviorRelay<String>(value: "")
    var title = BehaviorRelay<String>(value: "")
    var comment = BehaviorRelay<String>(value: "")
    var isComplete = BehaviorRelay<Bool>(value: false)
    
    private let useCase: ReviewPostUseCaseProtocol
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(useCase: ReviewPostUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func fetchReview(productId: String) {
        useCase.fetchReview(productId: productId)
            .subscribe(
                onSuccess: { review in self.setReview(review: review) },
                onError: { error in self.setError(error) }
            ).disposed(by: disposeBag)
    }
    
    func postReivew(productId: String, userName: String?, rating: Double, title: String?, comment: String?) {
        useCase.postReivew(productId: productId, userName: userName, rating: rating, title: title, comment: comment)
            .subscribe(
                onCompleted: { self.isComplete.accept(true) },
                onError: { error in self.setError(error) }
        ).disposed(by: disposeBag)
    }
    
    private func setReview(review: Review) {
        rating.accept(review.rating)
        userName.accept(review.userName)
        title.accept(review.title ?? "")
        comment.accept(review.comment ?? "")
    }
}

