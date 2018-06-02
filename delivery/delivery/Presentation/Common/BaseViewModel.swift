//
//  BaseViewModel.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/22.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class BaseViewModel {
    var alertMessage = BehaviorRelay(value: AlertError(message: ""))
    
    func setError(_ error: Error) {
        switch error {
        case let NomnomError.alert(message):
            self.alertMessage.accept(AlertError(message: message))
        case let NomnomError.network(code, message, log):
            self.alertMessage.accept(AlertError(title: "Network Error", message: "\(message)\n(code: \(code))"))
            print("===== NETWORK ERROR\n\(log)\n===================")
        default:
            print("error...")
        }
    }
}
