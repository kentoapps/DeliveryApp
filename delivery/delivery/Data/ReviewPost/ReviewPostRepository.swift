//
//  ReviewPostRepository.swift
//  delivery
//
//  Created by Kento Uchida on 2018/05/11.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ReviewPostRepositoryProtocol {
    func fetchReview(productId: String) -> Single<ReviewEntity>
    func postReivew(productId: String, userName: String, rating: Double, title: String, comment: String) -> Completable
}

class ReviewPostRepository: ReviewPostRepositoryProtocol {
    private let dataStore: ReviewPostDataStoreProtocol
    
    init(dataStore: ReviewPostDataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    func fetchReview(productId: String) -> Single<ReviewEntity> {
        return dataStore.fetchReview(productId: productId)
    }
    
    func postReivew(productId: String, userName: String, rating: Double, title: String, comment: String) -> Completable {
        return dataStore.postReview(productId: productId, userName: userName, rating: rating, title: title, comment: comment)
    }
}

