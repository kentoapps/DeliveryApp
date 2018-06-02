//
//  ViewModelAssembly.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/09.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Swinject

final class ViewModelAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SignUpViewModel.self) { (_, useCase: UserUseCaseProtocol) in
            SignUpViewModel(useCase: useCase)
        }
        container.register(ProductDetailViewModel.self) { (_, useCase: ProductDetailUseCaseProtocol, shoppingCartUseCase: ShoppingCartUseCaseProtocol) in
            ProductDetailViewModel(useCase: useCase, shoppingCartUseCase: shoppingCartUseCase)
        }
        container.register(OrderViewModel.self) { (_, useCase: OrderUseCaseProtocol) in
            OrderViewModel(useCase: useCase)
        }
        container.register(OrderDetailViewModel.self) { (_, useCase: OrderUseCaseProtocol) in
            OrderDetailViewModel(orderUseCase: useCase)
        }
        container.register(AccountViewModel.self) { (_, useCase: UserUseCaseProtocol) in
            AccountViewModel(useCase: useCase)
        }
        container.register(HomeViewModel.self) { (_, useCase: ProductListUseCaseProtocol, useCaseShopping: ShoppingCartUseCaseProtocol) in
            HomeViewModel(useCase: useCase, useCaseShopping: useCaseShopping)
        }
        container.register(ProductListViewModel.self) { (_, useCase: ProductListUseCaseProtocol, useCaseShopping: ShoppingCartUseCaseProtocol) in
            ProductListViewModel(useCase: useCase, useCaseShopping: useCaseShopping)
        }
        container.register(ReviewListViewModel.self) { (_, useCase: ReviewListUseCaseProtocol) in
            ReviewListViewModel(useCase: useCase)
        }
        container.register(ReviewPostViewModel.self) { (_, useCase: ReviewPostUseCaseProtocol) in
            ReviewPostViewModel(useCase: useCase)
        }
        container.register(CheckoutViewModel.self) { (_, useCase: UserUseCaseProtocol) in
            CheckoutViewModel(useCase: useCase)
        }
        container.register(AddressEditViewModel.self) { (_, useCase: UserUseCaseProtocol) in
            AddressEditViewModel(useCase: useCase)
        }
        container.register(AddressListViewModel.self) { (_, useCase: UserUseCaseProtocol) in
            AddressListViewModel(useCase: useCase)
        }
        container.register(UserInfoEditViewModel.self) { (_, useCase: UserUseCaseProtocol) in
            UserInfoEditViewModel(useCase: useCase)
        }
        container.register(ShoppingCartViewModel.self) { (_, useCase: ShoppingCartUseCaseProtocol) in
            ShoppingCartViewModel(useCase: useCase)
        }
        container.register(AccountEditViewModel.self) { (_, useCase: UserUseCaseProtocol) in
            AccountEditViewModel(useCase: useCase)
        }
        container.register(SignInViewModel.self) { (_, useCase: UserUseCaseProtocol) in
            SignInViewModel(useCase: useCase)
        }
        
        container.register(OrderReviewViewModel.self) { (_, useCaseShoppingCart: ShoppingCartUseCaseProtocol, useCaseUserAccount: UserUseCaseProtocol, useCaseOrder: OrderUseCaseProtocol) in
            OrderReviewViewModel(useCaseShoppingCart: useCaseShoppingCart, useCaseUserAccount: useCaseUserAccount, useCaseOrder: useCaseOrder)
        }
    }
}
