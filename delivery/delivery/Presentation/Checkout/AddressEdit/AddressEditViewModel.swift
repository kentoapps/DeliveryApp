//
//  AddressEditViewModel.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-04-06.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AddressEditViewModel: BaseViewModel {
    var receiver = Variable<String>("")
    var address1 = Variable<String>("")
    var address2 = Variable<String>("")
    var city = Variable<String>("")
    var zipCode = Variable<String>("")
    var phoneNumber = Variable<String>("")
    var province = Variable<String>("")
    var country = Variable<String>("")
    var isDefault = Variable<Bool>(true)
    var address = BehaviorRelay<[Address]>(value: [])
    var indexOfAddressOnEdit: Int? = nil
    
    private let useCase: UserUseCaseProtocol
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(useCase: UserUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func fetchAddress(index: Int) {
        useCase.fetchAddress(index: index).subscribe(
            onSuccess: { model in
                self.address.accept(model)
        },
            onError: { error in print(error) }
            )
            .disposed(by: disposeBag)
                
        }
    
    func updateAddress() -> Completable {
        let address = Address(receiver: self.receiver.value, address1: self.address1.value, address2: self.address2.value, city: self.city.value, province: self.province.value, postalCode: self.zipCode.value, country: self.country.value, isDefault: self.isDefault.value, phoneNumber: self.phoneNumber.value)

        if let indexNo = self.indexOfAddressOnEdit {
            return useCase.updateAddress(address: address, indexNo: indexNo)
        } else {
            return useCase.addAddress(address: address)
        }
    }
}

