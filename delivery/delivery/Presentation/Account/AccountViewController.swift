//
//  AccountViewController.swift
//  delivery
//
//  Created by Diego H. Vanni on 2018-03-13.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class AccountViewController: BaseViewController {
    
//    @IBOutlet weak var accountTableView: UITableView!
    
    private var viewModel: AccountViewModel!
    private let disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak var profileImgContainer: UIView!
    
    @IBOutlet weak var fullnameLabel: UILabel!
    @IBOutlet weak var birthDateLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var pointLabel: UILabel!
    
    @IBOutlet weak var receiverLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var postalCodeLabel: UILabel!
    
    @IBOutlet weak var cardholderLabel: UILabel!
    @IBOutlet weak var cardNumberLabel: UILabel!
    @IBOutlet weak var expiryDateLabel: UILabel!

    static func createInstance(viewModel: AccountViewModel) -> AccountViewController? {
        let instance = UIViewController.initialViewControllerFromStoryBoard(AccountViewController.self)
        instance?.viewModel = viewModel
        return instance
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView() // bind data
        profileImgContainer.layer.cornerRadius = 49
        profileImgContainer.clipsToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        viewModel.fetchUser()
    }

    private func bindView() {
        viewModel.fullName.asObservable()
            .bind(to: fullnameLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.dateOfBirth.asObservable()
            .bind(to: birthDateLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.mobileNumber.asObservable()
            .bind(to: phoneNumberLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.email.asObservable()
            .bind(to: emailLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.totalPoint.asObservable()
            .bind(to: pointLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.address.asObservable()
            .bind(to: addressLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.receiver.asObservable()
            .bind(to: receiverLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.postalCode.asObservable()
            .bind(to: postalCodeLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.cardholder.asObservable()
            .bind(to: cardholderLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.cardNumber.asObservable()
            .bind(to: cardNumberLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.expiryDate.asObservable()
            .bind(to: expiryDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.isMember.asObservable()
            .subscribe(onNext: { isMember in
                if !isMember {
                    let signInVC = resolver.resolve(SignInViewController.self)!
                    signInVC.onComplete = self.onCompleteSignIn
                    self.navigationController?.pushViewController(signInVC, animated: false)
                }
            }).disposed(by: disposeBag)
        
        viewModel.alertMessage.asObservable()
            .subscribe(
                onNext: { alertError in self.showAlert(alertError) }
            ).disposed(by: disposeBag)
    }
    
    @IBAction func toEditProfile(_ sender: Any) {
        let accountEditVC = resolver.resolve(AccountEditViewController.self)!
        self.navigationController?.pushViewController(accountEditVC, animated: true)
    }
    
    
    @IBAction func editAddress(_ sender: Any) {
        if viewModel.user.value.first?.address != nil {
            let next = resolver.resolve(AddressListViewController.self)!
            self.navigationController?.pushViewController(next, animated: true)
        } else {
            let addressEditVC = resolver.resolve(AddressEditViewController.self)!
            self.navigationController?.pushViewController(addressEditVC, animated: true)
        }
    }
    
    
    @IBAction func actuallyItWasForSignIn(_ sender: Any) {
        viewModel.signOut()
        let signInVC = resolver.resolve(SignInViewController.self)!
        signInVC.onComplete = onCompleteSignIn
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    
    private func onCompleteSignIn(isMember: Bool) {
        if isMember {
            navigationController?.popToRootViewController(animated: true)
        } else {
            tabBarController?.selectedIndex = 0
        }
    }
}

