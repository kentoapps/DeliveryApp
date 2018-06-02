//
//  ViewControllerAssembler.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/09.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Swinject

final class ViewControllerAssembly: Assembly {
    func assemble(container: Container) {
        container.register(SignUpViewController.self) { _ in
            let dataStore  = container.resolve(UserDataStoreProtocol.self)
            let dataStoreGuest  = container.resolve(GuestDataStoreProtocol.self)
            let repository = container.resolve(UserRepositoryProtocol.self, arguments: dataStore!, dataStoreGuest!)
            let translator = container.resolve(UserTranslator.self)
            let usecase    = container.resolve(UserUseCaseProtocol.self, arguments: repository!, translator!)
            let viewModel  = container.resolve(SignUpViewModel.self, argument: usecase!)
            let vc         = SignUpViewController.createInstance(viewModel: viewModel!)
            return vc!
        }
        
        container.register(ProductDetailViewController.self) { _ in
            // ProductDetail
            let dataStore  = container.resolve(ProductDetailDataStoreProtocol.self)
            let repository = container.resolve(ProductDetailRepositoryProtocol.self, argument: dataStore!)
            let translator = container.resolve(ProductDetailTranslator.self)
            let usecase    = container.resolve(ProductDetailUseCaseProtocol.self, arguments: repository!, translator!)

            // ShoppingCart
            let shoppingCartDataStore  = container.resolve(ShoppingCartDataStoreProtocol.self)
            let shoppingCartRepository = container.resolve(ShoppingCartRepositoryProtocol.self, argument: shoppingCartDataStore!)
            let shoppingCartTranslator = container.resolve(ShoppingCartTranslator.self)
            let shoppingCartUsecase    = container.resolve(ShoppingCartUseCaseProtocol.self, arguments: shoppingCartRepository!, shoppingCartTranslator!)

            let viewModel  = container.resolve(ProductDetailViewModel.self, arguments: usecase!, shoppingCartUsecase!)
            let vc         = ProductDetailViewController.createInstance(viewModel: viewModel!)
            return vc!
        }

        container.register(OrderViewController.self) { _ in
            let dataStore  = container.resolve(OrderDataStoreProtocol.self)
            let repository = container.resolve(OrderRepositoryProtocol.self, argument: dataStore!)
            let translator = container.resolve(OrderTranslator.self)
            let usecase    = container.resolve(OrderUseCaseProtocol.self, arguments: repository!, translator!)
            let viewModel  = container.resolve(OrderViewModel.self, argument: usecase!)
            let vc         = OrderViewController.createInstance(viewModel: viewModel!)
            return vc!
        }
        
        container.register(OrderDetailViewController.self) { _ in
            let dataStore  = container.resolve(OrderDataStoreProtocol.self)
            let repository = container.resolve(OrderRepositoryProtocol.self, argument: dataStore!)
            let translator = container.resolve(OrderTranslator.self)
            let usecase    = container.resolve(OrderUseCaseProtocol.self, arguments: repository!, translator!)
            let viewModel  = container.resolve(OrderDetailViewModel.self, argument: usecase!)
            let vc         = OrderDetailViewController.createInstance(viewModel: viewModel!)
            return vc!
        }

        container.register(AccountViewController.self) { _ in
            let dataStore  = container.resolve(UserDataStoreProtocol.self)
            let dataStoreGuest  = container.resolve(GuestDataStoreProtocol.self)
            let repository = container.resolve(UserRepositoryProtocol.self, arguments: dataStore!, dataStoreGuest!)
            let translator = container.resolve(UserTranslator.self)
            let usecase    = container.resolve(UserUseCaseProtocol.self, arguments: repository!, translator!)
            let viewModel  = container.resolve(AccountViewModel.self, argument: usecase!)
            let vc         = AccountViewController.createInstance(viewModel: viewModel!)
            return vc!
        }
        
        container.register(HomeViewController.self) { _ in
            let dataStore = container.resolve(ProductListDataStoreProtocol.self)
            let repository = container.resolve(ProductListRepositoryProtocol.self, argument: dataStore!)
            let translator = container.resolve(ProductListTranslator.self)
            let usecase = container.resolve(ProductListUseCaseProtocol.self, arguments: repository!, translator!)
            
            let dataStoreSC  = container.resolve(ShoppingCartDataStoreProtocol.self)
            let repositorySC = container.resolve(ShoppingCartRepositoryProtocol.self, argument: dataStoreSC!)
            let translatorSC = container.resolve(ShoppingCartTranslator.self)
            let usecaseSC    = container.resolve(ShoppingCartUseCaseProtocol.self, arguments: repositorySC!, translatorSC!)
            
            let viewModel  = container.resolve(HomeViewModel.self, arguments: usecase!,usecaseSC!)
            let vc         = HomeViewController.createInstance(viewModel: viewModel!)
             return vc!
        }

        container.register(ProductListViewController.self) { _ in

            let dataStore  = container.resolve(ProductListDataStoreProtocol.self)
            let repository = container.resolve(ProductListRepositoryProtocol.self, argument: dataStore!)
            let translator = container.resolve(ProductListTranslator.self)
            let usecase    = container.resolve(ProductListUseCaseProtocol.self, arguments: repository!, translator!)

            let dataStoreSC  = container.resolve(ShoppingCartDataStoreProtocol.self)
            let repositorySC = container.resolve(ShoppingCartRepositoryProtocol.self, argument: dataStoreSC!)
            let translatorSC = container.resolve(ShoppingCartTranslator.self)
            let usecaseSC    = container.resolve(ShoppingCartUseCaseProtocol.self, arguments: repositorySC!, translatorSC!)
            
            let viewModel  = container.resolve(ProductListViewModel.self, arguments: usecase!,usecaseSC!)
            let vc         = ProductListViewController.createInstance(viewModel: viewModel!)
            return vc!
        }

        container.register(ReviewListViewController.self) { _ in
            let dataStore  = container.resolve(ReviewListDataStoreProtocol.self)
            let repository = container.resolve(ReviewListRepositoryProtocol.self, argument: dataStore!)
            let translator = container.resolve(ReviewTranslator.self)
            let usecase    = container.resolve(ReviewListUseCaseProtocol.self, arguments: repository!, translator!)
            let viewModel  = container.resolve(ReviewListViewModel.self, argument: usecase!)
            let vc         = ReviewListViewController.createInstance(viewModel: viewModel!)
            return vc!
        }

        container.register(ReviewPostViewController.self) { _ in
            let dataStore  = container.resolve(ReviewPostDataStoreProtocol.self)
            let repository = container.resolve(ReviewPostRepositoryProtocol.self, argument: dataStore!)
            let translator = container.resolve(ReviewTranslator.self)
            let usecase    = container.resolve(ReviewPostUseCaseProtocol.self, arguments: repository!, translator!)
            let viewModel  = container.resolve(ReviewPostViewModel.self, argument: usecase!)
            let vc         = ReviewPostViewController.createInstance(viewModel: viewModel!)
            return vc!
        }

        container.register(CheckoutViewController.self) { _ in
            let dataStore  = container.resolve(UserDataStoreProtocol.self)
            let dataStoreGuest  = container.resolve(GuestDataStoreProtocol.self)
            let repository = container.resolve(UserRepositoryProtocol.self, arguments: dataStore!, dataStoreGuest!)
            let translator = container.resolve(UserTranslator.self)
            let usecase    = container.resolve(UserUseCaseProtocol.self, arguments: repository!, translator!)
            
            let viewModel  = container.resolve(CheckoutViewModel.self, argument: usecase!)
            let vc         = CheckoutViewController.createInstance(viewModel: viewModel!)
            return vc!
        }
        
        container.register(AddressEditViewController.self) { _ in
            let dataStore  = container.resolve(UserDataStoreProtocol.self)
            let dataStoreGuest  = container.resolve(GuestDataStoreProtocol.self)
            let repository = container.resolve(UserRepositoryProtocol.self, arguments: dataStore!, dataStoreGuest!)
            let translator = container.resolve(UserTranslator.self)
            let usecase    = container.resolve(UserUseCaseProtocol.self, arguments: repository!, translator!)
            let viewModel  = container.resolve(AddressEditViewModel.self, argument: usecase!)
            let vc         = AddressEditViewController.createInstance(viewModel: viewModel!)
            return vc!
        }
        
        container.register(AddressListViewController.self) { _ in
            let dataStore  = container.resolve(UserDataStoreProtocol.self)
            let dataStoreGuest  = container.resolve(GuestDataStoreProtocol.self)
            let repository = container.resolve(UserRepositoryProtocol.self, arguments: dataStore!, dataStoreGuest!)
            let translator = container.resolve(UserTranslator.self)
            let usecase    = container.resolve(UserUseCaseProtocol.self, arguments: repository!, translator!)
            let viewModel  = container.resolve(AddressListViewModel.self, argument: usecase!)
            let vc         = AddressListViewController.createInstance(viewModel: viewModel!)
            return vc!
        }
        
        container.register(UserInfoEditViewController.self) { _ in
            let dataStore  = container.resolve(UserDataStoreProtocol.self)
            let dataStoreGuest  = container.resolve(GuestDataStoreProtocol.self)
            let repository = container.resolve(UserRepositoryProtocol.self, arguments: dataStore!, dataStoreGuest!)
            let translator = container.resolve(UserTranslator.self)
            let usecase    = container.resolve(UserUseCaseProtocol.self, arguments: repository!, translator!)
            
            let viewModel  = container.resolve(UserInfoEditViewModel.self, argument: usecase!)
            let vc         = UserInfoEditViewController.createInstance(viewModel: viewModel!)
            return vc!
        }
        
        container.register(ShoppingCartViewController.self) { _ in
            let dataStore  = container.resolve(ShoppingCartDataStoreProtocol.self)
            let repository = container.resolve(ShoppingCartRepositoryProtocol.self, argument: dataStore!)
            let translator = container.resolve(ShoppingCartTranslator.self)
            let usecase    = container.resolve(ShoppingCartUseCaseProtocol.self, arguments: repository!, translator!)
            let viewModel  = container.resolve(ShoppingCartViewModel.self, argument: usecase!)
            let vc         = ShoppingCartViewController.createInstance(viewModel: viewModel!)
            return vc!
        }
        
        container.register(AccountEditViewController.self) { _ in
            let dataStore  = container.resolve(UserDataStoreProtocol.self)
            let dataStoreGuest  = container.resolve(GuestDataStoreProtocol.self)
            let repository = container.resolve(UserRepositoryProtocol.self, arguments: dataStore!, dataStoreGuest!)
            let translator = container.resolve(UserTranslator.self)
            let usecase    = container.resolve(UserUseCaseProtocol.self, arguments: repository!, translator!)
            let viewModel  = container.resolve(AccountEditViewModel.self, argument: usecase!)
            let vc         = AccountEditViewController.createInstance(viewModel: viewModel!)
            return vc!
        }
        
        container.register(SignInViewController.self) { _ in
            let dataStore  = container.resolve(UserDataStoreProtocol.self)
            let dataStoreGuest  = container.resolve(GuestDataStoreProtocol.self)
            let repository = container.resolve(UserRepositoryProtocol.self, arguments: dataStore!, dataStoreGuest!)
            let translator = container.resolve(UserTranslator.self)
            let usecase    = container.resolve(UserUseCaseProtocol.self, arguments: repository!, translator!)
            let viewModel  = container.resolve(SignInViewModel.self, argument: usecase!)
            let vc         = SignInViewController.createInstance(viewModel: viewModel!)
            return vc!
        }
        
        
        container.register(OrderReviewViewController.self) { _ in
            let dataStoreUser  = container.resolve(UserDataStoreProtocol.self)
            let dataStoreGuest  = container.resolve(GuestDataStoreProtocol.self)
            let repositoryUser = container.resolve(UserRepositoryProtocol.self, arguments: dataStoreUser!,dataStoreGuest!)
            let translatorUser = container.resolve(UserTranslator.self)
            let usecaseUser    = container.resolve(UserUseCaseProtocol.self, arguments: repositoryUser!, translatorUser!)
            
            let dataStoreCart  = container.resolve(ShoppingCartDataStoreProtocol.self)
            let repositoryCart = container.resolve(ShoppingCartRepositoryProtocol.self, argument: dataStoreCart!)
            let translatorCart = container.resolve(ShoppingCartTranslator.self)
            let usecaseCart    = container.resolve(ShoppingCartUseCaseProtocol.self, arguments: repositoryCart!, translatorCart!)
            
            let dataStoreOrder  = container.resolve(OrderDataStoreProtocol.self)
            let repositoryOrder = container.resolve(OrderRepositoryProtocol.self, argument: dataStoreOrder!)
            let translatorOrder = container.resolve(OrderTranslator.self)
            let usecaseOrder    = container.resolve(OrderUseCaseProtocol.self, arguments: repositoryOrder!, translatorOrder!)
            
            let viewModel  = container.resolve(OrderReviewViewModel.self, arguments: usecaseCart!,usecaseUser!, usecaseOrder!)
            let vc         = OrderReviewViewController.createInstance(viewModel: viewModel!)
            return vc!
        }
    }
}
