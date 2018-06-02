//
//  GuestDataStore.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-05-20.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import Realm
import RealmSwift
import RxCocoa
import RxRealm

class GuestDataStore: GuestDataStoreProtocol {
    func saveGuestInfo(userEntity: UserEntity) -> Completable {
        let guestToSave = self.mapToGuestInfoEntity(userEntity: userEntity)
        
        let realm = RealmManager.sharedInstance
//        guestToSave.id = realm.getNewId(type: GuestInfoEntity.self)!
        realm.addData(object: guestToSave)
        print("realm!")
        return Completable.create(subscribe: { (observer) -> Disposable in
            if realm.getData(type: GuestInfoEntity.self)?.count != 0 {
                    observer(.completed)
                } else {
                    observer(.error(NomnomError.noData(message: "Failed to write a data")))
                }
            return Disposables.create()
        })
    }
    
    func fetchGuest() -> Single<UserEntity> {
        print("GuestDataStore before return")
        return Single<UserEntity>
         .zip(fetchGuestInfo(), fetchGuestAddress()) { (info, address) in
            return UserEntity(firstName: info?.firstName ?? nil,
                              lastName: info?.lastName ?? nil,
                              mobileNumber: info?.mobileNumber ?? nil,
                              dateOfBirth: nil,
                              isMember: false,
                              totalPoint: 0,
                              email: info?.email ?? nil,
                              address: self.mapToAddress(address),
                              payment: nil,
                              coupon: nil)
        }
        
    }
    
    func fetchGuestInfo() -> Single<GuestInfoEntity?> {
        let realm = RealmManager.sharedInstance
        
        return Single<GuestInfoEntity?>.create { observer -> Disposable in
            let dispose = Disposables.create()
            
            guard let data = realm.getData(type: GuestInfoEntity.self) else {
                observer(.error(NomnomError.noData(message: "Failed to fetch the data from Realm")))
                return dispose
            }
            
            if data.count != 0 {
                let data = realm.getData(type: GuestInfoEntity.self)
                
                let guestInfoEntity = data![data!.endIndex-1] as! GuestInfoEntity
                observer(.success(guestInfoEntity))
            }
            else {
                observer(.success(nil))
            }
        return dispose
        }
    }
    
    func fetchGuestAddress() -> Single<GuestAddressEntity?> {
        let realm = RealmManager.sharedInstance
        
        return Single<GuestAddressEntity?>.create { observer -> Disposable in
            //            if let data = realm.getData(type: GuestInfoEntity.self) {
            let dispose = Disposables.create()
            
            guard let data = realm.getData(type: GuestAddressEntity.self) else {
                observer(.error(NomnomError.noData(message: "Failed to fetch the data from Realm")))
                return dispose
            }
            
            if data.count != 0 {
                let data = realm.getData(type: GuestAddressEntity.self)
                
                let guestAddressEntity = data![data!.endIndex-1] as! GuestAddressEntity
                observer(.success(guestAddressEntity))
            } else {
                observer(.success(nil))
            }
            
            return dispose
        }
    }
    
    func saveGuestAddress(guestAddress: AddressEntity) -> Completable {
        let addressToSave = self.mapToGuestAddress(addressEntity: guestAddress)
        
        print(addressToSave)
        let realm = RealmManager.sharedInstance
//        addressToSave.id = realm.getNewId(type: GuestAddressEntity.self)!
        realm.addData(object: addressToSave)
        print("realm!")
        return Completable.create(subscribe: { (observer) -> Disposable in
            if realm.getData(type: GuestAddressEntity.self)?.count != 0 {
                observer(.completed)
            } else {
                observer(.error(NomnomError.noData(message: "Failed to write a data")))
            }
            return Disposables.create()
        })
    }
    
    private func mapToAddress(_ guestAddress: GuestAddressEntity?) -> [AddressEntity]? {
        // TODO: JAEWON NO SHIGOTO
        guard let guestAddress = guestAddress else { return nil }
        
        return [AddressEntity(receiver: guestAddress.receiver, address1: guestAddress.address1, address2: guestAddress.address2, city: guestAddress.city, province: guestAddress.province, postalCode: guestAddress.postalCode, country: guestAddress.country, isDefault: guestAddress.isDefault, phoneNumber: guestAddress.phoneNumber)]
    }
    
    private func mapToGuestInfoEntity(userEntity: UserEntity) -> GuestInfoEntity {
        let guestInfoEntity = GuestInfoEntity()
        guestInfoEntity.firstName = userEntity.firstName!
        guestInfoEntity.lastName = userEntity.lastName!
        guestInfoEntity.mobileNumber = userEntity.mobileNumber!
        guestInfoEntity.email = userEntity.email!
        return guestInfoEntity
    }
    
    private func mapToGuestAddress(addressEntity: AddressEntity) -> GuestAddressEntity {
        let guestAddressEntity = GuestAddressEntity()
        guestAddressEntity.address1 = addressEntity.address1
        guestAddressEntity.address2 = addressEntity.address2
        guestAddressEntity.city = addressEntity.city
        guestAddressEntity.country = addressEntity.country
        guestAddressEntity.isDefault = addressEntity.isDefault
        guestAddressEntity.phoneNumber = addressEntity.phoneNumber
        guestAddressEntity.postalCode = addressEntity.postalCode
        guestAddressEntity.province = addressEntity.province
        guestAddressEntity.receiver = addressEntity.receiver
        return guestAddressEntity
    }
}
