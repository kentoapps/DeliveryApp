//
//  UserTranslator.swift
//  delivery
//
//  Created by Sara N on 2018-03-12.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation

class UserTranslator {
    func translate(fromEntity entity: UserEntity) -> User {
            return User(firstName: entity.firstName,
                        lastName: entity.lastName,
                        mobileNumber: entity.mobileNumber,
                        dateOfBirth: entity.dateOfBirth,
                        isMember: entity.isMember,
                        email: entity.email,
                        totalPoint: entity.totalPoint,
                        address: entity.address != nil ? translateAddress(from: entity.address!) : nil,
                        payment: entity.payment != nil ? translatePayment(from: entity.payment!) : nil,
                        coupon: entity.coupon)
    }

    func translate(fromModel model: User) -> UserEntity {
        return UserEntity(firstName: model.firstName,
                          lastName: model.lastName,
                          mobileNumber: model.mobileNumber,
                          dateOfBirth: model.dateOfBirth,
                          isMember: model.isMember,
                          totalPoint: model.totalPoint,
                          email: model.email,
                          address: model.address?.map({translateAddress(from: $0)}),
                          payment: model.payment?.map({translatePaymentModel(from: $0)}) ,
                          coupon: model.coupon)
    }
    
    func translateAddress(from address: [AddressEntity]) -> [Address] {
        return address.map {
            Address(receiver: $0.receiver, address1: $0.address1, address2: $0.address2, city: $0.city, province: $0.province, postalCode: $0.postalCode, country: $0.country, isDefault: $0.isDefault, phoneNumber: $0.phoneNumber) }
    }
    
    func translatePayment(from payment: [PaymentEntity]) -> [Payment] {
        return payment.map { Payment(cardNumber: $0.cardNumber, holderName: $0.holderName, expiryDate: $0.expiryDate, isDefault: $0.isDefault)  }
    }
    
    func translateAddress(from address: Address) -> AddressEntity {
        return AddressEntity(receiver: address.receiver, address1: address.address1, address2: address.address2, city: address.city, province: address.province, postalCode: address.postalCode, country: address.country, isDefault: address.isDefault, phoneNumber: address.phoneNumber)
    }
    
    func translatePaymentModel(from payment: Payment) -> PaymentEntity {
        return PaymentEntity(cardNumber: payment.cardNumber, holderName: payment.holderName, expiryDate: payment.expiryDate, isDefault: payment.isDefault)
    }
}
