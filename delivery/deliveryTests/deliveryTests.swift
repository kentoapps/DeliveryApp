//
//  deliveryTests.swift
//  deliveryTests
//
//  Created by Alireza Davoodi on 2018-02-20.
//  Copyright © 2018 CICCC. All rights reserved.
//

import XCTest
@testable import delivery
import Firebase

class deliveryTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
     
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testFirebaseAddProduct() {
        
        FirebaseApp.configure()
        
//        var product: ProductEntity! = ProductEntity()
//        product.name = "diet Pepsi 100ml"
//        product.description = "Pepsi description"
//        product.brand = "Pepsi"
//        product.discountPercent = 0
//        product.price = 4.00
//        
//        
//        let data = ProductListFirebaseDataStore.init()
//        data.addNewProduct(product: product)
        
    }
    
}
