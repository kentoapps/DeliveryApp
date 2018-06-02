//
//  ProductDetailFirebaseDataStore.swift
//  delivery
//
//  Created by Kento Uchida on 2018/02/24.
//  Copyright © 2018 CICCC. All rights reserved.
//
import Foundation
import Firebase
import RxSwift

class ProductDetailFirebaseDataStore: ProductDetailDataStoreProtocol {
    
    private let db = Firestore.firestore()
    
    func fetchProductDetail(_ productId: String) -> Single<ProductEntity> {
        let productRef = db.collection(PRODUCT_COLLECTION).document(productId)
        return Single<ProductEntity>.create { observer -> Disposable in
            self.db.runTransaction({ (transaction, errorPointer) -> Any? in
                
                let productDoc: DocumentSnapshot
                do {
                    try productDoc = transaction.getDocument(productRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }
                guard var product = ProductEntity(docId: productDoc.documentID, dictionary: productDoc.data()!) else {
                    observer(.error(NomnomError.alert(message: "Parse Failure")))
                    return nil
                }
                let collection = productDoc.reference.collection("review")
                collection.addSnapshotListener({ (querySnapshot, error) in
                    guard let snapshot = querySnapshot else {
                        print("Error fetching snapshot results: \(error!)")
                        observer(.success(product))
                        return
                    }
                    
                    let reviews = snapshot.documents
                        .map { ReviewEntity(dictionary: $0.data()) }
                        .filter { $0 != nil } as! [ReviewEntity]
                    product.reviews = reviews
                    observer(.success(product))
                })
                
                return nil
            }, completion: { (product, error) in
            })
            return Disposables.create()
        }
    }
    
    func fetchFrequentlyPurchasedWith(_ productId: String) -> Single<[ProductEntity]> {
        return Single<[ProductEntity]>.create { observer -> Disposable in
            self.db.collection(PRODUCT_COLLECTION).limit(to: 5).getDocuments { (documents, error) in
                if let error = error {
                    observer(.error(error))
                    return
                }
                guard let docs = documents?.documents else {
                    observer(.error(NomnomError.alert(message: "Failed to get data")))
                    return
                }
                
                var products: [ProductEntity] = []
                for doc in docs {
                    if let product = ProductEntity(docId: doc.documentID, dictionary: (doc.data())) {
                        products.append(product)
                    }
                }
                observer(.success(products))
            }
            return Disposables.create()
        }
    }
    
    func fetchRelatedTo(_ productId: String) -> Single<[ProductEntity]> {
        return Single<[ProductEntity]>.create { observer -> Disposable in
            self.db.collection(PRODUCT_COLLECTION).limit(to: 4).getDocuments { (documents, error) in
                if let error = error {
                    observer(.error(error))
                    return
                }
                guard let docs = documents?.documents else {
                    observer(.error(NomnomError.alert(message: "Failed to get data")))
                    return
                }
                
                var products: [ProductEntity] = []
                for doc in docs {
                    if let product = ProductEntity(docId: doc.documentID, dictionary: (doc.data())) {
                        products.append(product)
                    }
                }
                observer(.success(products))
            }
            return Disposables.create()
        }
    }
}
