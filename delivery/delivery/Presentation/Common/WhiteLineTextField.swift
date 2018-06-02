//
//  WhiteLineTextField.swift
//  delivery
//
//  Created by Kento Uchida on 2018/05/18.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import UIKit

class WhiteLineTextField: UITextField {
    override func awakeFromNib() {
        let border = CALayer()
        let width = CGFloat(1.0)
        border.borderColor = UIColor.white.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width,
                              width: self.frame.size.width + 100, height: self.frame.size.height)
        
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true
        let placeholder = self.attributedPlaceholder?.string ?? ""
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSForegroundColorAttributeName: UIColor.white])
    }
}
