//
//  UserRepository.swift
//  delivery
//
//  Created by Sara N on 2018-03-12.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift

protocol UserRepositoryProtocol {
    func signUp(email: String, password: String) -> Completable
    func fetchUser() -> Single<UserEntity>
    func fetchAddress(index: Int) -> Single<[AddressEntity]>
    func fetchAddressList() -> Single<[AddressEntity]>
    func addAddress(address: AddressEntity) -> Completable
    func updateAddress(address: AddressEntity, indexNo: Int) -> Completable
    func updateAddressList(address: [AddressEntity]) -> Completable
    func updateUser(user: UserEntity) -> Completable
    func signIn(email: String, password: String) -> Completable
    func forgotPassword(email: String) -> Completable
    func signOut() -> Completable
    func updateUser(user: UserEntity, password: String) -> Completable
    func changePassword(currentPW: String, newPW: String) -> Completable
    func goToPayment() -> Completable
}

class UserRepository: UserRepositoryProtocol {    
    
    private let dataStore: UserDataStoreProtocol
    private let guestDataStore: GuestDataStoreProtocol
    private static var user: UserEntity? = nil

    init(dataStore: UserDataStoreProtocol, guestDataStore: GuestDataStoreProtocol) {
        self.dataStore = dataStore
        self.guestDataStore = guestDataStore
    }
    
    func signUp(email: String, password: String) -> Completable {
        return dataStore.signUp(email: email, password: password)
    }
    
    func fetchUser() -> Single<UserEntity> {
        return dataStore.fetchUser()
            .catchError { (error) in
                switch error {
                case NomnomError.noData:
                    return self.guestDataStore.fetchGuest()
                default:
                    return Single.error(error)
                }
            }
            .do(onSuccess: { user in
                UserRepository.user = user
                print(UserRepository.user)
            })
    }
    
    func fetchAddress(index: Int) -> Single<[AddressEntity]> {
        var arrWithOneElement: [AddressEntity] = []
        
        if let user = UserRepository.user {
            arrWithOneElement.append(user.address![index])
            return Single.just(arrWithOneElement)
        } else {
            return fetchUser()
                .map{ user in
                    UserRepository.user = user
                    arrWithOneElement.append(user.address![index])
                    return arrWithOneElement }
        }
    }
    
    func fetchAddressList() -> Single<[AddressEntity]> {
            return fetchUser()
                .map{ user in
                    UserRepository.user = user
                    return user.address!
            }
    }
    
    func addAddress(address: AddressEntity) -> Completable {
        print(UserRepository.user)
        if let isMember = UserRepository.user?.isMember {
            if isMember {
                let originalAddress = UserRepository.user?.address
                
                if let originalAddress = UserRepository.user?.address {
                    let updatedAddress = originalAddress.map({ address in
                        AddressEntity(receiver: address.receiver, address1: address.address1, address2: address.address2, city: address.city, province: address.province, postalCode: address.postalCode, country: address.country, isDefault: false, phoneNumber: address.phoneNumber)
                    })
                    UserRepository.user?.address = updatedAddress
                    UserRepository.user?.address!.append(address)
                } else {
                    UserRepository.user?.address = [address]
                }
            }
            
            return dataStore.updateUser(updatedUser: UserRepository.user!)
                .catchError { (error) in
                    switch error {
                    case NomnomError.noData:
                        return self.guestDataStore.saveGuestAddress(guestAddress: address)
                    default:
                        return Completable.error(error)
                    }
            }
        } else {
            return self.guestDataStore.saveGuestAddress(guestAddress: address)
        }
    }
    
    func updateAddress(address: AddressEntity, indexNo: Int) -> Completable {
        let originalAddress = UserRepository.user?.address
        
        let updatedAddress = originalAddress?.map({ address in
            AddressEntity(receiver: address.receiver, address1: address.address1, address2: address.address2, city: address.city, province: address.province, postalCode: address.postalCode, country: address.country, isDefault: false, phoneNumber: address.phoneNumber)
        })
        
        UserRepository.user?.address = updatedAddress!
        UserRepository.user?.address!.remove(at: indexNo)
        UserRepository.user?.address!.insert(address, at: indexNo)        
        return dataStore.updateUser(updatedUser: UserRepository.user!)
                .catchError { (error) in
                    switch error {
                    case NomnomError.noData:
                        return self.guestDataStore.saveGuestAddress(guestAddress: address)
                    default:
                        return Completable.error(error)
                    }
                }
    }
    
    func updateAddressList(address: [AddressEntity]) -> Completable {
        
        let updatedUser = UserEntity(firstName: (UserRepository.user?.firstName)!, lastName: (UserRepository.user?.lastName)!, mobileNumber: (UserRepository.user?.mobileNumber)!, dateOfBirth: UserRepository.user?.dateOfBirth, isMember: true, totalPoint: (UserRepository.user?.totalPoint)!, email: (UserRepository.user?.email)!, address: address, payment: (UserRepository.user?.payment) != nil ? (UserRepository.user?.payment)! : nil , coupon: UserRepository.user?.coupon)
        
        return dataStore.updateUser(updatedUser: updatedUser)
    }
    
    func updateUser(user: UserEntity) -> Completable {
        if !Validation.validateEmail(email: user.email!) {
            return Completable.error(NomnomError.invalidInput(message: "wrong format"))
        }
        
        return dataStore.updateUser(updatedUser: user)
            .catchError { (error) in
                switch error {
                case NomnomError.noData:
                    return self.guestDataStore.saveGuestInfo(userEntity: user)
                default:
                    return Completable.error(error)
                }
            }
    }
    
    func signIn(email: String, password: String) -> Completable {
        return dataStore.signIn(email: email, password: password)
    }
    
    func forgotPassword(email: String) -> Completable {
        return dataStore.forgotPassword(email: email)
    }
    
    func signOut() -> Completable {
        return dataStore.signOut()
    }
    
    func updateUser(user: UserEntity, password: String) -> Completable {
        return dataStore.updateUser(user: user, password: password)
    }
    
    func changePassword(currentPW: String, newPW: String) -> Completable {
        return dataStore.changePassword(currentPW: currentPW, newPW: newPW)
    }
    
    func goToPayment() -> Completable {
        if UserRepository.user?.address != nil && !(UserRepository.user?.mobileNumber?.isEmpty)! && !(UserRepository.user?.firstName?.isEmpty)! && !(UserRepository.user?.lastName?.isEmpty)! {
            return Completable.create { observer in
                observer(.completed)
                return Disposables.create()
            }
        } else {
            return Completable.error(NomnomError.alert(message: "Please enter all the required information!"))
        }
    }
}




