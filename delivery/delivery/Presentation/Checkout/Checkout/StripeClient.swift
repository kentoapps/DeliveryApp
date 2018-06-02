//
//  StripeClient.swift
//  delivery
//
//  Created by Diego H. Vanni on 2018-05-15.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import Alamofire
import Stripe

enum Result {
    case success
    case failure(Error)
}

final class StripeClient {
    
    static let shared = StripeClient()
    
    private init() {
        // private
    }
    
    private lazy var baseURL: URL = {
        guard let url = URL(string: Constants.baseURLString) else {
            fatalError("Invalid URL")
        }
        return url
    }()
    
    func completeCharge(with token: STPToken, amount: Int, completion: @escaping (Result) -> Void) {
        // 1
        let url: URLConvertible = baseURL.appendingPathComponent("charge/")
        // 2
        let params: [String: Any] = [
            "token": token.tokenId,
            "amount": amount,
            "currency": Constants.defaultCurrency,
        ]
        // 3
        let jsonHeader: HTTPHeaders  = ["Content-Type" : "application/json"]
        let jsonEncoding: ParameterEncoding = Alamofire.JSONEncoding.default
        Alamofire.request(url, method: .post, parameters: params, encoding: jsonEncoding, headers: jsonHeader)
            .validate(statusCode: 200..<300)
            .responseString { response in
                switch response.result {
                case .success:
                    completion(Result.success)
                case .failure(let error):
                    completion(Result.failure(error))
                }
        }
    }
    
}
