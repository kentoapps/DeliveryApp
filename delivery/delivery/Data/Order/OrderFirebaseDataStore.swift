        //
//  DeliveryFirebaseDataStore.swift
//  delivery
//
//  Created by MATSUHISA MAI on 2018/03/12.
//  Copyright © 2018年 CICCC. All rights reserved.
//

import Foundation
import Firebase
import RxSwift
        
class OrderFirebaseDataStore: OrderDataStoreProtocol {
    
    let db = Firestore.firestore()

    func saveOrder(_ order: OrderEntity) -> Completable {
        guard let user = Auth.auth().currentUser else {
            return Completable.empty()
        }

        var orderDetail = [[String:Any]]()
        for item in order.orderDetail {
            
            orderDetail.append(["pricePerItem": item.pricePerItem,
                                "quantity": item.quantity,
                                "productId": item.productId,
                                "productImage": "https://images-na.ssl-images-amazon.com/images/I/61JPeeObrUL._SL1500_.jpg",
                                "productName": "Fanola"])
        }
        
        let pointStatement:[String:Any] = ["consumedPoints": order.pointStatement.consumedPoints,
                                           "earnedPoints": order.pointStatement.earnedPoints]
        
        let shippingAddress:[String:Any] = ["address1": order.shippingAddress.address1,
                                            "address2": order.shippingAddress.address2,
                                            "city": order.shippingAddress.city,
                                            "country": order.shippingAddress.country,
                                            "isDefault": order.shippingAddress.isDefault,
                                            "phoneNumber": order.shippingAddress.phoneNumber,
                                            "postalCode": order.shippingAddress.postalCode,
                                            "province": order.shippingAddress.province,
                                            "receiver": order.shippingAddress.receiver]
        
        let orderData: [String:Any] = ["cancelReason": order.cancelReason,
                                       "couponDiscount": 0,
                                       "deliveryFee": order.deliveryFee,
                                       "orderDetail": orderDetail,
                                       "orderNumber": order.orderNumber,
                                       "pointStatement":pointStatement,
                                       "remark": order.remark,
                                       "scheduledDeliveryDate": order.scheduledDeliveryDate,
                                       "shippingAddress": shippingAddress,
                                       "status": order.status,
                                       "totalPrice": order.totalPrice,
                                       "trackingNumber": order.trackingNumber,
                                       "userId": user.uid,
                                       "deliveryInfo": order.deliveryInfo]

        return Completable.create { completable in

            self.db.collection(ORDER_COLLECTION)
                .addDocument(data: orderData) { err in
                    if let err = err {
                        print("error")
                        completable(.error(NomnomError.alert(message: "Failed for some reasons!\n\(err.localizedDescription)")))
                    } else {
                        print("completed")
                        completable(.completed)
                    }
            }
            return Disposables.create()
        }
    }

    func fetchOrder(with userId: String) -> Single<[OrderEntity]>{
        guard let user = Auth.auth().currentUser else {
            return Single.error(NomnomError.noData(message: "Not Sign In"))
        }
        var arr = [OrderEntity]()
        return Single<[OrderEntity]>.create { observer -> Disposable in
                self.db.collection("order")
                    .whereField("userId", isEqualTo: user.uid)
                    .getDocuments{(documents, error) in
                if let error = error {
                    observer(.error(error))
                    return
                }
                if let docs = documents?.documents {
                    for doc in docs {
                        let order = OrderEntity(docId: doc.documentID, dictionary: doc.data())
                        print(order!.deliveryInfo.count) //all variables
                        arr.append(order!)
                    }
                }
                observer(.success(arr))
            }
            return Disposables.create()
        }
    }
    
    func fetchOrderDetail(with orderId: String) -> Single<OrderEntity> {
        return Single<OrderEntity>.create( subscribe: { observer in
            self.db
                .collection("order")
                .document(orderId)
                .getDocument(completion: { (snapshot, error) in
                    if let error = error {
                        observer(.error(error))
                    } else{
                        guard let doc = snapshot?.data() else{
                            observer(.error(NomnomError.alert(message: "no data")))
                            return
                        }
                        guard let order = OrderEntity(docId: orderId, dictionary: doc)
                            else{
                                observer(.error(NomnomError.alert(message: "Parse Failure")))
                                return
                        }
                        observer(.success(order))
                        
                    }
                })
            return Disposables.create()
        })
    }

    
}
