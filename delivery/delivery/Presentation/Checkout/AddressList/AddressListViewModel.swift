//
//  AddressListViewModel.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-04-20.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AddressListViewModel: BaseViewModel {
    
    var addressList = BehaviorRelay<[Address]>(value: [])

    private let useCase: UserUseCaseProtocol
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(useCase: UserUseCaseProtocol) {
        self.useCase = useCase
    }
    
    func fetchAddressList() {
        useCase.fetchAddressList()
            .subscribe(onSuccess: { (addressList) in
                self.addressList.accept(addressList)
                
                addressList.forEach({ (t) in
                    print(t.isDefault)
                })
            }, onError: { (err) in
                print(err)
            }).disposed(by: disposeBag)
    }
    
    func updateAddressList() -> Completable {

       return useCase.updateAddressList(addressList: self.addressList.value)
    }
    
    func changeDefaultAddress(row: Int) {
        let newAddressList = addressList.value.enumerated().map { (index, address) in
            address.changeDefault(isDefault: index == row)
        }
        addressList.accept(newAddressList)
    }
    
    func deleteAddressAtSelectedIndex(index: Int) {
        var newAddressList = addressList.value
        newAddressList.remove(at: index)
        addressList.accept(newAddressList)        
    }
}

