//
//  Order.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-03-17.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

struct Order {
    public let orderNumber: String
    public let cancelReason: String
    public let deliveryFee: Double
    public let deliveryInfo: [String : Date?]
    public let orderDetail: [OrderDetail]
    public let pointStatement: PointStatement
    public let remark: String
    public let scheduledDeliveryDate: Date?
    public let shippingAddress: AddressEntity
    public let status: String
    public let totalPrice: Double
    public let trackingNumber: String
    public let userId: String
    public let couponDiscount: Double
    public let orderId: String
    
    var dictionary: [String: Any] {
        return [
            "orderNumber": orderNumber,
            "cancelReason": cancelReason,
            "deliveryFee": deliveryFee,
            "deliveryInfo": deliveryInfo,
            "orderDetail": orderDetail,
            "pointStatement": pointStatement,
            "remark": remark,
            "scheduledDeliveryDate": scheduledDeliveryDate as Any,
            "shippingAddress": shippingAddress,
            "status": status,
            "totalPrice": totalPrice,
            "trackingNumber": trackingNumber,
            "userId": userId,
            "couponDiscount": couponDiscount,
        ]
    }
}

