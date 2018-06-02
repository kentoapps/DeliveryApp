//
//  ReviewPostViewController.swift
//  delivery
//
//  Created by Kento Uchida on 2018/05/11.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import Cosmos

class ReviewPostViewController: BaseViewController {
    
    @IBOutlet weak var ratingStar: CosmosView!
    @IBOutlet weak var userNameFeild: UITextField!
    @IBOutlet weak var titleFeild: UITextField!
    @IBOutlet weak var commentField: UITextView!
    var productId: String!
    var refreshProduct: (() -> Void)?
    
    private var viewModel: ReviewPostViewModel!
    private let disposeBag: DisposeBag = DisposeBag()
    
    static func createInstance(viewModel: ReviewPostViewModel) -> ReviewPostViewController? {
        let instance = UIViewController.initialViewControllerFromStoryBoard(ReviewPostViewController.self)
        instance?.viewModel = viewModel
        return instance
    }
    override func viewDidLoad() {
        setup()
        bind()
        fetch()
    }
    
    private func setup() {
        titleFeild.layer.cornerRadius = 5
        titleFeild.layer.borderColor = UIColor.lightGray.cgColor
        titleFeild.layer.borderWidth = 1
        commentField.layer.cornerRadius = 5
        commentField.layer.borderColor = UIColor.lightGray.cgColor
        commentField.layer.borderWidth = 1
    }
    
    private func bind() {
        viewModel.rating.asObservable()
            .bind(to: ratingStar.rx_rating)
            .disposed(by: disposeBag)
        viewModel.userName.asObservable()
            .bind(to: userNameFeild.rx.text)
            .disposed(by: disposeBag)
        viewModel.title.asObservable()
            .bind(to: titleFeild.rx.text)
            .disposed(by: disposeBag)
        viewModel.comment.asObservable()
            .bind(to: commentField.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isComplete.asObservable()
            .subscribe(onNext: { isComplete in
                if isComplete {
                    self.dismiss(animated: true)
                    self.refreshProduct?()
                }
                
            })
            .disposed(by: disposeBag)
        
        // Alert Message
        viewModel.alertMessage.asObservable()
            .subscribe(
                onNext: { alertError in self.showAlert(alertError) }
            ).disposed(by: disposeBag)
    }
    
    private func fetch() {
        viewModel.fetchReview(productId: productId)
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func postButtonPressed(_ sender: Any) {
        viewModel.postReivew(productId: productId, userName: userNameFeild.text, rating: ratingStar.rating, title: titleFeild.text, comment: commentField.text)
    }
}
