//
//  OrderViewController.swift
//  delivery
//
//  Created by MATSUHISA MAI on 2018/04/12.
//  Copyright © 2018年 CICCC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class OrderViewController: BaseViewController ,UITableViewDelegate {
    
    // MARK : IBOutlet
    @IBOutlet weak var tableView: UITableView!
    
    //-------------------------------------
    // MARK : Public Properties
    
    private let disposeBag : DisposeBag = DisposeBag()
    
    private var viewModel: OrderViewModel!
    public var userId: String!
    
    private var cellItems : [String] = []
    
    //-------------------------------------
    // MARK : UIViewController
    
    static func createInstance(viewModel: OrderViewModel) -> OrderViewController? {
        let instance = UIViewController.initialViewControllerFromStoryBoard(OrderViewController.self)
        instance?.viewModel = viewModel
        return instance
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //        self.navigationController?.isNavigationBarHidden = false
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        viewModel.fetchOrder(with: "Ljk5vGaGSMkYzviKx68B")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //-------------------------------------
        tableView.separatorStyle = .none //境界線消す
        self.navigationItem.title="Your Order"
        tableView.showsVerticalScrollIndicator = false
        
        self.navigationController?.navigationBar.backIndicatorImage = UIImage(named: "backward_arrow")?.withRenderingMode(.alwaysOriginal)
        self.navigationController?.navigationBar.backIndicatorTransitionMaskImage = UIImage(named: "backward_arrow")
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
        
        //-------------------------------------
        bindView()
        configureTableView() //userId
    }
    
    //    userId/Kento/No order  "RZJ5HOFsMRSbTqFbazPysEvJi7O2"
    //    userId/J1/ 1 currentorder, 1 pastorder "Ljk5vGaGSMkYzviKx68B"
    //    userId/Bruno/ test "PCcK4enUNuhZsafqncWKZMRdrUP2"

    
    
    private func registerCell(){
        tableView.register(UINib(nibName: CurrentOrderCell.Identifier, bundle: nil), forCellReuseIdentifier: CurrentOrderCell.Identifier)
        tableView.register(UINib(nibName: PastOrderCell.Identifier, bundle: nil), forCellReuseIdentifier: PastOrderCell.Identifier)
//        viewModel.fetchOrder("test")
    }
    
    private func configureTableView() {
        registerCell()
//        tableView.estimatedRowHeight = 300
        tableView.allowsSelection = true
        

    }

    //-------------------------------------
    // MARK : DataSource
    
    func emptyMessage(viewController:UITableView) {
        let rect = CGRect(origin: CGPoint(x: 0,y :0), size: CGSize(width: self.view.bounds.size.width, height: self.view.bounds.size.height))
        let messageLabel = UILabel(frame: rect)
        messageLabel.backgroundColor = #colorLiteral(red: 0.9607843137, green: 0.9568627451, blue: 0.9568627451, alpha: 1)
        messageLabel.text = "You haven't placed any orders yet."
        messageLabel.textColor = #colorLiteral(red: 0.1058823529, green: 0.137254902, blue: 0.2431372549, alpha: 1)
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = .center
        messageLabel.font = UIFont.systemFont(ofSize : 14.0)
        messageLabel.sizeToFit()
        tableView.backgroundView = messageLabel
    }

    //when you use table section, you can use "RxTableViewSectionedReloadDataSource"
    func bindView(){
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel<String,Order>>(
            configureCell: { (_, tv, indexPath, element) in
                if indexPath.section == 0 {
                    let cell = tv.dequeueReusableCell(withIdentifier: CurrentOrderCell.Identifier) as! CurrentOrderCell
                    let element = element
                    cell.order = element
                    cell.contentView.backgroundColor = #colorLiteral(red: 0.968627451, green: 0.968627451, blue: 0.968627451, alpha: 1) //Color literal - 247.247.247
                    cell.selectionStyle = UITableViewCellSelectionStyle.none //disable highlights
                    return cell
                } else {
                    let cell = tv.dequeueReusableCell(withIdentifier: PastOrderCell.Identifier) as! PastOrderCell
                    cell.order = element
                    cell.selectionStyle = UITableViewCellSelectionStyle.none //disable highlights
                    return cell
                }
            }
        )
        
        tableView.rx
            .setDelegate(self)
            .disposed(by: disposeBag)
        
        self.viewModel.arrOfOrder.asObservable()
            .bind(to:tableView.rx.items(dataSource: dataSource))
            .disposed(by:disposeBag)
        
        self.viewModel.isEmpty.asObservable().subscribe(onNext: { (isEmpty) in
            if isEmpty {
                self.emptyMessage(viewController: self.tableView)
            }
        }).disposed(by: disposeBag)
    }
    
    //-------------------------------------
    //■■■ TableView ■■■
    

    //Action : Show Detail
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let currentCell = tableView.cellForRow(at: indexPath) as! CurrentOrderCell
            let next = resolver.resolve(OrderDetailViewController.self)!
            next.orderId = currentCell.order?.orderId
            navigationController?.pushViewController(next, animated: true)
        } else {
            let pastCell = tableView.cellForRow(at: indexPath) as! PastOrderCell
            let next = resolver.resolve(OrderDetailViewController.self)!
            next.orderId = pastCell.order?.orderId
            navigationController?.pushViewController(next, animated: true)
            
        }
    }
    
    //TableView : Header section's detail
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        if(section==1) //Title of "Past Order"
        {
            let label = UILabel(frame: CGRect(x: 16, y: 0, width: 327, height: 28))
            label.textAlignment = NSTextAlignment.left
            label.text = "Past Orders"
            label.textColor = #colorLiteral(red: 0.5764705882, green: 0.5764705882, blue: 0.5764705882, alpha: 1)
            
            let myNewView=UIView(frame: CGRect(x: 0, y: 0, width: 375, height: 28))
            myNewView.backgroundColor=UIColor.white
            myNewView.addSubview(label)
            
            label.center = myNewView.center
            return myNewView
        }
        else
        {
            return nil //nothing for currentOrder
        }
        
    }
    
    //TableView : Header section's height
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if(section==1) //Title of "Past Order"
        {
            return 28
        }
        else
        {
            return 0
        }
        
    }
    
    
//    TableView : Number of Sections(CurrentOrder and PastOrder)
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    //TableView : Cell's height
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.section==0)
        {
            return 420
        }
        else
        {
            return 116
        }

    }
}
