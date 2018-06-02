//
//  ReviewListFirebaseDataStore.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/23.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import Firebase
import RxSwift
import RxCocoa

class ReviewListFirebaseDataStore: ReviewListDataStoreProtocol {

    private let db = Firestore.firestore()
    
    func fetchReviewList(productId: String) -> Single<[ReviewEntity]> {
        return Single<[ReviewEntity]>.create { observer -> Disposable in
            self.db.collection(PRODUCT_COLLECTION)
                .document(productId)
                .collection(REVIEW_COLLECTION)
                .getDocuments(completion: { (documents, error) in
                    if let error = error {
                        observer(.error(error))
                        return
                    }
                    guard let docs = documents?.documents else {
                        observer(.error(NomnomError.alert(message: "Failed to get data")))
                        return
                    }
                    
                    var reviews: [ReviewEntity] = []
                    for doc in docs {
                        if let review = ReviewEntity(dictionary: (doc.data())) {
                            reviews.append(review)
                        }
                    }
                    observer(.success(reviews))
            })
            return Disposables.create()
        }
    }
}
