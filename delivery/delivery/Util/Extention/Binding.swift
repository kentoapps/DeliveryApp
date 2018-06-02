//
//  Binding.swift
//  delivery
//
//  Created by Kento Uchida on 2018/05/16.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

infix operator <-> {}

func <-> <T>(property: ControlProperty<Optional<T>>, variable: BehaviorRelay<T>) -> Disposable {
    let bindToUIDisposable = variable.asObservable()
        .bind(to: property)
    let bindToVariable = property
        .subscribe(onNext: { n in
            if let n = n { variable.accept(n) }
        }, onCompleted:  {
            bindToUIDisposable.dispose()
        })
    let disposable = CompositeDisposable.init()
    _ = disposable.insert(bindToUIDisposable)
    _ = disposable.insert(bindToVariable)
    return disposable
}
