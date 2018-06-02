//
//  ProductDetailViewController.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/05.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Cosmos

class ProductDetailViewController: BaseViewController, UICollectionViewDelegate {
    // MARK: - IBOutlet
    // Overview
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var pageControls: UIPageControl!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var originalPriceLabel: UILabel!
    @IBOutlet weak var discoutRateLabel: UILabel!
    
    @IBOutlet weak var ratingStars: CosmosView!
    @IBOutlet weak var ratingNum: UILabel!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    // Review
    @IBOutlet weak var reviewRatingStars: CosmosView!
    @IBOutlet weak var reviewRatingLabel: UILabel!
    @IBOutlet weak var reviewRatingNumLabel: UILabel!
    @IBOutlet weak var review1: UIView!
    @IBOutlet weak var review1TitleLabel: UILabel!
    @IBOutlet weak var review1UserNameLabel: UILabel!
    @IBOutlet weak var review1RatingStars: CosmosView!
    @IBOutlet weak var review1CommentLabel: UILabel!
    @IBOutlet weak var review2: UIView!
    @IBOutlet weak var review2TitleLabel: UILabel!
    @IBOutlet weak var review2UserNameLabel: UILabel!
    @IBOutlet weak var review2RatingStars: CosmosView!
    @IBOutlet weak var review2CommentLabel: UILabel!
    @IBOutlet weak var reviewViewMoreButton: UIButton!
    
    // Recommended products
    @IBOutlet weak var frequentlyCollection: UICollectionView!
    @IBOutlet weak var relatedCollection: UICollectionView!
    
    // Bottom view
    @IBOutlet weak var numOfProduct: UILabel!
    
    // MARK: - Public Properties
    public var viewModel: ProductDetailViewModel!
    public var productId: String!
    
    var pageViewController: UIPageViewController?
    var vcArray = [ProductImageViewController]()
    
    var mainImageCellHeight: CGFloat {
        return view.frame.width
    }

    // MARK: - Private Properties
    private let disposeBag: DisposeBag = DisposeBag()
    
