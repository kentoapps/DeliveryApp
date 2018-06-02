//
//  ReviewListViewController.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/23.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class ReviewListViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var productId: String!
    
    private var viewModel: ReviewListViewModel!
    private let disposeBag: DisposeBag = DisposeBag()
    
    static func createInstance(viewModel: ReviewListViewModel) -> ReviewListViewController? {
        let instance = UIViewController.initialViewControllerFromStoryBoard(ReviewListViewController.self)
        instance?.viewModel = viewModel
        return instance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        configureTableView()
        viewModel.fetchReviewList(productId: productId)
    }
    
    private func bindView() {
        viewModel.reviewList.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: ReviewCell.Identifier, cellType: ReviewCell.self))
            { row, review, cell in
                cell.review = review
            }.disposed(by: disposeBag)
    }
    
    private func registerCell() {
        let nib = UINib(nibName: ReviewCell.Identifier, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: ReviewCell.Identifier)
    }
    
    private func configureTableView() {
        registerCell()
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    @IBAction func closeButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
}
