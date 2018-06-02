//
//  UserDataStoreProtocol.swift
//  delivery
//
//  Created by Sara N on 2018-03-12.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift

protocol UserDataStoreProtocol {
    func fetchUser() -> Single<UserEntity>
    func updateUser(updatedUser: UserEntity) -> Completable
    func updateAddress(address: AddressEntity) -> Completable
    func signUp(email: String, password: String) -> Completable
    func signIn(email: String, password: String) -> Completable
    func forgotPassword(email: String) -> Completable
    func signOut() -> Completable
    func updateUser(user: UserEntity, password: String) -> Completable
    func changePassword(currentPW: String, newPW: String) -> Completable
}
