//
//  ReviewCell.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/23.
//  Copyright © 2018 CICCC. All rights reserved.
//

import UIKit

class ReviewCell: UITableViewCell {
    static var Identifier = "ReviewCell"
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    var review: Review? {
        didSet {
            guard let review = review else { return }
            titleLabel.text = review.title
            userNameLabel.text = review.userName
            commentLabel.text = review.comment
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
