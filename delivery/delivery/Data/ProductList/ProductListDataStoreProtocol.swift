//
//  ProductListDataStoreProtocol.swift
//  delivery
//
//  Created by Bacelar on 2018-03-06.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift

protocol ProductListDataStoreProtocol {
    func fetchProductList(with keyword: String, by orderby: String, _ descending: Bool, filters: [String:Any]) -> Single<[ProductEntity]>
    
}