    private lazy var mainImageCollectionViewlayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 380)
        layout.minimumLineSpacing = 0
        return layout
    }()
    
    private lazy var productCollectionViewlayout: UICollectionViewFlowLayout = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width:180 , height:200)
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 1.0
        layout.minimumInteritemSpacing = 1.0
        return layout
    }()

    // MARK: - Static Fuctions
    static func createInstance(viewModel: ProductDetailViewModel) -> ProductDetailViewController? {
        let instance = UIViewController.initialViewControllerFromStoryBoard(ProductDetailViewController.self)
        instance?.viewModel = viewModel
        return instance
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        setup()
        bindView()
        review1.isHidden = true
        review2.isHidden = true
        reviewViewMoreButton.isHidden = true
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        
        viewModel.fetchShoppingCartQty()
    }

    // MARK: - Private Fuctions
    private func fetch() {
        viewModel.fetchProductDetail(productId)
        viewModel.fetchFrequentlyPurchasedWith(productId)
        viewModel.fetchRelatedTo(productId)
    }
    
    private func setup() {
        imageCollection.isPagingEnabled = true
        imageCollection.showsHorizontalScrollIndicator = false
        imageCollection.setCollectionViewLayout(mainImageCollectionViewlayout, animated: false)
        
        imageCollection.delegate = self
        
        pageControls.hidesForSinglePage = true
        
        frequentlyCollection.setCollectionViewLayout(productCollectionViewlayout, animated: true)
        relatedCollection.setCollectionViewLayout(productCollectionViewlayout, animated: true)
        frequentlyCollection.delegate = self
        relatedCollection.delegate = self
        
        registerCell()
        
        navigationItem.addShoppingCart()
            .addTarget(self, action: #selector(shoppingCartButtonTapped), for: .touchUpInside)
        
        // Make the background of NavigationController transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    private func bindView() {
        viewModel.images.asObservable()
            .bind(to: imageCollection.rx.items(cellIdentifier: ProductImageCell.Identifier, cellType: ProductImageCell.self))
            { row, imageUrl, cell in
                cell.imageUrl = imageUrl
            }.disposed(by: disposeBag)
        viewModel.images.asObservable().subscribe(
            onNext: { images in
                self.pageControls.numberOfPages = images.count
        }).disposed(by: disposeBag)
        viewModel.name.asObservable()
            .bind(to: nameLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.price.asObservable()
            .bind(to: priceLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.originalPrice.asObservable()
            .bind(to: originalPriceLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.reviewAverage.asObservable()
            .bind(to: ratingStars.rx_rating)
            .disposed(by: disposeBag)
        viewModel.reviewNum.asObservable()
            .bind(to: ratingNum.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.description.asObservable()
            .bind(to: descriptionLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Review
        viewModel.reviewAverage.asObservable()
            .bind(to: reviewRatingStars.rx_rating)
            .disposed(by: disposeBag)
        viewModel.reviewAverage.asObservable()
            .map { num in String(num) }
            .bind(to: reviewRatingLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.reviewNum.asObservable()
            .bind(to: reviewRatingNumLabel.rx.text)
            .disposed(by: disposeBag)
        
        // Reviews
        viewModel.review1Title.asObservable()
            .subscribe(
                onNext: { if !$0.isEmpty { self.review1.isHidden = false } }
            ).disposed(by: disposeBag)
        viewModel.review1Title.asObservable()
            .bind(to: review1TitleLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.review1User.asObservable()
            .bind(to: review1UserNameLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.review1Rating.asObservable()
            .bind(to: review1RatingStars.rx_rating)
            .disposed(by: disposeBag)
        viewModel.review1Comment.asObservable()
            .bind(to: review1CommentLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.review2Title.asObservable()
            .subscribe(
                onNext: { if !$0.isEmpty { self.review2.isHidden = false } }
            ).disposed(by: disposeBag)
        viewModel.review2Title.asObservable()
            .bind(to: review2TitleLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.review2User.asObservable()
            .bind(to: review2UserNameLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.review2Rating.asObservable()
            .bind(to: review2RatingStars.rx_rating)
            .disposed(by: disposeBag)
        viewModel.review2Comment.asObservable()
            .bind(to: review2CommentLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.reviewMore.asObservable()
            .subscribe(
                onNext: { if $0 { self.reviewViewMoreButton.isHidden = false } }
            ).disposed(by: disposeBag)
        
        // Recommended Products
        viewModel.relatedTo.asObservable() // TODO: It is supposed to bind frequentlyPurchasedWith
            .bind(to: frequentlyCollection.rx.items(
                cellIdentifier: CollectionViewCell.Identifier,
                cellType: CollectionViewCell.self))
            { row, item, cell in
                cell.item = item
            }.disposed(by: disposeBag)
        viewModel.relatedTo.asObservable()
            .bind(to: relatedCollection.rx.items(
                cellIdentifier: CollectionViewCell.Identifier,
                cellType: CollectionViewCell.self))
            { row, item, cell in
                cell.item = item
            }.disposed(by: disposeBag)
        
        // Bottom view
        viewModel.numOfProduct.asObservable()
            .map { num in String(num) }
            .bind(to: numOfProduct.rx.text)
            .disposed(by: disposeBag)
        
        // ShoppingCart
        viewModel.numOfProducntInShoppingCart.asObservable()
            .subscribe(
                onNext: { num in self.navigationItem.updateShoppingCart(num: num) }
            ).disposed(by: disposeBag)
        viewModel.onCompleteAddingMessage.asObservable()
            .subscribe(
                onNext: { msg in
                    self.showAlert(message: msg)
                    self.viewModel.fetchShoppingCartQty()
            }
            ).disposed(by: disposeBag)
        
        // Alert Message
        viewModel.alertMessage.asObservable()
            .subscribe(
                onNext: { alertError in self.showAlert(alertError) }
            ).disposed(by: disposeBag)
    }
    
    private func registerCell() {
        let productImageNib = UINib(nibName: ProductImageCell.Identifier, bundle: nil)
        imageCollection.register(productImageNib, forCellWithReuseIdentifier: ProductImageCell.Identifier)
        
        let productNib = UINib(nibName: CollectionViewCell.Identifier, bundle: nil)
        frequentlyCollection.register(productNib, forCellWithReuseIdentifier: CollectionViewCell.Identifier)
        relatedCollection.register(productNib, forCellWithReuseIdentifier: CollectionViewCell.Identifier)
    }
    
    @objc private func shoppingCartButtonTapped(_ sender: Any) {
        let next = resolver.resolve(ShoppingCartViewController.self)!
        self.navigationController?.pushViewController(next, animated: true)
    }

    // MARK: - Collection Delegate
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        self.pageControls.currentPage = (Int(collectionView.contentOffset.x) / Int(collectionView.frame.width))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else { return }
        
        let next = resolver.resolve(ProductDetailViewController.self)!
        next.productId = cell.item!.productId
        self.navigationController?.pushViewController(next, animated: true)
    }

    // MARK: - IBAction
    @IBAction func writeReviewButtonPressed(_ sender: Any) {
        let next = resolver.resolve(ReviewPostViewController.self)!
        next.productId = productId
        next.refreshProduct = fetch
        present(next, animated: true, completion: nil)
    }
    
    @IBAction func reviewListButtonPressed(_ sender: Any) {
        let next = resolver.resolve(ReviewListViewController.self)!
        next.productId = productId
        present(next, animated: true, completion: nil)
    }
    
    @IBAction func incrementButtonPressed(_ sender: Any) {
        viewModel.changeNumOfProduct(isIncrement: true)
    }

    @IBAction func decrementButtonPressed(_ sender: Any) {
        viewModel.changeNumOfProduct(isIncrement: false)
    }
    
    @IBAction func addToCartButton(_ sender: Any) {
        viewModel.addToCart(productId)
    }
}
