//
//  AccountViewModel.swift
//  delivery
//
//  Created by Diego H. Vanni on 2018-03-13.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import RxDataSources

class AccountViewModel: BaseViewModel {
    
    var fullName = BehaviorRelay(value: "")
    var dateOfBirth = BehaviorRelay(value: "")
    var mobileNumber = BehaviorRelay(value: "")
    var email = BehaviorRelay(value: "")
    
    var totalPoint = BehaviorRelay(value: "")
    
    var receiver = BehaviorRelay(value: "")
    var address = BehaviorRelay(value: "")
    var postalCode = BehaviorRelay(value: "")
    
    var cardholder = BehaviorRelay(value: "")
    var cardNumber = BehaviorRelay(value: "")
    var expiryDate = BehaviorRelay(value: "")
    
    var isMember = BehaviorRelay(value: true)
    
    public var dataForSection = BehaviorRelay<[SectionModel<String, User>]>(value: [])
    var user = BehaviorRelay<[User]>(value: [])
    
    private let useCase: UserUseCaseProtocol
    private let disposeBag: DisposeBag = DisposeBag()
    
    
    init(useCase: UserUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func fetchUser() {
        useCase.fetchUser().subscribe(onSuccess: { (user) in
            if user.isMember {
                self.isMember.accept(true)
                self.user.accept([user])
                
                self.fullName.accept("\(user.firstName ?? "full name") \(user.lastName ?? "")")
                self.email.accept(user.email ?? "")
                if let dateOfBirth = user.dateOfBirth {
                    let birthDateString = DateFormatter.birthDateInFormat(birthDate: dateOfBirth)
                    self.dateOfBirth.accept(birthDateString)
                }
                self.totalPoint.accept("\(user.totalPoint) point(s)")
                self.mobileNumber.accept(user.mobileNumber ?? "")
                
                if let address = user.address {
                    let defaultAddress = address.filter({ $0.isDefault })
                    
                    self.address.accept("\((defaultAddress.first?.address1)!) \((defaultAddress.first?.address2)!)")
                    self.receiver.accept((defaultAddress.first?.receiver)!)
                    self.postalCode.accept((defaultAddress.first?.postalCode)!)
                }
                
                if let payment = user.payment {
                    let defaultPayment = payment.filter({ $0.isDefault })
                    
                    self.cardholder.accept((defaultPayment.first?.holderName)!)
                    self.cardNumber.accept((defaultPayment.first?.cardNumber)!)
                    let expiryDateString = DateFormatter.expiryDateInFormat(expiryDate: (defaultPayment.first?.expiryDate)!)
                    self.expiryDate.accept(expiryDateString)
                }
            } else {
                self.isMember.accept(false)
            }
        }) { (err) in
            switch (err) {
            case NomnomError.noData:
                self.isMember.accept(false)
                break
            default:
                self.setError(err)
//                print(err)
            }
        }
    }
    
    func signOut() {
        useCase.signOut()
            .subscribe(
                onCompleted: { print("successfully signedOut!") },
                onError:  { (error) in print("Zannen... signout!") }
            ).disposed(by: disposeBag)
    }
}

