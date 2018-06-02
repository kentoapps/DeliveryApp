//
//  ReviewPostUseCase.swift
//  delivery
//
//  Created by Kento Uchida on 2018/05/11.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ReviewPostUseCaseProtocol {
    func fetchReview(productId: String) -> Single<Review>
    func postReivew(productId: String, userName: String?, rating: Double, title: String?, comment: String?) -> Completable
}

class ReviewPostUseCase: ReviewPostUseCaseProtocol {
    private let repository: ReviewPostRepositoryProtocol
    private let translator: ReviewTranslator
    
    init(repository: ReviewPostRepositoryProtocol, translator: ReviewTranslator) {
        self.repository = repository
        self.translator = translator
    }
    
    func fetchReview(productId: String) -> Single<Review> {
        return repository.fetchReview(productId: productId)
            .map{ entitiy in self.translator.translate(entitiy) }
    }
    
    func postReivew(productId: String, userName: String?, rating: Double, title: String?, comment: String?) -> Completable {
        guard rating != 0, let userName = userName, !userName.isEmpty, let title = title, !title.isEmpty, let comment = comment, !comment.isEmpty else {
            return Completable.error(NomnomError.alert(message: "Please input properly"))
        }
        return repository.postReivew(productId: productId, userName: userName, rating: rating, title: title, comment: comment)
    }
}
