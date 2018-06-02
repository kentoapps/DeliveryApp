//
//  ReviewPostFirebaseDataStore.swift
//  delivery
//
//  Created by Kento Uchida on 2018/05/11.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

import Firebase
import RxSwift
import RxCocoa

class ReviewPostFirebaseDataStore: ReviewPostDataStoreProtocol {
    
    private let db = Firestore.firestore()
    private var reviewId: String?
    
    func fetchReview(productId: String) -> Single<ReviewEntity> {
        self.reviewId = nil
        guard let user = Auth.auth().currentUser else {
            return Single.error(NomnomError.alert(message: "Please sign in"))
        }
        return Single.create(subscribe: { observer in
            self.db.collection(PRODUCT_COLLECTION)
                .document(productId)
                .collection(REVIEW_COLLECTION)
                .whereField("userId", isEqualTo: user.uid)
                .getDocuments(completion: { (snapshot, error) in
                    if let error = error {
                        observer(.error(error))
                    } else {
                        guard let doc = snapshot?.documents, doc.count > 0 else {
                            observer(.error(NomnomError.noData(message: "NO DATA")))
                            return
                        }
                        guard let review = ReviewEntity(dictionary: doc[0].data()) else {
                            observer(.error(NomnomError.alert(message: "Parse Failure")))
                            return
                        }
                        self.reviewId = doc[0].documentID
                        observer(.success(review))
                    }
                })
            return Disposables.create()
        })
    }
    
    func postReview(productId: String, userName: String, rating: Double, title: String, comment: String) -> Completable {
        guard let user = Auth.auth().currentUser else {
            return Completable.error(NomnomError.alert(message: "You need to sign in"))
        }
        let review = ReviewEntity(comment: comment, rating: rating, title: title, userId: user.uid, userName: userName)
        
        let productRef = db.collection(PRODUCT_COLLECTION).document(productId)
        
        let reviewRef: DocumentReference
        if let reviewId = reviewId {
            reviewRef = productRef.collection(REVIEW_COLLECTION).document(reviewId)
        } else {
            reviewRef = productRef.collection(REVIEW_COLLECTION).document()
        }
        
        return Completable.create { observer -> Disposable in
            self.db.runTransaction({ (transaction, errorPointer) -> Any? in
                let productSnapshot: DocumentSnapshot
                do {
                    try productSnapshot = transaction.getDocument(productRef)
                } catch let error as NSError {
                    errorPointer?.pointee = error
                    return nil
                }
                
                guard let product = ProductEntity(docId: productSnapshot.documentID, dictionary: productSnapshot.data()!) else {
                    let error = NSError(domain: "FireEatsErrorDomain", code: 0, userInfo: [
                        NSLocalizedDescriptionKey: "Unable to write to restaurant at Firestore path: \(productRef.path)"
                        ])
                    errorPointer?.pointee = error
                    return nil
                }
                
                let newAverage = (Double(product.ratingCount) * product.averageRating + Double(review.rating)) / Double(product.ratingCount + 1)
                
                transaction.setData(review.dictionary, forDocument: reviewRef)
                transaction.updateData([
                    "ratingCount": product.ratingCount + 1,
                    "averageRating": newAverage
                    ], forDocument: productRef)
                return nil
            }, completion: { (object, error) in
                if let error = error {
                    observer(.error(error))
                } else {
                    observer(.completed)
                }
            })
            return Disposables.create()
        }
    }
}
