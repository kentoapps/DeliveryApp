//
//  PaymentCell.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-04-17.
//  Copyright © 2018 CICCC. All rights reserved.
//

import UIKit

class PaymentCell: UITableViewCell {
    
    static var Identifier: String = "PaymentCell"

    @IBOutlet weak var cardHolder: UILabel!
    @IBOutlet weak var cardNumber: UILabel!
    @IBOutlet weak var expiryDate: UILabel!


    var item: [Payment]? {
        didSet {
            guard (item?.count) != nil && item?.count != 0 else { return }
            let test = item?.filter { $0.isDefault}
            cardHolder.text = test?.first?.holderName
            cardNumber.text = test?.first?.cardNumber
            expiryDate.text = DateFormatter.expiryDateInFormat(expiryDate: (test?.first?.expiryDate)!)
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
