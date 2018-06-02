//
//  UserInfoEditViewModel.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-04-26.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class UserInfoEditViewModel: BaseViewModel {

    var firstName = BehaviorRelay(value: "")
    var lastName = BehaviorRelay(value: "")
    var email = BehaviorRelay(value: "")
    var phoneNumber = BehaviorRelay(value: "")
    var user = BehaviorRelay<[User]>(value: [])
    
    var isSaved = BehaviorRelay<Bool?>(value: nil)
    
    private let useCase: UserUseCaseProtocol
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(useCase: UserUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func fetchUser() {
        useCase.fetchUser().subscribe(onSuccess: { (user) in
            self.firstName.accept(user.firstName ?? "")
            self.lastName.accept(user.lastName ?? "")
            self.email.accept(user.email ?? "")
            self.phoneNumber.accept(user.mobileNumber ?? "")
            self.user.accept([user])
        }) { (err) in
            print(err)
        }.disposed(by: disposeBag)
    }
    
    func updateUser(firstName: String, lastName: String, email: String, mobileNumber: String) {
        var updatedUser: User
        if user.value.count > 0 {
            updatedUser = User(firstName: firstName, lastName: lastName, mobileNumber: mobileNumber, dateOfBirth: user.value.first?.dateOfBirth, isMember: true, email: email, totalPoint: (user.value.first?.totalPoint)!, address: user.value.first?.address, payment: user.value.first?.payment, coupon: user.value.first?.coupon)
        } else {
            updatedUser = User(firstName: firstName, lastName: lastName, mobileNumber: mobileNumber, dateOfBirth: nil, isMember: true, email: email, totalPoint: 0, address: nil, payment: nil, coupon: nil)
        }
        useCase.updateUser(user: updatedUser).subscribe(onCompleted: {
            self.isSaved.accept(true)
        }) { (error) in
            switch (error) {
                case NomnomError.invalidInput :
                    self.isSaved.accept(false)
                break;
                default :
                    print(error)
            }
        }
    }
}
