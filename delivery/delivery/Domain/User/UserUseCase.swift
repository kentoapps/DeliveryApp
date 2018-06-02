//
//  UserUseCaseProtocol.swift
//  delivery
//
//  Created by Sara N on 2018-03-12.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift

protocol UserUseCaseProtocol {
    func fetchUser() -> Single<User>
    func updateUser(user: User) -> Completable
    func fetchAddressList() -> Single<[Address]>
    func updateAddressList(addressList: [Address]) -> Completable
    func fetchAddress(index: Int) -> Single<[Address]>
    func addAddress(address: Address) -> Completable
    func updateAddress(address: Address, indexNo: Int) -> Completable
    func signUp(email: String, password: String, confirm: String) -> Completable
    func signIn(email: String, password: String) -> Completable
    func forgotPassword(email: String) -> Completable
    func signOut() -> Completable
    func updateUser(user: User, password: String) -> Completable
    func changePassword(currentPW: String, confirmedPW: String, newPW: String) -> Completable
    func goToPayment() -> Completable

}

class UserUseCase: UserUseCaseProtocol {
    
    internal let repository: UserRepositoryProtocol
    internal let translator: UserTranslator
    
    init(repository: UserRepositoryProtocol, translator: UserTranslator) {
        self.repository = repository
        self.translator = translator
    }
    
    func fetchUser() -> Single<User> {
        return repository.fetchUser()
            .map({ entity in
                self.translator.translate(fromEntity: entity)
            })
    }
    
    func updateUser(user: User) -> Completable {
        let updatedUser = translator.translate(fromModel: user)
        return repository.updateUser(user: updatedUser)
    }
    
    func fetchAddressList() -> Single<[Address]> {
        return repository.fetchAddressList()
            .map({ entity in
                self.translator.translateAddress(from: entity)
            })
    }
    
    func updateAddressList(addressList: [Address]) -> Completable {
        let addressList = addressList.map { self.translator.translateAddress(from: $0)}
        return repository.updateAddressList(address: addressList)
    }
    
    func fetchAddress(index: Int) -> Single<[Address]> {
        return repository.fetchAddress(index: index)
            .map({ entity in
                self.translator.translateAddress(from: entity)
            })
    }
    
    func addAddress(address: Address) -> Completable {
        let addressEntity = self.translator.translateAddress(from: address)
        return repository.addAddress(address: addressEntity)
    }
    
    func updateAddress(address: Address, indexNo: Int) -> Completable {
        let addressEntity = self.translator.translateAddress(from: address)
        return repository.updateAddress(address: addressEntity, indexNo: indexNo)
    }
    
    func signUp(email: String, password: String, confirm: String) -> Completable {
        if email.isEmpty, password.isEmpty, confirm.isEmpty {
            return Completable.error(NomnomError.alert(message: "Please fill out"))
        }
        var messageArray: [String] = []
        if !Validation.validateEmail(email: email) {
            messageArray.append("Email address is invalid")
        }
        if !Validation.validatePassword(password: password) {
            messageArray.append("Password is invalid")
        }
        if password != confirm {
            messageArray.append("Confirm password is differnt from Password")
        }
        if messageArray.count > 0 {
            let message = messageArray.joined(separator: "\n")
            return Completable.error(NomnomError.alert(message: message))
        }

        return repository.signUp(email: email, password: password)
    }
    
    func signIn(email: String, password: String) -> Completable {
        if Validation.validateEmail(email: email) && Validation.validatePassword(password: password) {
            return repository.signIn(email: email, password: password)
        }
        return Completable.error(NomnomError.alert(message: "wrong password!"))
    }
    
    func forgotPassword(email: String) -> Completable {
        return repository.forgotPassword(email: email)
    }
    
    func signOut() -> Completable {
        return repository.signOut()
    }
    
    func updateUser(user: User, password: String) -> Completable {
        if !Validation.validatePassword(password: password) {
            Completable.error(NomnomError.alert(message: "wrong password!"))
        }
        
        if !Validation.validateEmail(email: user.email!) {
            Completable.error(NomnomError.alert(message: "wrong email!"))
        }
        
        let updatedUser = translator.translate(fromModel: user)
        return repository.updateUser(user: updatedUser, password: password)
    }
    
    func changePassword(currentPW: String, confirmedPW: String, newPW: String) -> Completable {
        var messageArray: [String] = []

        if !Validation.validatePassword(password: newPW) {
            messageArray.append("Password is invalid")
        }
        if currentPW != confirmedPW {
            messageArray.append("Confirm password is differnt from Password")
        }
        if messageArray.count > 0 {
            let message = messageArray.joined(separator: "\n")
            return Completable.error(NomnomError.alert(message: message))
        }
        
        return repository.changePassword(currentPW: currentPW, newPW: newPW)
    }
    
    func goToPayment() -> Completable {
        return repository.goToPayment()
    }
}

