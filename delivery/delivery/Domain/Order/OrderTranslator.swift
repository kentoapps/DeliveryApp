//
//  DeliveryTranslator.swift
//  delivery
//
//  Created by MATSUHISA MAI on 2018/03/12.
//  Copyright © 2018年 CICCC. All rights reserved.
//

import Foundation

class OrderTranslator: TranslatorProtocol {
    func translate(_ entities: [OrderEntity]) -> [Order] {
        var orders = [Order]()
        
        for entity in entities {
            orders.append(Order(orderNumber: entity.orderNumber,
                                cancelReason: entity.cancelReason,
                                deliveryFee: entity.deliveryFee,
                                deliveryInfo: entity.deliveryInfo,
                                orderDetail: entity.orderDetail,
                                pointStatement: entity.pointStatement,
                                remark: entity.remark,
                                scheduledDeliveryDate: entity.scheduledDeliveryDate,
                                shippingAddress: entity.shippingAddress,
                                status: entity.status,
                                totalPrice: entity.totalPrice,
                                trackingNumber: entity.trackingNumber,
                                userId: entity.userId,
                                couponDiscount: entity.couponDiscount,
                                orderId: entity.orderId))
        }
        return orders
    }


    
    func translateToEntity(_ model: Order) -> OrderEntity {
        
        return OrderEntity(orderNumber: model.orderNumber,
                           cancelReason: model.cancelReason,
                           deliveryFee: model.deliveryFee,
                           deliveryInfo: model.deliveryInfo,
                           orderDetail: model.orderDetail,
                           pointStatement: model.pointStatement,
                           remark: model.remark,
                           scheduledDeliveryDate: model.scheduledDeliveryDate,
                           shippingAddress: model.shippingAddress,
                           status: model.status,
                           totalPrice: model.totalPrice,
                           trackingNumber: model.trackingNumber,
                           userId: model.userId,
                           couponDiscount: model.couponDiscount,
                           orderId: model.orderId)
    }
    
    func translate2(_ entity: OrderEntity) -> Order {
        return Order(orderNumber: entity.orderNumber,
                                cancelReason: entity.cancelReason,
                                deliveryFee: entity.deliveryFee,
                                deliveryInfo: entity.deliveryInfo,
                                orderDetail: entity.orderDetail,
                                pointStatement: entity.pointStatement,
                                remark: entity.remark,
                                scheduledDeliveryDate: entity.scheduledDeliveryDate,
                                shippingAddress: entity.shippingAddress,
                                status: entity.status,
                                totalPrice: entity.totalPrice,
                                trackingNumber: entity.trackingNumber,
                                userId: entity.userId,
                                couponDiscount: entity.couponDiscount,
                                orderId: entity.orderId)
    }
    
//    func translate2(_ entity: ProductEntity) -> Product {
//        return Product(averageRating: entity.averageRating, branch: entity.branch, brand: entity.brand, description: entity.description, discountPercent: entity.discountPercent, events: entity.events, images: entity.images, name: entity.name, originalPrice: entity.originalPrice, price: entity.price, category: entity.category, subCategory: entity.subCategory, productId: entity.productId)
//    }
}
