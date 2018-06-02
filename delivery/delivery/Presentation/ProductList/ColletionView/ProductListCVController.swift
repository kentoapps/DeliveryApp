//
//  ProductListCVController.swift
//  delivery
//
//  Created by Bacelar on 2018-03-27.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Firebase


class ProductListCVController: BaseViewController {
    
    @IBOutlet weak var productListCV: UICollectionView!
    private let disposeBag: DisposeBag = DisposeBag()
    private var viewModel: ProductListViewModel!
    
    static func createInstance(viewModel: ProductListViewModel) -> ProductListCVController? {
        let instance = UIViewController.initialViewControllerFromStoryBoard(ProductListCVController.self)
        instance?.viewModel = viewModel
        return instance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        configureTableView()
        viewModel.fetchProductList()
    }
    
    private func bindView() {
        viewModel.productsList.asObservable()
            .bind(to: productListCV.rx.items(cellIdentifier: ProductCellCV.Identifier, cellType: ProductCellCV.self))
            { row, product, cell in
                cell.product = product
            }.disposed(by: disposeBag)
    }
    
    private func registerCell() {
        let nib = UINib(nibName: ProductCellCV.Identifier, bundle: nil)
        productListCV.register(nib, forCellWithReuseIdentifier: ProductCellCV.Identifier)
//        productListCV.register(nib, forCellReuseIdentifier: ProductCellCV.Identifier)
    }
    
    private func configureTableView() {
        registerCell()
        productListCV.showsVerticalScrollIndicator = false
//        productListCV.rowHeight = 156
    }
    
}
