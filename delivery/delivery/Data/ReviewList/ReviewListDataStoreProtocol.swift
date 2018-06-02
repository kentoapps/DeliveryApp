//
//  ReviewListDataStoreProtocol.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/23.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

protocol ReviewListDataStoreProtocol {
    func fetchReviewList(productId: String) -> Single<[ReviewEntity]>
}
