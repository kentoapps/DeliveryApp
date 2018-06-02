//
//  HomeViewController.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-03-12.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Kingfisher


class HomeViewController: BaseViewController, UICollectionViewDelegate {


    // MARK: - UIView
    
    @IBOutlet weak var topSalesCollectionView: UICollectionView!
    @IBOutlet weak var youMayLikeCollectionView: UICollectionView!
    @IBOutlet weak var newProductsCollectionView: UICollectionView!
    @IBOutlet weak var trendsCollectionView: UICollectionView!
    @IBOutlet weak var banner: UIImageView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    @IBOutlet weak var cartQty: UILabel!
    
    private var shoppingCart = ShoppingCart()
    private var cartViewModel: ShoppingCartViewModel!
    
// MARK: - Instance
    
    private var viewModel: HomeViewModel!
    private let disposeBag: DisposeBag = DisposeBag()
    
    public var keyword: String!

// MARK: - ViewController
    
    static func createInstance(viewModel: HomeViewModel) -> HomeViewController? {
        let instance = UIViewController.initialViewControllerFromStoryBoard(HomeViewController.self)
        instance?.viewModel = viewModel
        return instance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchShoppingCartQty()
        self.navigationController?.isNavigationBarHidden = true
        self.navigationController?.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView(viewModel: viewModel)
        configureCollectionView()
        configureBadgeOnButton()
        viewModel.fetchTopSales()
        viewModel.fetchProductYouMayLike()
        viewModel.fetchNewProducts()
        searchBar.delegate = self
        
        banner.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        banner.addGestureRecognizer(tapRecognizer)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    func imageTapped(sender: UIImageView) {
        self.showAlert(message: "Upcoming feature!")
    }
    
// MARK: - Binding
    
    private func bindView(viewModel: HomeViewModel) {
        viewModel.arrOfTopSalesProduct.asObservable().bind(to: topSalesCollectionView.rx.items(cellIdentifier: CollectionViewCell.Identifier, cellType: CollectionViewCell.self))
        { row, item, cell in
            cell.item = item
            cell.addCart.addTarget(self, action: #selector(self.didTapAddToCart), for: .touchUpInside)
            }.disposed(by: disposeBag)
        
        viewModel.arrOfProductYouMayLike.asObservable().bind(to: youMayLikeCollectionView.rx.items(cellIdentifier: CollectionViewCell.Identifier, cellType: CollectionViewCell.self))
        { row, item, cell in
            cell.item = item
            cell.addCart.addTarget(self, action: #selector(self.didTapAddToCart), for: .touchUpInside)
            }.disposed(by: disposeBag)
        
        viewModel.arrOfNewProducts.asObservable().bind(to: newProductsCollectionView.rx.items(cellIdentifier: CollectionViewCell.Identifier, cellType: CollectionViewCell.self))
        { row, item, cell in
            cell.item = item
            cell.addCart.addTarget(self, action: #selector(self.didTapAddToCart), for: .touchUpInside)
            }.disposed(by: disposeBag)
       
        viewModel.arrOfTrendsKeyword.asObservable().bind(to: trendsCollectionView.rx.items(cellIdentifier: TrendsCell.Identifier, cellType: TrendsCell.self))
        { row, item, cell in
            cell.item = item
            }.disposed(by: disposeBag)
        
        viewModel.alertMessage.asObservable()
            .subscribe(
                onNext: { alertError in self.showAlert(alertError) }
        ).disposed(by: disposeBag)
        
        viewModel.qtyProductsCart.asObservable()
            .bind(to: self.cartQty.rx.text)
            .disposed(by: disposeBag)
    }

    
// MARK: - CollectionView

    private func registerCell() {
        let productCellNib = UINib(nibName: CollectionViewCell.Identifier, bundle: nil)
        topSalesCollectionView.register(productCellNib, forCellWithReuseIdentifier: CollectionViewCell.Identifier)
        youMayLikeCollectionView.register(productCellNib, forCellWithReuseIdentifier: CollectionViewCell.Identifier)
        newProductsCollectionView.register(productCellNib, forCellWithReuseIdentifier: CollectionViewCell.Identifier)
        
        let trendCellNib = UINib(nibName: TrendsCell.Identifier, bundle: nil)
        trendsCollectionView.register(trendCellNib, forCellWithReuseIdentifier: TrendsCell.Identifier)
        
        topSalesCollectionView.delegate = self
        youMayLikeCollectionView.delegate = self
        newProductsCollectionView.delegate = self
        trendsCollectionView.delegate = self
    }

    private func configureCollectionView() {
        registerCell()
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width:180 , height:260)
        layout.sectionInset = UIEdgeInsets(top: 15, left: 5, bottom: 10, right: 5)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        
        youMayLikeCollectionView.setCollectionViewLayout(layout, animated: true)
        newProductsCollectionView.setCollectionViewLayout(layout, animated: true)
        topSalesCollectionView.setCollectionViewLayout(layout, animated: true)
        
        topSalesCollectionView.reloadData()
        youMayLikeCollectionView.reloadData()
        newProductsCollectionView.reloadData()
    }
    
    private func configureBadgeOnButton() {
        cartQty.layer.borderColor = UIColor.clear.cgColor
        cartQty.layer.borderWidth = 2
        cartQty.layer.cornerRadius = cartQty.bounds.size.height / 2
        cartQty.textAlignment = .center
        cartQty.layer.masksToBounds = true
        cartQty.font = cartQty.font.withSize(10)
        cartQty.textColor = .white
        cartQty.backgroundColor = #colorLiteral(red: 0.3882352941, green: 0.6862745098, blue: 0.4431372549, alpha: 1)
        cartQty.tag = 1001
    }
    
    
    @IBAction func goToShoppingCart(_ sender: Any) {
        if Int(viewModel.qtyProductsCart.value) == 0 {
            self.showAlert(title: "projectName.uppercased()", message: "Shopping Cart is empty !")
        } else {
            let next = resolver.resolve(ShoppingCartViewController.self)!
//            self.present(next, animated: true, completion: nil)
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if collectionView == self.trendsCollectionView {
            let cell = collectionView.cellForItem(at: indexPath) as! TrendsCell
            
            let next = resolver.resolve(ProductListViewController.self)!
            next.keyword = ""
            self.navigationController?.pushViewController(next, animated: true)
            
        } else {
            let cell = collectionView.cellForItem(at: indexPath) as! CollectionViewCell
            
            let next = resolver.resolve(ProductDetailViewController.self)!
            next.productId = cell.item!.productId
            self.navigationController?.pushViewController(next, animated: true)
        }
    }
    
    func didTapAddToCart(sender: UIButton) -> Void {
        let cell = sender.superview?.superview?.superview as! CollectionViewCell
        
        let productId = cell.item?.productId
        
        if viewModel.productAlreadyInCart(with: productId!) {
            let projectName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
            self.showAlert(title: projectName.uppercased(), message: "Product already added to cart !")
        } else {
            shoppingCart.idProducts = productId!
            shoppingCart.quantity = 1
            viewModel.addProductShoppingCart(with: shoppingCart)
        }
    }
    
    
    @IBAction func isLogoTapped(_ sender: Any) {
        self.showAlert(message: "Ta-da! We did it, guys! Congratulations to all of us!🎉")
    }
}


// MARK: - SearchBar

extension HomeViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.keyword = searchText
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !self.keyword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            let productListVC = resolver.resolve(ProductListViewController.self)!
            productListVC.keyword = self.keyword!
            present(productListVC, animated: true, completion: nil)
        } else {
            searchBar.endEditing(true)
        }
    }
    
    @IBAction func sideMenuTapped(_ sender: Any) {
        
        let categoryVC = UIStoryboard(name: "Category", bundle: nil).instantiateInitialViewController() as! CategoryViewController
        
        let blurEffect = UIBlurEffect(style: .regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.view.bounds
        
        view.addSubview(blurEffectView)
        
        categoryVC.userTappedCloseButtonClosure = { [weak blurEffectView] in
            blurEffectView?.removeFromSuperview()
        }
        
        //this part needs fix
        categoryVC.userSelectedCategory = { [weak blurEffectView] in
            blurEffectView?.removeFromSuperview()
            let next = resolver.resolve(ProductListViewController.self)!
            next.keyword = ""
            self.navigationController?.pushViewController(next, animated: true)
        }
     
        categoryVC.modalTransitionStyle = .coverVertical
        categoryVC.modalPresentationStyle = .overFullScreen
        
        present(categoryVC, animated: true, completion: nil)
    }
    
    
}


