//
//  QuantityPopUpController.swift
//  delivery
//
//  Created by Bacelar on 2018-04-25.
//  Copyright © 2018 CICCC. All rights reserved.
//

import UIKit

class QuantityPopUpController: UIViewController {

    @IBOutlet weak var quantityView: UIView!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    @IBOutlet weak var textQuantity: UILabel!
    
    @IBOutlet weak var quantity: UITextField!
    var delegate: PopupDelegate?
    
    var productQuantity: Int = 0
    var buttonTag: Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    func setup(){
        quantityView.backgroundColor = UIColor.white
        quantityView.layer.shadowColor = UIColor.lightGray.cgColor
        quantityView.layer.shadowOpacity = 1
        quantityView.layer.shadowOffset = CGSize(width: 7.0, height: 7.0)
        quantityView.layer.shadowRadius = 7
    }
    
    
    @IBAction func minusButtonDidTap(_ sender: Any) {
        if productQuantity>0 {
            productQuantity -= 1
        } else {
            productQuantity = 0
        }
        
        self.textQuantity.text = String(self.productQuantity)
    }
    
    @IBAction func plusButtonDidTap(_ sender: Any) {
        productQuantity += 1
        self.textQuantity.text = String(self.productQuantity)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        
        let touch: UITouch? = touches.first
        if touch?.view != quantityView {
            delegate?.passValue(value: textQuantity.text!, tag: buttonTag)            
            dismiss(animated: true, completion: nil)
        }
    }
    
    func setQuantity(sender: UIButton) {
        productQuantity = Int(sender.titleLabel!.text!)!
        textQuantity.text = sender.titleLabel!.text
        buttonTag = sender.tag
    }
}
