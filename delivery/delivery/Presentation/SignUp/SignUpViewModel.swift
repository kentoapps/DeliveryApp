//
//  SignUpViewModel.swift
//  delivery
//
//  Created by Kento Uchida on 2018/05/16.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewModel: BaseViewModel {
    
    var email = BehaviorRelay(value: "")
    var password = BehaviorRelay(value: "")
    var confirm = BehaviorRelay(value: "")
    var isCompleted = BehaviorRelay(value: false)
    
    // MARK: - Private Properties
    private let useCase: UserUseCaseProtocol
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Initializer
    init(useCase: UserUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func signUp() {
        useCase.signUp(email: email.value, password: password.value, confirm: confirm.value)
            .subscribe(
                onCompleted: { self.isCompleted.accept(true) },
                onError: { error in
                    self.setError(error)
                    
            }).disposed(by: disposeBag)
    }
}
