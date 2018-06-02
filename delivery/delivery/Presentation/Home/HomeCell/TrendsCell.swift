//
//  TrendsCell.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-04-02.
//  Copyright © 2018 CICCC. All rights reserved.
//

import UIKit

class TrendsCell: UICollectionViewCell {

    static var Identifier = "TrendsCell"

    @IBOutlet weak var keywordLabel: UILabel!
    
    var item: String? {
        didSet {
            guard let item = item else { return }
            keywordLabel.text = item
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 18
        clipsToBounds = true
    }
}
