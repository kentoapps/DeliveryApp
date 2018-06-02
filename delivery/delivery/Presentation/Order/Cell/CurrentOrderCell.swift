//
//  CurrentOrderCell.swift
//  delivery
//
//  Created by MATSUHISA MAI on 2018/04/12.
//  Copyright © 2018年 CICCC. All rights reserved.
//

import UIKit
import Kingfisher

class CurrentOrderCell: UITableViewCell {
    
    static var Identifier = "CurrentOrderCell"
    
    @IBOutlet weak var scheduledDeliveryDate: UILabel!
    @IBOutlet weak var statusImage: UIImageView!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var quantity: UILabel!
    @IBOutlet weak var purchasedDate: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var currentBox: UIView!
    @IBOutlet weak var layerBox: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //Shadow Effect
        applyZigZagEffect(givenView: layerBox)
//        whiteView.layer.shadowOffset = CGSize(width: 0, height: 1)
//        whiteView.layer.shadowColor = UIColor.black.cgColor
//        whiteView.layer.shadowRadius = 2.0
//        whiteView.layer.shadowOpacity = 0.40
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        productImage.image = nil
    }
    
    var order : Order?{
        didSet{
            guard order != nil else {return}
            
            //dark background color
            self.scheduledDeliveryDate.text = DateFormatter.scheduledDeliveryDateInFormat(scheduledDeliveryDate: (order?.scheduledDeliveryDate)!)
            
            self.status.text = order?.status
            
            // images
            if status.text == "Received Order" {
                self.statusImage?.image = UIImage(named: "orders_1")
            } else if status.text == "Packed for delivery" {
                self.statusImage?.image = UIImage(named: "orders_2")
            } else if status.text == "On delivery" {
                self.statusImage?.image = UIImage(named: "orders_3")
            } else if status.text == "Order arriving soon!" {
                self.statusImage?.image = UIImage(named: "orders_4")
            } else{
            }
            
            let imageUrlString = order?.orderDetail[0].productImage
            let imageUrl: URL = URL(string: imageUrlString!)!
            let resource = ImageResource(downloadURL: imageUrl, cacheKey: imageUrlString)
            self.productImage.kf.setImage(with: resource)
            
            self.productName.text = order?.orderDetail[0].productName
            self.quantity.text = String(order!.orderDetail.count)
            self.purchasedDate.text = DateFormatter.purchasedDateInFormat(purchasedDate: ((order?.deliveryInfo["purchasedDate"])!)!)
            
            self.totalPrice.text = String(format:"%.2f", (order?.totalPrice)! - (order?.couponDiscount)!)
            
        }
    }
    
    
    // productName & productImage
    var product: Product? {
        didSet {
            guard let product = product else { return }
            self.productName.text = product.name
            
            let imageUrlString = product.images[0]
            let imageUrl:URL = URL(string: imageUrlString)!
            
            let resource = ImageResource(downloadURL: imageUrl, cacheKey: product.name)
            self.productImage.kf.setImage(with: resource)
        }
    }
    
    func pathZigZagForView(givenView: UIView) ->UIBezierPath
    {
        let width = givenView.frame.size.width
        let height = givenView.frame.size.height
        
        let zigZagWidth = CGFloat(7)
        let zigZagHeight = CGFloat(5)
        let yInitial = height-zigZagHeight
        
        let zigZagPath = UIBezierPath()
        zigZagPath.move(to: CGPoint(x:0, y:0))
        zigZagPath.addLine(to: CGPoint(x:0, y:yInitial))
        
        var slope = -1
        var x = CGFloat(0)
        var i = 0
        while x < width {
            x = zigZagWidth * CGFloat(i)
            let p = zigZagHeight * CGFloat(slope) - 5
            let y = yInitial + p
            let point = CGPoint(x: x, y: y)
            zigZagPath.addLine(to: point)
            slope = slope*(-1)
            i += 1
        }
        zigZagPath.addLine(to: CGPoint(x:width,y: 0))
        zigZagPath.addLine(to: CGPoint(x:0,y: 0))
        zigZagPath.close()
        return zigZagPath
    }
    
    func createShadowLayer() -> CALayer {
        let shadowLayer = CALayer()
        shadowLayer.shadowColor = UIColor.black.cgColor
        shadowLayer.shadowOffset = CGSize(width: 0, height: 1)
        shadowLayer.shadowRadius = 2.0
        shadowLayer.shadowOpacity = 0.4
        shadowLayer.backgroundColor = UIColor.clear.cgColor
        return shadowLayer
    }
    
//    let line = CAShapeLayer()
//    let path = UIBezierPath()
//    path.move(to: CGPoint(x: 0, y: 0))
//    path.addLine(to: CGPoint(x: 50, y: 100))
//    path.addLine(to: CGPoint(x: 100, y: 50))
//    line.path = path.cgPath
//    line.strokeColor = UIColor.blue.cgColor
//    line.fillColor = UIColor.clear.cgColor
//    line.lineWidth = 2.0
//    view.layer.addSublayer(line)
//
//    let shadowSubLayer = createShadowLayer()
//    shadowSubLayer.insertSublayer(line, at: 0)
//    view.layer.addSublayer(shadowSubLayer)
    
    func applyZigZagEffect(givenView: UIView) {
        let shapeLayer = CAShapeLayer(layer: givenView.layer)
        shapeLayer.path = self.pathZigZagForView(givenView: givenView).cgPath
        shapeLayer.frame = givenView.bounds
        shapeLayer.masksToBounds = true
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.strokeColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 0.1
        givenView.layer.addSublayer(shapeLayer)
        
        let shadowSubLayer = createShadowLayer()
        shadowSubLayer.insertSublayer(shapeLayer, at: 0)
        givenView.layer.addSublayer(shadowSubLayer)
//        givenView.layer.mask = shapeLayer
        
        
    }
}

@IBDesignable
class LineView: UIView {
    
    @IBInspectable var lineWidth: CGFloat = 1.0
    @IBInspectable var lineColor: UIColor? {
        didSet {
            lineCGColor = lineColor?.cgColor
        }
    }
    var lineCGColor: CGColor?
    
    override func draw(_ rect: CGRect) {
        // Draw a line from the left to the right at the midpoint of the view's rect height.
        let midpoint = self.bounds.size.height / 2.0
        if let context = UIGraphicsGetCurrentContext() {
            context.setLineWidth(lineWidth)
            if let lineCGColor = self.lineCGColor {
                context.setStrokeColor(lineCGColor)
            }
            else {
                context.setStrokeColor(UIColor.black.cgColor)
            }
            context.move(to: CGPoint(x: 0.0, y: midpoint))
            context.addLine(to: CGPoint(x: self.bounds.size.width, y: midpoint))
            context.strokePath()
        }
    }
}
