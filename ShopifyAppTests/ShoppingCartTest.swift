//
//  ShoppingCartTest.swift
//  ShopifyAppTests
//
//  Created by Menna on 27/06/2022.
//

import XCTest
import RxSwift
@testable import ShopifyApp
class ShoppingCartTest: XCTestCase {

    var cart : ProductDetailsViewModel?
    var bag :DisposeBag!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    var product1 : Product?


    override func setUpWithError() throws {
        cart = ProductDetailsViewModel(appDelegate: appDelegate)
        bag = DisposeBag()

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        cart = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a funct/Users/menna/Desktop/FinalProject/ShopifyApp/ShopifyAppTests/ShoppingCartTest.swiftional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    func testGetFromApi(){
        let expect = expectation(description: "response")
        cart!.itemDraftOrderObservable.asObservable().subscribe { items in
            expect.fulfill()
            XCTAssertNotNil(items.element)
        }.disposed(by: bag)
        cart!.getItemsDraftOrder(idDraftOrde: 1099320918274)
        waitForExpectations(timeout: 10)
    }
    func testGetImage(){
        let expect = expectation(description: "response")
        cart?.getProductImage(id: "7706242121986")
        cart?.bindImageURLToView={
            expect.fulfill()
            let images = self.cart?.imageURL
            XCTAssertEqual(images?.count, 107)
        }
        waitForExpectations(timeout: 3, handler: nil)
    }

}
