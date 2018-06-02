//
//  OrderDetailVC.swift
//  delivery
//
//  Created by MATSUHISA MAI on 2018/03/26.
//  Copyright © 2018年 CICCC. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class OrderDetailViewController: BaseViewController {
    
    // MARK : IBOutlet
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var scrollView: UIScrollView!
    
    @IBOutlet weak var layerView: UIView!
    @IBOutlet weak var scheduledDeliveryDate: UILabel!
    
    @IBOutlet weak var address1: UILabel!
    @IBOutlet weak var address2: UILabel!
    @IBOutlet weak var city: UILabel!
    @IBOutlet weak var province: UILabel!
    @IBOutlet weak var postalCode: UILabel!
    @IBOutlet weak var phoneNumber: UILabel!
    
    @IBOutlet weak var coupon: UILabel!
    @IBOutlet weak var totalBeforeShippingFee: UILabel!
    @IBOutlet weak var deliveryFee: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    
    //-------------------------------------
    // MARK : Public Properties
    
    private let disposeBag : DisposeBag = DisposeBag()
    
    private var viewModel: OrderDetailViewModel!
    public var orderId: String!
    
    //-------------------------------------
    // MARK : UIViewController
    
    static func createInstance(viewModel: OrderDetailViewModel) -> OrderDetailViewController? {
        let instance = UIViewController.initialViewControllerFromStoryBoard(OrderDetailViewController.self)
        instance?.viewModel = viewModel
        return instance
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title="Your Order Detail"
        
        configureTableView()
        tableView.separatorStyle = .none
        tableView.backgroundColor = .none
        bindView()
        viewModel.fetchOrderDetail(with: orderId)
        scrollView.showsVerticalScrollIndicator = false
        //zigzag and Shadow Effect
        applyZigZagEffect(givenView: layerView)
        self.view.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1)
    }
    
    private func registerCell(){
        tableView.register(UINib(nibName: OrderDetailCell.Identifier, bundle: nil), forCellReuseIdentifier: OrderDetailCell.Identifier)
    }
    
    private func configureTableView() {
        registerCell()
        //        tableView.estimatedRowHeight = 300
        tableView.allowsSelection = true

            }

    
    //-------------------------------------
    // MARK : DataSource
    func bindView(){
        viewModel.scheduledDeliveryDate.asObservable()
            .bind(to: scheduledDeliveryDate.rx.text)
            .disposed(by: disposeBag)
        viewModel.address1.asObservable()
            .bind(to: address1.rx.text)
            .disposed(by: disposeBag)
        viewModel.address2.asObservable()
            .bind(to: address2.rx.text)
            .disposed(by: disposeBag)
        viewModel.city.asObservable()
            .bind(to: city.rx.text)
            .disposed(by: disposeBag)
        viewModel.province.asObservable()
            .bind(to: province.rx.text)
            .disposed(by: disposeBag)
        viewModel.postalCode.asObservable()
            .bind(to: postalCode.rx.text)
            .disposed(by: disposeBag)
        viewModel.phoneNumber.asObservable()
            .bind(to: phoneNumber.rx.text)
            .disposed(by: disposeBag)
        viewModel.couponDiscount.asObservable()
            .bind(to: coupon.rx.text)
            .disposed(by: disposeBag)
        viewModel.totalBeforeShippingFee.asObservable()
            .bind(to: totalBeforeShippingFee.rx.text)
            .disposed(by:disposeBag)
        viewModel.deliveryFee.asObservable()
            .bind(to: deliveryFee.rx.text)
            .disposed(by:disposeBag)
        viewModel.totalPrice.asObservable()
            .bind(to: totalPrice.rx.text)
            .disposed(by:disposeBag)
        viewModel.arrOfOrderDetail.asObservable()
            .bind(to: tableView.rx.items(cellIdentifier: OrderDetailCell.Identifier, cellType: OrderDetailCell.self)) {
                row, item, cell in
                cell.orderDetail = item
        }.disposed(by: disposeBag)
    }
    
    
    func pathZigZagForView(givenView: UIView) -> UIBezierPath {
        
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
    }

}
