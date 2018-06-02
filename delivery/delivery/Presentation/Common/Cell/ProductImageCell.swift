//
//  ProductImageCell.swift
//  delivery
//
//  Created by Kento Uchida on 2018/03/30.
//  Copyright © 2018 CICCC. All rights reserved.
//

import UIKit
import Kingfisher

class ProductImageCell: UICollectionViewCell {
    static var Identifier = "ProductImageCell"

    @IBOutlet weak var imageView: UIImageView!
    
    var imageUrl: String? {
        didSet {
            guard let imageUrl = imageUrl else { return }
            let url: URL = URL(string: imageUrl)!
            let resource = ImageResource(downloadURL: url, cacheKey: imageUrl)
            self.imageView.kf.setImage(with: resource)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
