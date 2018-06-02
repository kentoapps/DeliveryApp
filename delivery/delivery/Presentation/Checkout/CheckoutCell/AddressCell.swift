//
//  AddressCell.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-04-14.
//  Copyright © 2018 CICCC. All rights reserved.
//

import UIKit

class AddressCell: UITableViewCell {
    
    static var Identifier: String = "AddressCell"

    @IBOutlet weak var fullNameLabel: UILabel!
    
    @IBOutlet weak var addressLabel: UILabel!
    
    @IBOutlet weak var zipCodeLabel: UILabel!
    
    
    var item: [Address]? {
        didSet {
            guard let item = item else { return }
                let test = item.filter { $0.isDefault }
                fullNameLabel.text = test.first!.receiver
                addressLabel.text = "\(test.first!.address1) \(test.first!.address2)"
                zipCodeLabel.text = "\(test.first!.postalCode)"
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
