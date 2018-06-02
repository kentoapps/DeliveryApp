//
//  ProductImageViewController.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/30.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import UIKit

class ProductImageViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var labelStr:String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = labelStr
    }
}
