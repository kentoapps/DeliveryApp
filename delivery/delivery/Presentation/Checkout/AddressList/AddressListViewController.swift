//
//  Checkout2.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-04-20.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class AddressListViewController: UIViewController, UITableViewDelegate {

    @IBOutlet weak var addressTableView: UITableView!
    
    private var viewModel: AddressListViewModel!
    private let disposeBag: DisposeBag = DisposeBag()
    
    static func createInstance(viewModel: AddressListViewModel) -> AddressListViewController? {
        let instance = UIViewController.initialViewControllerFromStoryBoard(AddressListViewController.self)
        instance?.viewModel = viewModel
        return instance
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
        
        viewModel.fetchAddressList()
        addressTableView.reloadData()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerCell()
        bindView()
        viewModel.fetchAddressList()
        addressTableView.delegate = self
    }
    
    func registerCell() {
        let nib = UINib(nibName: AddressListCell.Identifier, bundle: nil)
        addressTableView.register(nib, forCellReuseIdentifier: AddressListCell.Identifier)
        addressTableView.allowsSelection = false
    }

    func bindView() {
        viewModel.addressList
                 .asObservable().bind(to: addressTableView.rx.items(cellIdentifier: AddressListCell.Identifier, cellType: AddressListCell.self))
        { row, item, cell in
            cell.item = item

            cell.editButton.addTarget(self, action: #selector(self.editButtonTapped), for: UIControlEvents.touchUpInside)
            
            cell.deleteButton.addTarget(self, action: #selector(self.deleteButtonTapped), for: UIControlEvents.touchUpInside)
            
            cell.radioButton.addTarget(self, action: #selector(self.radioButtonSelected), for: UIControlEvents.touchUpInside)
            
            }.disposed(by: disposeBag)
    }
    
    func editButtonTapped(sender: UIButton) {
        let cell: AddressListCell = (sender.superview?.superview?.superview) as! AddressListCell
        
        let index : IndexPath = self.addressTableView.indexPath(for: cell)!

        let addressEditVC = resolver.resolve(AddressEditViewController.self)!
        addressEditVC.indexNumberOfAddress = index.row
        self.navigationController?.pushViewController(addressEditVC, animated: true)
    }
    
    func deleteButtonTapped(sender: UIButton) {
        let cell: AddressListCell = (sender.superview?.superview?.superview) as! AddressListCell
        let index : IndexPath = self.addressTableView.indexPath(for: cell)!

        if viewModel.addressList.value.count != 1 {
            viewModel.deleteAddressAtSelectedIndex(index: index.row)
        } else {
            self.showAlert(title: "Reminder", message: "At least one address should be registerd")
        }
    }

    func radioButtonSelected(sender: UIButton) {
        let cell: AddressListCell = (sender.superview?.superview) as! AddressListCell
        let index : IndexPath = self.addressTableView.indexPath(for: cell)!
        
        viewModel.changeDefaultAddress(row: index.row)
    }

    @IBAction func addButtonTapped(_ sender: Any) {
        let addressEditVC = resolver.resolve(AddressEditViewController.self)!
        self.navigationController?.pushViewController(addressEditVC, animated: true)
    }
    
    @IBAction func doneButtonTapped(_ sender: Any) {
        viewModel.updateAddressList().subscribe(onCompleted: {
            self.addressTableView.reloadInputViews()
            self.navigationController?.popViewController(animated: true)
        }, onError: { (err) in
            self.showAlert(title: "Error", message: err.localizedDescription)
        })
    }
    
    func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
