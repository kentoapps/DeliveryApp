//
//  SignInViewController.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-05-16.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {

    // MARK: - UIViews
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    // MARK: - Closure
    var onComplete: ((Bool)->Void)?
    
    // MARK: - Instance
    
    private var viewModel: SignInViewModel!
    private let disposeBag: DisposeBag = DisposeBag()
    
    // MARK: - ViewController
    
    static func createInstance(viewModel: SignInViewModel) -> SignInViewController? {
        let instance = UIViewController.initialViewControllerFromStoryBoard(SignInViewController.self)
        instance?.viewModel = viewModel
        return instance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func forgotPassword(_ sender: Any) {
        self.showInputDialog(title: "Please type your Email",
                             subtitle: "We'll send you a link to reset the password",
                             actionTitle: "Done",
                             cancelTitle: "Cancel",
                             inputPlaceholder: "Email",
                             inputKeyboardType: .emailAddress)
        { (input:String?) in
            self.viewModel.forgotPassword(email: input!).subscribe(onCompleted: {
                self.showAlert(title: "Email Sent!", message: "Check your email box")
            }, onError: { (err) in
                self.showAlert(title: "Error", message: err.localizedDescription)
            })
        }
    }
    
    @IBAction func signIn(_ sender: Any) {
        let givenEmail = emailField.text!
        let givenPassword = passwordField.text!
        viewModel.signIn(email: givenEmail, password: givenPassword).subscribe(onCompleted: {
            self.onComplete?(true)
        }) { (err) in
            self.showAlert(title: "Error", message: "\(err)")
        }
    }
    
    @IBAction func signUp(_ sender: Any) {
        let next = resolver.resolve(SignUpViewController.self)!
        next.onComplete = self.onComplete
        self.navigationController?.pushViewController(next, animated: true)
    }
    
    @IBAction func keepGuestMode(_ sender: Any) {
        onComplete?(false)
    }
}
