//
//  BaseButton.swift
//  delivery
//
//  Created by Bacelar on 2018-03-26.
//  Copyright © 2018 CICCC. All rights reserved.
//

import UIKit

@IBDesignable
class BaseButton: UIButton {
        
    override func awakeFromNib(){
        super.awakeFromNib()

        layer.cornerRadius = 0.5 * bounds.size.width
        layer.borderColor = #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        layer.borderWidth = 2.0
        clipsToBounds = true
    }
    
}
