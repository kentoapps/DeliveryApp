//
//  CheckoutViewModel.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-04-04.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class CheckoutViewModel: BaseViewModel {
    
    public var dataForSection = BehaviorRelay<[SectionModel<String, User>]>(value: [])
    var user = BehaviorRelay<[User]>(value: [])
    var isMember = BehaviorRelay<Bool?>(value: nil)
    var isNonEmpty = BehaviorRelay(value: false)
    
    private let disposeBag: DisposeBag = DisposeBag()
    private let useCase: UserUseCaseProtocol

    // MARK: - Init
    
    init(useCase: UserUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func updateUser() {
        useCase.updateUser(user: self.user.value.first!)
    }
    
    func fetchUser() {
        useCase.fetchUser()
            .subscribe(onSuccess: { (user) in                self.dataForSection.accept([SectionModel(model: "User Information", items: [user]),
                                  SectionModel(model: "Shipping To", items: [user]),
                                  SectionModel(model: "Payment", items: [user])
                    ])
                self.user.accept([user])
            }, onError: { (err) in
                switch (err) {
                case NomnomError.noData:
                    
                    let emptyUser = [User(firstName: "full name", lastName: "", mobileNumber: "mobile number", dateOfBirth: nil, isMember: false, email: "email", totalPoint: 0, address: nil, payment: nil, coupon: nil)]
                    self.dataForSection.accept([SectionModel(model: "User Information", items: emptyUser),
                                                SectionModel(model: "Shipping To", items: emptyUser),
                                                SectionModel(model: "Payment", items: emptyUser)
                        ])
                    self.user.accept(emptyUser)
                    break
                default:
                    print(err)
                }
            }).disposed(by: disposeBag)
    }
    
    func goToPayment() {
        useCase.goToPayment()
            .subscribe(
                onCompleted: { self.isNonEmpty.accept(true) },
                onError: { error in
                    self.setError(error)
                    
            }).disposed(by: disposeBag)
    }
}
