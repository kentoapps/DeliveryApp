//
//  UserUseCaseTest.swift
//  deliveryTests
//
//  Created by Kento Uchida on 2018/05/17.
//  Copyright © 2018 CICCC. All rights reserved.
//

import XCTest
import RxSwift
@testable import delivery

class UserUseCaseTest: XCTestCase {
    
    var useCase: UserUseCaseProtocol {
        return UserUseCase(repository: UserRepositoryMock(),
                           translator: UserTranslator())
    }
    
    override func setUp() {
        super.setUp()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testSignUp() {
        let useCase = self.useCase
        let exp = expectation(description: "sign up: onCompleted")
        
        _ = useCase.signUp(email: "a@a.com", password: "123qweasd", confirm: "123qweasd")
            .subscribe(
                onCompleted: { exp.fulfill() },
                onError: { error in XCTAssert(false, error.localizedDescription)}
        )
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testSignUp_empty() {
        let useCase = self.useCase
        let exp = expectation(description: "sign up: empty")
        
        _ = useCase.signUp(email: "", password: "", confirm: "")
            .subscribe(
                onCompleted: {  },
                onError: { error in exp.fulfill() }
        )
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testSignUp_confirmIsWrong() {
        let useCase = self.useCase
        let exp = expectation(description: "sign up: confirm is wrong")
        
        _ = useCase.signUp(email: "a@a.com", password: "123qweasd", confirm: "456qweasd")
            .subscribe(
                onCompleted: {  },
                onError: { error in exp.fulfill() }
        )
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
    
    func testSignUp_emailIsWrong() {
        let useCase = self.useCase
        let exp = expectation(description: "sign up: email is wrong")
        
        _ = useCase.signUp(email: "a@acom", password: "123qweasd", confirm: "1233qweasd")
            .subscribe(
                onCompleted: {  },
                onError: { error in exp.fulfill() }
        )
        
        waitForExpectations(timeout: 1.0, handler: nil)
    }
}

fileprivate final class UserRepositoryMock: UserRepositoryProtocol {
    func signIn(email: String, password: String) -> Completable {
        return Completable.empty()
    }
    
    func forgotPassword(email: String) -> Completable {
        return Completable.empty()
    }
    
    func signOut() -> Completable {
        return Completable.empty()
    }
    
    func signUp(email: String, password: String) -> Completable {
        return Completable.empty()
    }
    
    func fetchUser() -> PrimitiveSequence<SingleTrait, UserEntity> {
        return Single.just(UserEntity(firstName: "", lastName: "", mobileNumber: "", dateOfBirth: Date(), totalPoint: 0, email: "", address: nil, payment: nil, coupon: nil))
    }
    
    func fetchAddress(index: Int) -> PrimitiveSequence<SingleTrait, [AddressEntity]> {
        return Single.just([])
    }
    
    func fetchAddressList() -> PrimitiveSequence<SingleTrait, [AddressEntity]> {
        return Single.just([])
    }
    
    func addAddress(address: AddressEntity) -> Completable {
        return Completable.empty()
    }
    
    func updateAddress(address: AddressEntity, indexNo: Int) -> Completable {
        return Completable.empty()
    }
    
    func updateAddressList(address: [AddressEntity]) -> Completable {
        return Completable.empty()
    }
    
    func updateUser(user: UserEntity) -> Completable {
        return Completable.empty()
    }
    
    
}
