//
//  ReviewPostDataStoreProtocol.swift
//  delivery
//
//  Created by Kento Uchida on 2018/05/11.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ReviewPostDataStoreProtocol {
    func fetchReview(productId: String) -> Single<ReviewEntity>
    func postReview(productId: String, userName: String, rating: Double, title: String, comment: String) -> Completable
}
