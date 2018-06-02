//
//  CategoryViewController.swift
//  delivery
//
//  Created by Jaewon Yoon on 2018-05-07.
//  Copyright © 2018 CICCC. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CategoryViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {


    private let disposeBag: DisposeBag = DisposeBag()
    private let category: [String] = ["Kitchen", "Home", "Food", "Drink", "Stationery", "Living", "Electronics"]
    
    @IBOutlet weak var categoryTableView: UITableView!
    
    public var userTappedCloseButtonClosure: (() -> Void)?
    public var userSelectedCategory: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        categoryTableView.dataSource = self
        categoryTableView.delegate = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return category.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: 300, height: 80))
        cell.textLabel?.text = category[indexPath.row]
        return cell
    }
    
    @IBAction func closeCategoryList(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
        userTappedCloseButtonClosure?()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true, completion: nil)
        userSelectedCategory?()
    }
}
