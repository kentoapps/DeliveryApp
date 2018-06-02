//
//  BaseLabel.swift
//  delivery
//
//  Created by Bacelar on 2018-03-26.
//  Copyright © 2018 CICCC. All rights reserved.
//

import UIKit

class BaseLabel: UILabel {
    override var text: String? {
        didSet {
            guard let text = text else { return }
            let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
            attributeString.addAttribute(NSStrikethroughStyleAttributeName, value: 2, range: NSMakeRange(0, attributeString.length))
            
            self.attributedText = attributeString
        }
    }
}
