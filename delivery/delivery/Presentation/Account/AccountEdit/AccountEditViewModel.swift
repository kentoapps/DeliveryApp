//
//  AccountEditViewModel.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-05-10.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class AccountEditViewModel: BaseViewModel {
    var firstName = BehaviorRelay(value: "")
    var lastName = BehaviorRelay(value: "")
    var phoneNumber = BehaviorRelay(value: "")
    var email = BehaviorRelay(value: "")
    var birthDate = BehaviorRelay(value: "")
    var user = BehaviorRelay<[User]>(value: [])
    var isSaved = BehaviorRelay(value: false)
    
    private let useCase: UserUseCaseProtocol
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(useCase: UserUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func fetchUser() {
        useCase.fetchUser().subscribe(onSuccess: { (user) in
            self.firstName.accept(user.firstName ?? "")
            self.lastName.accept(user.lastName ?? "")
            self.phoneNumber.accept(user.mobileNumber ?? "")
            self.email.accept(user.email ?? "")
            self.user.accept([user])
            
            if let birthDate = user.dateOfBirth {
                print(birthDate)
                let birthDateString = DateFormatter.birthDateInFormat(birthDate: birthDate)
                self.birthDate.accept(birthDateString)
            }
        }, onError: { (err) in
            print(err)
        })
    }

    func updateUser(password: String) -> Completable {
        if user.value.count > 0 {
            let updatedUser = User(firstName: firstName.value, lastName: lastName.value, mobileNumber: phoneNumber.value, dateOfBirth: birthDate.value != "" ? DateFormatter.toDateFromString(date: birthDate.value)! : nil, isMember: true,
                                   email: email.value, totalPoint: (user.value.first?.totalPoint)!,
                                   address: user.value.first?.address, payment:
                user.value.first?.payment, coupon: user.value.first?.coupon)
            return useCase.updateUser(user: updatedUser, password: password)
        } else {
            let updatedUser = User(firstName: firstName.value, lastName: lastName.value, mobileNumber: phoneNumber.value, dateOfBirth: nil, isMember: true, email: email.value, totalPoint: 0, address: nil, payment: nil, coupon: nil)
            return useCase.updateUser(user: updatedUser, password: password)
        }
    }

    func changePassword(currentPW: String, confirmedPW: String, newPW: String) {
        useCase.changePassword(currentPW: currentPW, confirmedPW: confirmedPW, newPW: newPW).subscribe(onCompleted: {
            self.isSaved.accept(true)
        }, onError: { (err) in
            self.setError(err)
        })
    }
}
