//
//  CheckoutViewController.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-04-03.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources
import Stripe

class CheckoutViewController: BaseViewController, UITableViewDelegate {
    
    @IBOutlet weak var checkoutTableView: UITableView!
    
    private var viewModel: CheckoutViewModel!
    private let disposeBag: DisposeBag = DisposeBag()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        viewModel.fetchUser()
        checkoutTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        configureTableView()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    
    @IBAction func confirmPayment(_ sender: Any) {
        viewModel.goToPayment()
    }
    
    
    // MARK: - ViewController
    
    static func createInstance(viewModel: CheckoutViewModel) -> CheckoutViewController? {
        let instance = UIViewController.initialViewControllerFromStoryBoard(CheckoutViewController.self)
        instance?.viewModel = viewModel
        return instance
    }
    
    private func bindView() {
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String, User>>(
            configureCell: { (_, tv, indexPath, element) in
                if indexPath.section == 0 {
                    let cell = tv.dequeueReusableCell(withIdentifier: UserInfoCell.Identifier) as! UserInfoCell
                    let element = element
                    cell.item = element
                
                    return cell
                }
                else if indexPath.section == 1 {
                    let cell = tv.dequeueReusableCell(withIdentifier: AddressCell.Identifier) as! AddressCell
                    if element.address != nil {
                        cell.item = element.address!
                        return cell
                    }
                    return cell
                }
                else {
                    let cell = tv.dequeueReusableCell(withIdentifier: PaymentCell.Identifier) as! PaymentCell
                    cell.item = element.payment
                    cell.isHidden = true
                    return cell
                }
        })
        
        checkoutTableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        viewModel.dataForSection.asObservable()
            .bind(to: checkoutTableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)
        
        self.viewModel.alertMessage.asObservable()
            .subscribe(
                onNext: { alertError in self.showAlert(alertError) }
            ).disposed(by: disposeBag)
        
        viewModel.isNonEmpty.asObservable()
            .subscribe(onNext: { isNonEmpty in
                if isNonEmpty {
                    let next = resolver.resolve(OrderReviewViewController.self)!
                    self.navigationController?.pushViewController(next, animated: true)
                }
            }).disposed(by: disposeBag)
    }

    
    private func registerCell() {
        let userInfoCellNib = UINib(nibName: UserInfoCell.Identifier, bundle: nil)
        let addressCellNib = UINib(nibName: AddressCell.Identifier, bundle: nil)
        let paymentCellNib = UINib(nibName: PaymentCell.Identifier, bundle: nil)
        checkoutTableView.register(userInfoCellNib, forCellReuseIdentifier: UserInfoCell.Identifier)
        checkoutTableView.register(addressCellNib, forCellReuseIdentifier: AddressCell.Identifier)
        checkoutTableView.register(paymentCellNib, forCellReuseIdentifier: PaymentCell.Identifier)
    }
    
    private func configureTableView() {
        registerCell()
        checkoutTableView.estimatedRowHeight = 300
        checkoutTableView.allowsSelection = true
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)

        
        if indexPath.section == 0 {
            let userInfoEditVC = resolver.resolve(UserInfoEditViewController.self)!
            userInfoEditVC.isMember = viewModel.isMember.value
            userInfoEditVC.title = "User Information"
            self.navigationController?.pushViewController(userInfoEditVC, animated: true)
        } else if indexPath.section == 1 {
            guard let isMember = viewModel.user.value.first?.isMember else { return }
            
            if isMember {
                if viewModel.user.value.first?.address?.count == 0 || viewModel.user.value.first?.address == nil {
                    let addressEditVC = resolver.resolve(AddressEditViewController.self)!
                    self.navigationController?.pushViewController(addressEditVC, animated: true)
                } else {
                    let addressListVC = resolver.resolve(AddressListViewController.self)!
                    addressListVC.title = "Shipping"
                    self.navigationController?.pushViewController(addressListVC, animated: true)
                }
            } else {
                let addressEditVC = resolver.resolve(AddressEditViewController.self)!

                if viewModel.user.value.first?.address != nil {
                    addressEditVC.indexNumberOfAddress = 0
                } 
                addressEditVC.title = "Shipping"
                self.navigationController?.pushViewController(addressEditVC, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 2))
        return footer
    }
}

//STP Extension
extension CheckoutViewController: STPAddCardViewControllerDelegate {
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
        navigationController?.popViewController(animated: true)
    }
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController, didCreateToken token: STPToken, completion: @escaping STPErrorBlock) {
        //2000 = 20.00 (pass amount as integer for stripe)
        StripeClient.shared.completeCharge(with: token, amount: 7590) { result in
            switch result {
            // 1
            case .success:
                completion(nil)
                
                let alertController = UIAlertController(title: "Congrats", message: "Your payment was successful!", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .default, handler: { _ in
                    self.navigationController?.popViewController(animated: true)
                })
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
            // 2
            case .failure(let error):
                completion(error)
            }
        }
    }
}


