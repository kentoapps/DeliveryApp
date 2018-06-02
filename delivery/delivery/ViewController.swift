//
//  ViewController.swift
//  delivery
//
//  Created by Alireza Davoodi on 2018-02-20.
//  Copyright © 2018 CICCC. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UITabBarController{

    override func viewDidLoad() {
        super.viewDidLoad()

        let home = resolver.resolve(HomeViewController.self)!
        let order = resolver.resolve(OrderViewController.self)!
        let account = resolver.resolve(AccountViewController.self)!
        
        home.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "tab1"), tag: 0)
        order.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "tab2"), tag: 1)
        account.tabBarItem = UITabBarItem(title: nil, image: #imageLiteral(resourceName: "tab3"), tag: 2)
        
        self.tabBar.barTintColor = UIColor(red: 27/255, green: 35/255, blue: 62/255, alpha: 1.0)
        self.tabBar.tintColor = UIColor(red: 99/255, green: 175/255, blue: 113/255, alpha: 1.0)

        let navigationVCforHome = UINavigationController()
//        navigationVCforHome.isNavigationBarHidden = true
        navigationVCforHome.viewControllers = [home]
        
        let navigationVCforOrder = UINavigationController()
        navigationVCforOrder.viewControllers = [order]
        
        self.addChildViewController(navigationVCforHome)
        self.addChildViewController(navigationVCforOrder)
        
        let navigationVCforAccount = UINavigationController()
        
        navigationVCforAccount.isNavigationBarHidden = true
        navigationVCforAccount.viewControllers = [account]
        
        self.addChildViewController(navigationVCforAccount)

        let image = UIImage(named: "backward_arrow")?.withRenderingMode(.alwaysOriginal)
        UINavigationBar.appearance().backIndicatorImage = image
        UINavigationBar.appearance().backIndicatorTransitionMaskImage = image
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    @IBAction func goHome(_ sender: Any) {
//        let next = resolver.resolve(HomeViewController.self)!
//        present(next, animated: true, completion: nil)
//    }
//
//    @IBAction func productListButtonPressed(_ sender: Any) {
//        let next = resolver.resolve(ProductListViewController.self)!
//        present(next, animated: true, completion: nil)
//    }
//
//    @IBAction func productDetailButtonPressed(_ sender: Any) {
//        let next = resolver.resolve(ProductDetailViewController.self)!
//        next.productId = "oVhTC6TXjU1a3bG8EabF"
//        present(next, animated: true, completion: nil)
//    }
//
//    @IBAction func orderButtonPressed(_ sender: Any) {
//        let next = resolver.resolve(OrderViewController.self)!
//        present(next, animated: true, completion: nil)
//    }
//
//    @IBAction func accountButtonPressed(_ sender: Any) {
//        let next = resolver.resolve(AccountViewController.self)!
//        next.userEmail = "diegoh.vanni@gmail.com"
//        present(next, animated: true, completion: nil)
//    }
}

