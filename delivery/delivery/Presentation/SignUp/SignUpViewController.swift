//
//  SignUpViewController.swift
//  delivery
//
//  Created by Kento Uchida on 2018/05/16.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class SignUpViewController: BaseViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var emailFeild: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    @IBOutlet weak var confirmField: UITextField!
    
    // MARK: - Argument
    var onComplete: ((Bool)->Void)?
    
    // MARK: - Private Properties
    private var viewModel: SignUpViewModel!
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - Static Fuctions
    static func createInstance(viewModel: SignUpViewModel) -> SignUpViewController? {
        let instance = UIViewController.initialViewControllerFromStoryBoard(SignUpViewController.self)
        instance?.viewModel = viewModel
        return instance
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
        // Make the background of NavigationController transparent
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
    }
    
    // MARK: - Private Function
    private func bind() {
        (emailFeild.rx.text <-> viewModel.email).disposed(by: disposeBag)
        (passwordField.rx.text <-> viewModel.password).disposed(by: disposeBag)
        (confirmField.rx.text <-> viewModel.confirm).disposed(by: disposeBag)
        
        viewModel.isCompleted.asObservable()
            .subscribe(
                onNext: { isCompleted in if isCompleted { self.onComplete?(true) } },
                onError: { error in print(error) }
            ).disposed(by: disposeBag)
        
        // Alert Message
        viewModel.alertMessage.asObservable()
            .subscribe(
                onNext: { alertError in self.showAlert(alertError) }
            ).disposed(by: disposeBag)
    }
    
    // MARK: - IBAction
    @IBAction func signUpButtonPressed(_ sender: Any) {
        viewModel.signUp()
    }
}
