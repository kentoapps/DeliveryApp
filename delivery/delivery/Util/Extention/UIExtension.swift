//
//  UIExtension.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/09.
//  Copyright © 2018 CICCC. All rights reserved.
//

import UIKit
import Cosmos
import RxSwift
import RxCocoa

public extension UIViewController {
    
    public class func initialViewControllerFromStoryBoard<T: UIViewController>(_ type: T.Type) -> T? {
        guard var name = NSStringFromClass(T.self).components(separatedBy: ".").last else { return nil }
        if let range = name.range(of: "ViewController") {
            name.replaceSubrange(range, with: "")
        }
        let bundle = Bundle(for: type)
        let object = UIStoryboard(name: name, bundle: bundle).instantiateInitialViewController()
        guard let ret = object as? T else { return nil }
        return ret
    }
}

public extension CosmosView {
    public var rx_rating: AnyObserver<Double> {
        return Binder(self) { view, rating in
            view.rating = rating
            }.asObserver()
    }
}

public extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

extension UITabBar {
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var sizeThatFits = super.sizeThatFits(size)
        sizeThatFits.height = 56 // adjust your size here
        return sizeThatFits
    }
}

extension UIViewController {
    func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .destructive, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showAlert(title: String? = nil, message: String){
        if message.isEmpty { return }
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func showPasswordInput(cancelHandler: ((UIAlertAction) -> Void)? = nil,
                           actionHandler: ((_ currentPW: String?, _ confirmedPW: String?, _ newPW: String?) -> Void)? = nil) {
        
        let alert = UIAlertController(title: "Change Password", message: nil, preferredStyle: .alert)
        
        alert.addTextField { (textField) in
            textField.placeholder = "Enter current password"
            textField.isSecureTextEntry = true
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Confirm your password"
            textField.isSecureTextEntry = true
        }
        alert.addTextField { (textField) in
            textField.placeholder = "Enter the new password"
            textField.isSecureTextEntry = true
        }
        
        alert.addAction(UIAlertAction(title: "Done", style: .destructive, handler: { (action:UIAlertAction) in
            guard let textFields =  alert.textFields else {
                actionHandler?(nil, nil, nil)
                return
            }
            actionHandler?(textFields[0].text, textFields[1].text, textFields[2].text)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: cancelHandler))
        
        self.present(alert, animated: true, completion: nil)
    }
}

extension UINavigationItem {
    func addShoppingCart(num: Int = 0) -> UIButton {
        let label = UILabel(frame: CGRect(x: 10, y: -10, width: 16, height: 16))
        label.layer.borderColor = UIColor.clear.cgColor
        label.layer.borderWidth = 2
        label.layer.cornerRadius = label.bounds.size.height / 2
        label.textAlignment = .center
        label.layer.masksToBounds = true
        label.font = label.font.withSize(10)
        label.textColor = .white
        label.backgroundColor = UIColor(displayP3Red: 99/255, green: 175/255, blue: 113/255, alpha: 1)
        label.tag = 1001
        
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 18, height: 16))
        button.setBackgroundImage(#imageLiteral(resourceName: "cart"), for: .normal)
        button.addSubview(label)
        
        let shoppingCart = UIBarButtonItem(customView: button)
        
        self.rightBarButtonItem = shoppingCart
        
        updateShoppingCart(num: num)
        return button
    }
    
    func updateShoppingCart(num: Int) {
        let shoppingCart = self.rightBarButtonItem
        let button = shoppingCart?.customView as? UIButton
        let label = button?.viewWithTag(1001) as? UILabel
        if num > 0 {
            label?.isHidden = false
            label?.text = String(num)
        } else {
            label?.isHidden = true
        }
    }
}
