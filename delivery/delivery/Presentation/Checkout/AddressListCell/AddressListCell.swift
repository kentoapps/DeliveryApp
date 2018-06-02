//
//  AddressListCell.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-04-20.
//  Copyright © 2018 CICCC. All rights reserved.
//

import UIKit

class AddressListCell: UITableViewCell {

    @IBOutlet weak var radioButton: UIButton!

    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBOutlet weak var receiverLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var zipCodeLabel: UILabel!
    
    
    static var Identifier: String = "AddressListCell"

    
    var item: Address? {
        didSet {
            guard let item = item else { return }
            receiverLabel.text = item.receiver
            addressLabel.text = "\(item.address1) \(item.address2)"
            zipCodeLabel.text = item.postalCode
            
            if item.isDefault {
                radioButton.setImage(#imageLiteral(resourceName: "radio_on"), for: .normal)
            } else {
                radioButton.setImage(#imageLiteral(resourceName: "radio_off"), for: .normal)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
