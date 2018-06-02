//
//  ReviewListRepository.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/23.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ReviewListRepositoryProtocol {
    func fetchReviewList(productId: String) -> Single<[ReviewEntity]>
}

class ReviewListRepository: ReviewListRepositoryProtocol {
    private let dataStore: ReviewListDataStoreProtocol
    
    init(dataStore: ReviewListDataStoreProtocol) {
        self.dataStore = dataStore
    }
    
    func fetchReviewList(productId: String) -> Single<[ReviewEntity]> {
        return dataStore.fetchReviewList(productId: productId)
    }
}
