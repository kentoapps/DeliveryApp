//
//  ReviewListViewModel.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/23.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ReviewListViewModel: BaseViewModel {
    var reviewList = BehaviorRelay<[Review]>(value: [])
    
    private let useCase: ReviewListUseCaseProtocol
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(useCase: ReviewListUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func fetchReviewList(productId: String) {
        useCase.fetchReviewList(productId: productId)
            .subscribe(
                onSuccess: { reviews in self.reviewList.accept(reviews) },
                onError: { error in self.setError(error)}
        ).disposed(by: disposeBag)
    }
}
