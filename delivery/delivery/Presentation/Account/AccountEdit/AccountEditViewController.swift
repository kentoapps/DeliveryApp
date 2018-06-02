//
//  AccountEditViewController.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-05-10.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class AccountEditViewController: BaseViewController {

    private var viewModel: AccountEditViewModel!
    private let disposeBag: DisposeBag = DisposeBag()
    
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!
    @IBOutlet weak var birthDateLabel: UITextField!
    @IBOutlet weak var phoneNumberLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    
    let picker = UIDatePicker()
    
    static func createInstance(viewModel: AccountEditViewModel) -> AccountEditViewController? {
        let instance = UIViewController.initialViewControllerFromStoryBoard(AccountEditViewController.self)
        instance?.viewModel = viewModel
        return instance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        doneButtonItem.tintColor = #colorLiteral(red: 0.3882352941, green: 0.6862745098, blue: 0.4431372549, alpha: 1)
        self.navigationItem.rightBarButtonItem = doneButtonItem
        viewModel.fetchUser()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        createDatePicker()
    }

    func bindView() {
        viewModel.firstName.asObservable()
            .bind(to: firstNameLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.lastName.asObservable()
            .bind(to: lastNameLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.phoneNumber.asObservable()
            .bind(to: phoneNumberLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.email.asObservable()
            .bind(to: emailLabel.rx.text)
            .disposed(by: disposeBag)
        viewModel.birthDate.asObservable()
            .bind(to: birthDateLabel.rx.text)
            .disposed(by: disposeBag)
        
        viewModel.alertMessage.asObservable()
            .subscribe(
                onNext: { alertError in self.showAlert(alertError) }
            ).disposed(by: disposeBag)
        
        viewModel.isSaved.asObservable()
            .subscribe(
                onNext: { isSaved in
                    if isSaved {
                    self.showAlert(message: "Successfully Changed!")
                    }
                })
            .disposed(by: disposeBag)
    }
    
    func createDatePicker() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(updateBirthDate))
        toolBar.setItems([done], animated: false)
        
        picker.datePickerMode = .date
        
        birthDateLabel.inputAccessoryView = toolBar
        birthDateLabel.inputView = picker
    }
    
    
    func updateBirthDate() {
        birthDateLabel.text = DateFormatter.birthDateInFormat(birthDate: picker.date)
        self.view.endEditing(true)
    }
    
    func doneButtonTapped() {
        if !(firstNameLabel.text?.trimmingCharacters(in: .whitespaces).isEmpty)! &&
            !(lastNameLabel.text?.trimmingCharacters(in: .whitespaces).isEmpty)! &&
            !(emailLabel.text?.trimmingCharacters(in: .whitespaces).isEmpty)! &&
            !(phoneNumberLabel.text?.trimmingCharacters(in: .whitespaces).isEmpty)! &&
            !(passwordLabel.text?.trimmingCharacters(in: .whitespaces).isEmpty)! {
            viewModel.firstName.accept(firstNameLabel.text!)
            viewModel.lastName.accept(lastNameLabel.text!)
            viewModel.email.accept(emailLabel.text!)
            viewModel.phoneNumber.accept(phoneNumberLabel.text!)
            
            if let birthDateString = birthDateLabel.text {
                viewModel.birthDate.accept(birthDateString)
            }
            
            viewModel.updateUser(password: passwordLabel.text!).subscribe(onCompleted: {
                self.navigationController?.popViewController(animated: true)})
            { (err) in
                self.showAlert(message: err.localizedDescription)
            }
        } else {
            self.showAlert(message: "All fields are mandatory!")
        }
    }
    
    
    @IBAction func changePassword(_ sender: Any) {
        self.showPasswordInput() { currentPW, confirmedPW, newPW in
            
            if let currentPW = currentPW, let confirmedPW = confirmedPW, let newPW = newPW {
            self.viewModel.changePassword(currentPW: currentPW, confirmedPW: confirmedPW, newPW: newPW)
            }
        }
    }
}
