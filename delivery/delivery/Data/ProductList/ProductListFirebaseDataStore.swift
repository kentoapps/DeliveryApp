//
//  HomeFirebaseDataStore.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-03-12.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import Firebase
import RxSwift
import Stripe

class ProductListFirebaseDataStore: ProductListDataStoreProtocol {

    let db = Firestore.firestore()
    
    func fetchProductList(with keyword: String, by orderby: String, _ descending: Bool, filters: [String:Any]) -> Single<[ProductEntity]> {
        var arr = [ProductEntity]()
        return Single<[ProductEntity]>.create { observer -> Disposable in
                let products = self.db.collection("product").order(by: orderby, descending: descending)
                products.getDocuments { (documents, error) in
                if let error = error {
                    observer(.error(error))
                    return
                }
                    
                if let docs = documents?.documents {
                    for doc in docs {
                        let name = doc.data()["name"] as! String
                        
                        if !filters.isEmpty {
                            let discount = doc.data()["discountPercent"] as! Double
                            let price = doc.data()["price"] as! Double
                            var rating = 0.0
//                            if (doc.data()["averageRating"] as! Double) != nil {
//                                rating = doc.data()["averageRating"] as! Double
//                            }
                            

                            if (filters["priceRanceMin"] != nil)&&(filters["priceRanceMax"] != nil){
                                if price > (filters["priceRanceMax"] as! Double) {continue}
                                if price < (filters["priceRanceMin"] as! Double) {continue}
                            }
                            
                            if (filters["rating"] != nil){
                                if rating >= (filters["rating"] as! Double) {continue}
                            }
                            
                            if (filters["discount"] != nil){
                                if discount <= 0 {continue}
                            }
                        }
                        
                        
                        if keyword != "" {
                            if name.lowercased().range(of:keyword.lowercased()) != nil {
                                let product = ProductEntity(docId: doc.documentID, dictionary: (doc.data()))
                                arr.append(product!)
                            }
                        } else {
                            let product = ProductEntity(docId: doc.documentID, dictionary: (doc.data()))
                            arr.append(product!)
                        }
                    }
                }
                observer(.success(arr))
            }
            return Disposables.create()
        }
    }
}
