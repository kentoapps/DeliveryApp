//
//  UserEntity.swift
//  delivery
//
//  Created by MATSUHISA MAI on 2018/03/12.
//  Copyright © 2018年 CICCC. All rights reserved.
//

import Foundation

struct OrderEntity {
    public let orderNumber: String
    public let cancelReason: String
    public let deliveryFee: Double
    public let deliveryInfo: [String : Date?]
    public var orderDetail: [OrderDetail]
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
    
    
    //    init?(dictionary: [String:Any]){
    //        guard let
    //    }
    
    init(orderNumber: String,cancelReason: String,deliveryFee: Double,deliveryInfo: [String : Date?],orderDetail: [OrderDetail],pointStatement: PointStatement,remark: String,scheduledDeliveryDate: Date?,shippingAddress: AddressEntity,status: String,totalPrice: Double,trackingNumber: String,userId: String,couponDiscount: Double,
        orderId: String) {
        
        self.orderNumber = orderNumber
        self.cancelReason = cancelReason
        self.deliveryFee = deliveryFee
        self.deliveryInfo = deliveryInfo
        self.orderDetail = orderDetail
        self.pointStatement = pointStatement
        self.remark = remark
        self.scheduledDeliveryDate = scheduledDeliveryDate
        self.shippingAddress = shippingAddress
        self.status = status
        self.totalPrice = totalPrice
        self.trackingNumber = trackingNumber
        self.userId = userId
        self.couponDiscount = couponDiscount
        self.orderId = orderId
    }
    
    init?(docId: String, dictionary: [String: Any]) {
        guard let orderNumber = dictionary["orderNumber"] as? String,
            let cancelReason = dictionary["cancelReason"] as? String,
            let deliveryFee = dictionary["deliveryFee"] as? Double,
            let deliveryInfo = dictionary["deliveryInfo"] as? [String : Date?],
            // ⤵︎ "orderDetail" below
            // ⤵︎ "pointStatement" below
            let remark = dictionary["remark"] as? String,
            let scheduledDeliveryDate = dictionary["scheduledDeliveryDate"] as? Date?,
            // ⤵︎ "shippingAddress" below
            let shippingAddressDict = dictionary["shippingAddress"] as? [String : Any],
            let status = dictionary["status"] as? String,
            let totalPrice = dictionary["totalPrice"] as? Double,
            let trackingNumber = dictionary["trackingNumber"] as? String,
            let userId = dictionary["userId"] as? String,
            let couponDiscount = dictionary["couponDiscount"] as? Double
            else { return nil }
        
        self.orderNumber = orderNumber
        self.cancelReason = cancelReason
        self.deliveryFee = deliveryFee
        self.deliveryInfo = deliveryInfo
        
        //orderDetail
        var detail: [OrderDetail]  = []
        for orderDetail in dictionary["orderDetail"] as! [Any] {
            detail.append(OrderDetail(dictionary: (orderDetail as? [String : Any]) ?? [:])!)
        }
        self.orderDetail = detail
        
        //pointStatement
        let point = PointStatement(dictionary: (dictionary["pointStatement"] as? [String : Any]) ?? [:])!
        self.pointStatement = point
        
        
        self.remark = remark
        self.scheduledDeliveryDate = scheduledDeliveryDate
        
        //shippingAddress
        let shippingAddress = AddressEntity(dictionary: shippingAddressDict)!
        self.shippingAddress = shippingAddress
        
        self.status = status
        self.totalPrice = totalPrice
        self.trackingNumber = trackingNumber
        self.userId = userId
        self.couponDiscount = couponDiscount
        
        self.orderId = docId
    }
    
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
