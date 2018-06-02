//
//  BaseViewController.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/22.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import UIKit

class BaseViewController : UIViewController {
    func showAlert(_ alertError: AlertError) {
        if alertError.message.isEmpty {
            return
        }
        let alert = UIAlertController(title: alertError.title, message: alertError.message, preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
    }
}
