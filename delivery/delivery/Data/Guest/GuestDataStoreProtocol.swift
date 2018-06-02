//
//  GuestDataStoreProtocol.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-05-20.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift

protocol GuestDataStoreProtocol {
    func saveGuestInfo(userEntity: UserEntity) -> Completable
    func fetchGuestInfo() -> Single<GuestInfoEntity?>
    func fetchGuestAddress() -> Single<GuestAddressEntity?>
    func fetchGuest() -> Single<UserEntity>
    func saveGuestAddress(guestAddress: AddressEntity) -> Completable
}
