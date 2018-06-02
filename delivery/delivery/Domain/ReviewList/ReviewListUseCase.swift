//
//  ReviewListUseCase.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/23.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ReviewListUseCaseProtocol {
    func fetchReviewList(productId: String) -> Single<[Review]>
}

class ReviewListUseCase: ReviewListUseCaseProtocol {
    private let repository: ReviewListRepositoryProtocol
    private let translator: ReviewTranslator
    
    init(repository: ReviewListRepositoryProtocol, translator: ReviewTranslator) {
        self.repository = repository
        self.translator = translator
    }
    
    func fetchReviewList(productId: String) -> Single<[Review]> {
        return repository.fetchReviewList(productId: productId)
            .map({ entity in
                self.translator.translate(entity)
            })
    }
}
