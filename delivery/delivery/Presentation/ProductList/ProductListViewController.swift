//
//  ProductListViewController.swift
//  delivery
//
//  Created by Bacelar on 2018-03-12.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RealmSwift
import RxSwift
import Firebase


class ProductListViewController: BaseViewController, UICollectionViewDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var uiSearchBarView: UIView!
    @IBOutlet weak var uiOrderView: UIView!
    @IBOutlet weak var gridList: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var cartQty: UILabel!
    @IBOutlet weak var orderBy: UIButton!
    
    @IBOutlet weak var dropDown: UIView!
    private let disposeBag: DisposeBag = DisposeBag()
    
    private var productsIds = [Int:String]()
    private var shoppingCart = ShoppingCart()
    public var viewModel: ProductListViewModel!
    private var cartViewModel: ShoppingCartViewModel!
    public var keyword: String = ""
    public var filters = [String:Any]()
    public var lastOrderBy: String!
    public var lastAscDesc: Bool!


    var gridLayout: GridLayout!
    lazy var listLayout: ListLayout = {
        var listLayout = ListLayout(itemHeight: 280)
        return listLayout }()
    
    
    static func createInstance(viewModel: ProductListViewModel) -> ProductListViewController? {
        let instance = UIViewController.initialViewControllerFromStoryBoard(ProductListViewController.self)
        instance?.viewModel = viewModel
        return instance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        viewModel.fetchShoppingCartQty()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.delegate = self
        searchBar.delegate = self
        bindTableView()
        bindCartQty()
        
        lastOrderBy = "name"
        lastAscDesc = false
        orderBy.setTitle("Order by Name: A - Z", for: .normal)
        viewModel.fetchProductList(with: "", by: lastOrderBy, lastAscDesc, filters: filters)
        
        gridLayout = GridLayout(numberOfColumns: 2)
        collectionView.collectionViewLayout = gridLayout
        collectionView.reloadData()
        dropDownShadow()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }

    private func bindCartQty(){
        viewModel.qtyProductsCart.asObservable()
            .bind(to: self.cartQty.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func bindTableView() {
        viewModel.productsList.asObservable()
            .bind(to: collectionView.rx.items(cellIdentifier: ProductsCell.Identifier, cellType: ProductsCell.self))
            { row, product, cell in
                cell.product = product
            }.disposed(by: disposeBag)
    }
    
    
    @IBAction func gridPressed(_ sender: Any) {
        if collectionView.collectionViewLayout == gridLayout {
            // list layout
            gridList.setImage(#imageLiteral(resourceName: "grid"), for: .normal)
            UIView.animate(withDuration: 0.1, animations: {
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.setCollectionViewLayout(self.listLayout, animated: false)
            })
        } else {
            // grid layout
            gridList.setImage(#imageLiteral(resourceName: "list"), for: .normal)
            UIView.animate(withDuration: 0.1, animations: {
                self.collectionView.collectionViewLayout.invalidateLayout()
                self.collectionView.setCollectionViewLayout(self.gridLayout, animated: false)
            })
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        collectionView.collectionViewLayout.invalidateLayout()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ProductsCell
        
        let next = resolver.resolve(ProductDetailViewController.self)!
        next.productId = cell.product?.productId
        navigationController?.pushViewController(next, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == self.collectionView {
            
            let productCell = cell as! ProductsCell
                        
            let addProductCart = UIButton(frame: CGRect(x: cell.bounds.maxX - 50, y:0, width:50,height:50))
            addProductCart.autoresizingMask = [.flexibleLeftMargin, .flexibleBottomMargin]
            addProductCart.setImage(#imageLiteral(resourceName: "addcart"), for: .normal)
            addProductCart.addTarget(self, action: #selector(DidTapAddToCart), for: UIControlEvents.touchUpInside)
            
            addProductCart.tag = indexPath.row + 1
            productsIds[addProductCart.tag] = productCell.product?.productId
            
            cell.addSubview(addProductCart)
        }
    }
    
    func DidTapAddToCart(sender: UIButton?) -> Void {
        
        let myPrimaryKey = productsIds[sender!.tag]

        if viewModel.productAlreadyInCart(with: myPrimaryKey!) {
            let projectName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
            let alertController = UIAlertController(title: projectName.uppercased(), message:
                "Product already added to cart !", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,handler: nil))
            
            present(alertController, animated: true, completion: nil)
            
        } else {
            shoppingCart.idProducts = productsIds[sender!.tag]!
            shoppingCart.quantity = 1
            shoppingCart.id = sender!.tag
            viewModel.addProductShoppingCart(with: shoppingCart)
        }
    }
    
    @IBAction func shoppingCartTapped(_ sender: Any) {
        print("shoppingCartTapped \(viewModel.qtyProductsCart.value)")
        if Int(viewModel.qtyProductsCart.value) == 0 {
            let projectName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as! String
            let alertController = UIAlertController(title: projectName.uppercased(), message:
                "Shopping Cart is empty !", preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel,handler: nil))
            
            present(alertController, animated: true, completion: nil)
        } else {
        
            let next = resolver.resolve(ShoppingCartViewController.self)!
            navigationController?.pushViewController(next, animated: true)
        }
    }

    @IBAction func didTapOrderBy(_ sender: Any) {
        viewOrUnviewDropDown()
    }
    
    func dropDownShadow() {
        dropDown.backgroundColor = UIColor.white
        dropDown.layer.shadowColor = UIColor.lightGray.cgColor
        dropDown.layer.shadowOpacity = 1
        dropDown.layer.shadowOffset = CGSize(width: 7.0, height: 7.0)
        dropDown.layer.shadowRadius = 5
    }
    
    
    @IBAction func didTapOrderAZ(_ sender: Any) {
        lastOrderBy = "name"
        lastAscDesc = false
        fetchProductListFromDataStore(searchFor: "", orderBy: lastOrderBy, ascDesc: lastAscDesc)
        viewOrUnviewDropDown()
        orderBy.setTitle("Order by Name: A - Z", for: .normal)
    }
    
    @IBAction func didTapOrderZA(_ sender: Any) {
        lastOrderBy = "name"
        lastAscDesc = true
        fetchProductListFromDataStore(searchFor: "", orderBy: lastOrderBy, ascDesc: lastAscDesc)
        viewOrUnviewDropDown()
        orderBy.setTitle("Order by Name: Z - A", for: .normal)
    }
    
    @IBAction func didTapOrderLowHigh(_ sender: Any) {
        lastOrderBy = "price"
        lastAscDesc = false
        fetchProductListFromDataStore(searchFor: "", orderBy: lastOrderBy, ascDesc: lastAscDesc)
        viewOrUnviewDropDown()
        orderBy.setTitle("Order by Price: Low to High", for: .normal)
    }
    @IBAction func didTapOrderHighLow(_ sender: Any) {
        lastOrderBy = "price"
        lastAscDesc = true
        fetchProductListFromDataStore(searchFor: "", orderBy: lastOrderBy, ascDesc: lastAscDesc)
        viewOrUnviewDropDown()
        orderBy.setTitle("Order by Price: High to Low", for: .normal)
    }
    
    func viewOrUnviewDropDown(){
        if dropDown.isHidden {
            dropDown.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.dropDown.alpha = 1
            }, completion:  nil)
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.dropDown.alpha = 0
            }, completion:  {
                (value: Bool) in
                self.dropDown.isHidden = true
            })
        }
    }
    
    func fetchProductListFromDataStore(searchFor: String, orderBy field: String, ascDesc: Bool){
        viewModel.fetchProductList(with: searchFor, by: field, ascDesc, filters: filters)
        collectionView.reloadData()
    }
    

    @IBAction func didTapFilter(_ sender: Any) {
        let storyBoard : UIStoryboard = UIStoryboard(name: "ProductsFilter", bundle:nil)
        
        let popUpViewController = storyBoard.instantiateViewController(withIdentifier: "FilterPopUp") as! ProductsFilterController
        
        popUpViewController.modalPresentationStyle = .overCurrentContext
        popUpViewController.modalTransitionStyle = .flipHorizontal
        popUpViewController.delegate = self
        
        present(popUpViewController, animated:true, completion:nil)
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


extension ProductListViewController: filterDelegate {
    func getFilter(with filter: [String : Any]) {
        filters = filter
        viewModel.fetchProductList(with: self.keyword, by: self.lastOrderBy!, self.lastAscDesc!, filters: filter)
        collectionView.reloadData()
    }
}

extension ProductListViewController: UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        self.keyword = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if !self.keyword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            fetchProductListFromDataStore(searchFor: self.keyword, orderBy: self.lastOrderBy!, ascDesc: self.lastAscDesc!)
        } else {
            fetchProductListFromDataStore(searchFor: "", orderBy: self.lastOrderBy!, ascDesc: self.lastAscDesc!)
            searchBar.endEditing(true)
        }
    }
}
