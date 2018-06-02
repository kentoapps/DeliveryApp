

import Foundation
import RxSwift
import RxCocoa
//import RxDataSources

class OrderDetailViewModel : BaseViewModel{
    var arrOfOrderDetail = BehaviorRelay<[OrderDetail]>(value: [])
//    var arrOfUser = BehaviorRelay<[User]>(value: [])
    
    //shippingAddress
    var address1 = BehaviorRelay(value: "")
    var address2 = BehaviorRelay(value: "")
    var city = BehaviorRelay(value: "")
    var province = BehaviorRelay(value: "")
    var postalCode = BehaviorRelay(value: "")
    var phoneNumber = BehaviorRelay(value: "")
//    var cardholder = BehaviorRelay(value: "")
//    var cardNumber = BehaviorRelay(value: "")
//    var expiryDate = BehaviorRelay(value: "")
    
    //OrderEntity
    var scheduledDeliveryDate = BehaviorRelay(value: "")
    var couponDiscount = BehaviorRelay(value: "")
    var deliveryFee = BehaviorRelay(value: "")
    var totalPrice = BehaviorRelay(value: "")
    var totalBeforeShippingFee = BehaviorRelay(value: "")
    
    var quantityPerItem = BehaviorRelay(value: "")
    var pricePerItem = BehaviorRelay(value: "")
    var productImage = BehaviorRelay<String>(value: "")
    var productName = BehaviorRelay(value: "")
    
    //==============================================================
    
    private var orderUseCase: OrderUseCaseProtocol
    
    private let disposeBag: DisposeBag = DisposeBag()
    
    init(orderUseCase: OrderUseCaseProtocol) {
        self.orderUseCase = orderUseCase
    }
    
    //==============================================================
    
    func fetchOrderDetail(with orderId : String){
        orderUseCase.fetchOrderDetail(with: orderId)
            .subscribe(
                onSuccess: {order in
                    if let schedule = order.scheduledDeliveryDate{
                        let scheduleString = DateFormatter.scheduledDeliveryDateInFormat(scheduledDeliveryDate: schedule)
                        print(scheduleString)

                        self.scheduledDeliveryDate.accept(scheduleString)
                    }
                    self.couponDiscount.accept(String(format: "$%0.2f", order.couponDiscount))
                    self.deliveryFee.accept(String(format: "$%0.2f", order.deliveryFee))
                    self.totalPrice.accept(String(format: "$%0.2f", order.totalPrice - order.couponDiscount))
                    self.totalBeforeShippingFee.accept(String(format: "$%0.2f", order.totalPrice - order.couponDiscount - order.deliveryFee))
                    self.address1.accept(order.shippingAddress.address1 + ",")
                    self.address2.accept(order.shippingAddress.address2 + ",")
                    self.city.accept(order.shippingAddress.city)
                    self.province.accept(order.shippingAddress.province + ",")
                    self.postalCode.accept(order.shippingAddress.postalCode)
                    self.phoneNumber.accept(order.shippingAddress.phoneNumber)
                    self.arrOfOrderDetail.accept(order.orderDetail)
                    
            }, onError: { error in self.setError(error) }
        ).disposed(by: disposeBag)
    }
    
}
