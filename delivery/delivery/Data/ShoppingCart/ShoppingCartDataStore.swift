//
//  ShoppingCartDataStore.swift
//  delivery
//
//  Created by Bacelar on 2018-04-05.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import Realm
import RealmSwift
import RxCocoa
import RxRealm
import Firebase

class ShoppingCartDataStore: ShoppingCartDataStoreProtocol {
    let db = Firestore.firestore()
    
    func deleteProductFromShoppingCart(with primaryKey: String) -> Completable {
        return Completable.create { observer in
            let realm = try! Realm()
            let cart = realm.objects(ShoppingCartEntity.self).filter("idProducts = '\(primaryKey)'")
            
            try! realm.write {
                realm.delete(cart)
            }
            observer(.completed)
            return Disposables.create()
        }
    }
    
    func deleteShoppingCart() -> Completable {
        let realm = RealmManager.sharedInstance
        return Completable.create { observer in
            let realm = RealmManager.sharedInstance
            realm.deleteAllFromDatabase()
            observer(.completed)
            return Disposables.create()
        }
    }
    
    func addProductShoppingCart(shoppingCart: ShoppingCartEntity) -> Completable {
        return Completable.create { observer in
            let realm = RealmManager.sharedInstance
            print("Realm - \(shoppingCart.id)")
            
            shoppingCart.id = realm.getNewId(type: ShoppingCartEntity.self)!
            realm.addData(object: shoppingCart)
            observer(.completed)
            return Disposables.create()
        }
    }
    
    func updateProductShoppingCart(shoppingCart: ShoppingCartEntity) -> Completable {
        return Completable.create { observer in
            let realm = RealmManager.sharedInstance
            print("Realm - \(shoppingCart.id)")
            
            let realmUpdate = try! Realm()
            let cart = realmUpdate.objects(ShoppingCartEntity.self).filter("idProducts = '\(shoppingCart.idProducts)'")
            
            shoppingCart.id = cart[0].id
            
            realm.updateData(object: shoppingCart)
            observer(.completed)
            return Disposables.create()
        }
    }
    
    func productAlreadyInCart(with primaryKey: String) -> Bool {
        var result = false
        let realm = try! Realm()
        let shoppingCartExist = realm.objects(ShoppingCartEntity.self).filter("idProducts = '\(primaryKey)'")
        if shoppingCartExist.first != nil {
            result = true
        }
        return result
    }
    
    func fetchShoppingCart() -> Single<[ProductShoppingCartEntity]> {
        let realm = RealmManager.sharedInstance
        
        return Single<[ProductShoppingCartEntity]>.create { observer -> Disposable in
            
            var arr = [ProductShoppingCartEntity]()
            var counter = 0
            guard let data = realm.getData(type: ShoppingCartEntity.self) else {
                observer(.success([]))
                return Disposables.create()
            }
            let size = data.count
            if size == 0 {
                observer(.success([]))
                return Disposables.create()
            }
            for carItem in data {
                
                let cartItem = carItem as! ShoppingCartEntity
                
                self.db.collection(PRODUCT_COLLECTION)
                    .document(cartItem.idProducts)
                    .getDocument { (document, error) in
                        if let error = error {
                            observer(.error(NomnomError.network(code: "", message: ErrorMsg.tryAgain, log: error.localizedDescription)))
                            return
                        }
                        
                        if let product = ProductEntity(docId: (document?.documentID)!, dictionary: (document?.data())!)
                        {
                            arr.append(ProductShoppingCartEntity(product: product,quantity: cartItem.quantity))
                            
                        }
                        else {
                            observer(.error(NomnomError.alert(message: "Parse Failure")))
                            return
                        }
                        counter = counter + 1
                        if counter >= size {
                            observer(.success(arr))
                        }
                }
            }
            return Disposables.create()
        }
    }
}

