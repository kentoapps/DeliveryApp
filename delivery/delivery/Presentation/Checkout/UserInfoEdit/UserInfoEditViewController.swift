//
//  UserInfoEditViewController.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-04-26.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class UserInfoEditViewController: UIViewController {
    
    @IBOutlet var userInfoTextFields: [UITextField]!
    
    @IBOutlet weak var firstNameLabel: UITextField!
    @IBOutlet weak var lastNameLabel: UITextField!
    @IBOutlet weak var phoneNumberLabel: UITextField!
    @IBOutlet weak var emailLabel: UITextField!
    
    var isMember: Bool?
    
    private var viewModel: UserInfoEditViewModel!
    private let disposeBag: DisposeBag = DisposeBag()
    
    static func createInstance(viewModel: UserInfoEditViewModel) -> UserInfoEditViewController? {
        let instance = UIViewController.initialViewControllerFromStoryBoard(UserInfoEditViewController.self)
        instance?.viewModel = viewModel
        return instance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        let doneButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTapped))
        doneButtonItem.tintColor = .black
        self.navigationItem.rightBarButtonItem = doneButtonItem
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFields()
        bindView()
        viewModel.fetchUser()
    }
    
    func setTextFields() {
        userInfoTextFields.forEach { (textField) in
            textField.layer.borderColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            textField.layer.borderWidth = 1
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?){
        self.view.endEditing(true)
    }
    
    func bindView() {
        viewModel.firstName.asObservable().bind(to: self.firstNameLabel.rx.text).disposed(by: disposeBag)
        viewModel.lastName.asObservable().bind(to: self.lastNameLabel.rx.text).disposed(by: disposeBag)
        viewModel.email.asObservable().bind(to: self.emailLabel.rx.text).disposed(by: disposeBag)
        viewModel.phoneNumber.asObservable().bind(to: self.phoneNumberLabel.rx.text).disposed(by: disposeBag)
        viewModel.isSaved.asObservable()
            .subscribe(onNext: { isSaved in
                if let isSaved = isSaved {
                    if isSaved {
                        self.navigationController?.popViewController(animated: true)
                    } else {
                        self.showAlert(title: "Reminder", message: "Please check your email again!")
                    }
                }
            }).disposed(by: disposeBag)
    }
    
    func doneButtonTapped(_ sender: Any) {
        if !(firstNameLabel.text?.trimmingCharacters(in: .whitespaces).isEmpty)! &&
            !(lastNameLabel.text?.trimmingCharacters(in: .whitespaces).isEmpty)! &&
            !(emailLabel.text?.trimmingCharacters(in: .whitespaces).isEmpty)! &&
            !(phoneNumberLabel.text?.trimmingCharacters(in: .whitespaces).isEmpty)!{

            viewModel.updateUser(firstName: firstNameLabel.text!, lastName: lastNameLabel.text!, email: emailLabel.text!, mobileNumber: phoneNumberLabel.text!)
        } else {
            self.showAlert(title: "Warning", message: "You should fill out every field!")
        }
    }
}
