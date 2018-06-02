//
//  OrderReviewViewModel.swift
//  delivery
//
//  Created by Bacelar on 2018-05-21.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import RxCocoa

class OrderReviewViewModel: BaseViewModel {
    private var useCaseShoppingCart: ShoppingCartUseCaseProtocol
    private var useCaseUserAccount: UserUseCaseProtocol
    private var useCaseOrder: OrderUseCaseProtocol
    
    var user = BehaviorRelay<[User]>(value: [])
    var fullName = BehaviorRelay(value: "")
    var dateOfBirth = BehaviorRelay(value: "")
    var mobileNumber = BehaviorRelay(value: "")
    var email = BehaviorRelay(value: "")
    
    var receiver = BehaviorRelay(value: "")
    var address = BehaviorRelay(value: "")
    var postalCode = BehaviorRelay(value: "")
    var city = BehaviorRelay(value: "")
    var country = BehaviorRelay(value: "")
    var province = BehaviorRelay(value: "")
    
    var cardholder = BehaviorRelay(value: "")
    var cardNumber = BehaviorRelay(value: "")
    var expiryDate = BehaviorRelay(value: "")
    
    var productsShoppingCart = BehaviorRelay<[ProductShoppingCart]>(value: [])
    var shippingFee = BehaviorRelay<String>(value: "$ 3.00")
    var totalBeforeShippingFee = BehaviorRelay<String>(value: "0.0")
    var total = BehaviorRelay<String>(value: "0.0")
    
    var isPaymentConfirmed = BehaviorRelay(value: false)
    var isCartDeleted = BehaviorRelay(value: false)
    
    var totalPurchase: Double = 0.0
    let shippingFeeValue = 3.0
    
    var orderDetail = [OrderDetail]()
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(useCaseShoppingCart: ShoppingCartUseCaseProtocol, useCaseUserAccount: UserUseCaseProtocol, useCaseOrder: OrderUseCaseProtocol ) {
        self.useCaseShoppingCart = useCaseShoppingCart
        self.useCaseUserAccount = useCaseUserAccount
        self.useCaseOrder = useCaseOrder
    }
    
    func fetchUser() {
        useCaseUserAccount.fetchUser().subscribe(onSuccess: { (user) in
            self.user.accept([user])
            
            self.fullName.accept("\(user.firstName) \(user.lastName)")
            self.email.accept(user.email!)
            if let dateOfBirth = user.dateOfBirth {
                let birthDateString = DateFormatter.birthDateInFormat(birthDate: dateOfBirth)
                self.dateOfBirth.accept(birthDateString)
            }
            
            self.mobileNumber.accept(user.mobileNumber!)
            
            if let address = user.address {
                let defaultAddress = address.filter({ $0.isDefault })
                
                self.address.accept("\((defaultAddress.first?.address1)!) \((defaultAddress.first?.address2)!)")
                self.receiver.accept((defaultAddress.first?.receiver)!)
                self.postalCode.accept((defaultAddress.first?.postalCode)!)
                self.city.accept((defaultAddress.first?.city)!)
                self.province.accept((defaultAddress.first?.province)!)
                self.country.accept((defaultAddress.first?.country)!)
            }
            
            if let payment = user.payment {
                let defaultPayment = payment.filter({ $0.isDefault })
                
                self.cardholder.accept((defaultPayment.first?.holderName)!)
                self.cardNumber.accept((defaultPayment.first?.cardNumber)!)
                let expiryDateString = DateFormatter.expiryDateInFormat(expiryDate: (defaultPayment.first?.expiryDate)!)
                self.expiryDate.accept(expiryDateString)
            }
        }, onError: { (error) in
            print(error.localizedDescription)}
            ) .disposed(by: disposeBag)
    }
    
    func fetchShoppingCartList(){
        useCaseShoppingCart.fetchShoppingCart()
            .subscribe(
                onSuccess: { (productsList) in
                    
                    self.orderDetail = self.generateOrderDetail(productsList: productsList)
                    
                    self.productsShoppingCart.accept(productsList)
                    
                    self.calculateSubTotal()
                    
            }, onError: { (error) in
                print(error.localizedDescription)}
            ) .disposed(by: disposeBag)
    }
    
    
    func deleteShoppingCart() {
        useCaseShoppingCart.deleteShoppingCart().subscribe(onCompleted: {
            self.isCartDeleted.accept(true)
        }) { (error) in
            self.setError(error)
        }
    }
    
    private func calculateSubTotal(){
        let shoppingCart = productsShoppingCart.value
        
        var preSubTotal = 0.0
        
        for item in shoppingCart {
            preSubTotal = preSubTotal + item.total
        }
        
        totalBeforeShippingFee.accept("$ \(String(format:"%.2f", preSubTotal))")
    
        preSubTotal = preSubTotal + shippingFeeValue
        totalPurchase = preSubTotal
        total.accept("$ \(String(format:"%.2f", preSubTotal))")
    }
    
    private func generateOrderDetail(productsList: [ProductShoppingCart]) -> [OrderDetail] {
        
        var orderDetailList = [OrderDetail]()
        
        for item in productsList {
            
            let orderDetail = OrderDetail(dictionary: ["pricePerItem": item.total,
                                                             "quantity": item.quantity,
                                                             "productId": item.product.productId,
                                                             "productImage": "https://images-na.ssl-images-amazon.com/images/I/61JPeeObrUL._SL1500_.jpg",
                                                             "productName": item.product.name])
            orderDetailList.append(orderDetail!)
        }
        
        return orderDetailList
        
    }
    
    func saveOrder() {
        
        let shippingAddress = AddressEntity(receiver: receiver.value, address1: address.value, address2: "", city: city.value, province: province.value, postalCode: postalCode.value, country: country.value, isDefault: true, phoneNumber: mobileNumber.value)

        let pointStatement = PointStatement(dictionary: ["earnedPoints" : 0,
                                                         "consumedPoints": 0])

        let date = Date()
        let calender = Calendar.current
        var dateComponent = calender.dateComponents([.year,.month,.day,.hour,.minute,.second], from: date)

        dateComponent.day = 2
        let scheduledDeliveryDate = Calendar.current.date(byAdding: dateComponent, to: Date())

        let orderNumber = "ORD\(dateComponent.year!)\(dateComponent.month!)\(dateComponent.day!)\(dateComponent.hour!)\(dateComponent.minute!)\(dateComponent.second!)"

        let orderReview = Order(orderNumber: orderNumber,
                                cancelReason: "",
                                deliveryFee: shippingFeeValue,
                                deliveryInfo: ["purchasedDate": Date()],
                                orderDetail: orderDetail,
                                pointStatement: pointStatement!,
                                remark: "",
                                scheduledDeliveryDate: scheduledDeliveryDate,
                                shippingAddress: shippingAddress,
                                status: "Received Order",
                                totalPrice: totalPurchase,
                                trackingNumber: "",
                                userId: "",
                                couponDiscount: 0,
                                orderId: orderNumber)

        useCaseOrder.saveOrder(orderReview)
            .subscribe(
                onCompleted: { self.isPaymentConfirmed.accept(true) },
                onError: { error in self.setError(error) }
        ).disposed(by: disposeBag)
        
    }
}
