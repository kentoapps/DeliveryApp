//
//  AddressEditViewController.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-04-05.
//  Copyright © 2018 CICCC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AddressEditViewController: BaseViewController {

    private var viewModel: AddressEditViewModel!
    
    @IBOutlet var textFields: [UITextField]!
    @IBOutlet weak var receiverLabel: UITextField!
    @IBOutlet weak var addressLabel1: UITextField!
    @IBOutlet weak var addressLabel2: UITextField!
    @IBOutlet weak var cityLabel: UITextField!
    @IBOutlet weak var zipLabel: UITextField!
    @IBOutlet weak var phoneNumberLabel: UITextField!
    
    @IBOutlet weak var provinceField: UIView!
    @IBOutlet var provinceButtons: [UIButton]!
    @IBOutlet weak var provinceLabel: UITextField!
    
    @IBOutlet weak var countryField: UIView!
    @IBOutlet var countryButtons: [UIButton]!
    @IBOutlet weak var countryLabel: UITextField!
    
    public var indexNumberOfAddress: Int?
    
    private let disposeBag: DisposeBag = DisposeBag()

    
    static func createInstance(viewModel: AddressEditViewModel) -> AddressEditViewController? {
        let instance = UIViewController.initialViewControllerFromStoryBoard(AddressEditViewController.self)
        instance?.viewModel = viewModel
        return instance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        doneButtonItem.tintColor = .black
        self.navigationItem.rightBarButtonItem = doneButtonItem
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButtonTapped))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields()
        setAddressFields()
    }
    
    
    // MARK: - IBAction functions


    @IBAction func selectDropdownProvince(_ sender: Any) {
        countryButtons.forEach { (button) in
            button.isHidden = true
        }
        provinceButtons.forEach { (button) in
            UIView.animate(withDuration: 0.5, animations: {
                button.isHidden =
                    !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func selectProvince(_ sender: UIButton) {
        provinceLabel.text = sender.currentTitle!
        provinceButtons.forEach { (button) in
            button.isHidden = true
        }
    }
    

    @IBAction func selectDropdownCountry(_ sender: Any) {
        provinceButtons.forEach { (button) in
            button.isHidden = true
        }
        countryButtons.forEach { (button) in
            UIView.animate(withDuration: 3, animations: {
                button.isHidden =
                    !button.isHidden
                self.view.layoutIfNeeded()
            })
        }
    }
    
    @IBAction func selectCountry(_ sender: UIButton) {
        countryLabel.text = sender.currentTitle
        countryButtons.forEach { (button) in
            button.isHidden = true
        }
    }
    
    
    func doneButtonTapped(_ sender: Any) {
        if !(receiverLabel.text?.trimmingCharacters(in: .whitespaces).isEmpty)! &&
            !(addressLabel1.text?.trimmingCharacters(in: .whitespaces).isEmpty)! &&
            !(addressLabel2.text?.trimmingCharacters(in: .whitespaces).isEmpty)! &&
            !(cityLabel.text?.trimmingCharacters(in: .whitespaces).isEmpty)! &&
            !(zipLabel.text?.trimmingCharacters(in: .whitespaces).isEmpty)! &&
            !(phoneNumberLabel.text?.trimmingCharacters(in: .whitespaces).isEmpty)! &&
            !(provinceLabel.text?.trimmingCharacters(in: .whitespaces).isEmpty)! &&
            !(countryLabel.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            
            viewModel.address1.value = addressLabel1.text!
            viewModel.address2.value = addressLabel2.text!
            viewModel.city.value = cityLabel.text!
            viewModel.country.value = countryLabel.text!
            viewModel.phoneNumber.value = phoneNumberLabel.text!
            viewModel.province.value = provinceLabel.text!
            viewModel.receiver.value = receiverLabel.text!
            viewModel.zipCode.value = zipLabel.text!
            
            if let indexNo = self.indexNumberOfAddress {
                viewModel.indexOfAddressOnEdit = indexNo
        
                viewModel.updateAddress().subscribe(onCompleted: {
                    self.navigationController?.popViewController(animated: true)
                }) { (err) in
                    print(err)
                    }.disposed(by: disposeBag)
            } else {
                viewModel.updateAddress().subscribe(onCompleted: {
                    self.navigationController?.popViewController(animated: true)
                }) { (err) in
                    print(err)
                    }.disposed(by: disposeBag)
            }
            
        } else {
            self.showAlert(title: "Reminder", message: "Please fille out every field!")
        }
    }
    
    
    // MARK: - Configuration before View Loaded

    
    func configureTextFields() {
        textFields.forEach { (textField) in
            textField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
            textField.layer.borderWidth = 1
        }
        
        self.provinceField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.provinceField.layer.borderWidth = 1
        
        self.countryField.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        self.countryField.layer.borderWidth = 1

    }
    
    func setAddressFields() {
        print(viewModel.address.value)
        if let index = self.indexNumberOfAddress {
            viewModel.fetchAddress(index: index)
            viewModel.address.asObservable().bind { (add) in
                self.receiverLabel.text = add.first?.receiver
                self.addressLabel1.text = add.first?.address1
                self.addressLabel2.text = add.first?.address2
                self.cityLabel.text = add.first?.city
                self.zipLabel.text = add.first?.postalCode
                self.phoneNumberLabel.text = add.first?.phoneNumber
                self.provinceLabel.text = add.first?.province
                self.countryLabel.text = add.first?.country
                self.provinceLabel.textAlignment = .center
                self.provinceLabel.textAlignment = .center
            }.disposed(by: disposeBag)
        }
    }
    
    func cancelButtonTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
