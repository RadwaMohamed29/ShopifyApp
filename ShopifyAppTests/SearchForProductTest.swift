//
//  SearchForProductTest.swift
//  ShopifyAppTests
//
//  Created by Peter Samir on 28/06/2022.
//

import XCTest
@testable import ShopifyApp

class SearchForProductTest: XCTestCase {

    var productViewModel: ProductDetailsViewModelType!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var listOfProduct = ["20.0", "70.0", "250.0", "1200.0", "510.0", "1250.0", "25.0", "50.5"]
    
    override func setUpWithError() throws {
        productViewModel = ProductDetailsViewModel(appDelegate: appDelegate)
    }

    override func tearDownWithError() throws {
        productViewModel = nil
    }

    func testExample() throws {
    
    }

    func testFilterFromHigh() {
        let arrangeOrder = "high"
        
        if arrangeOrder == "high" {
            listOfProduct.sort(by: {Double($0)! > Double($1)!})
            let newArray = ["1250.0", "1200.0", "510.0", "250.0", "70.0", "50.5", "25.0", "20.0"]
            XCTAssertEqual(listOfProduct, newArray)
        }
    }
    
    
    func testFilterFromLow() {
        let arrangeOrder = "low"
        if arrangeOrder == "low" {
            listOfProduct.sort(by: {Double($0)! < Double($1)!})
            let newArray = ["20.0", "25.0", "50.5", "70.0", "250.0", "510.0", "1200.0", "1250.0"]
            XCTAssertEqual(listOfProduct, newArray)
        }
    }
    
    func testS(){
        
    }

}
