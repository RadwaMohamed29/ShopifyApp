//
//  ProductTest.swift
//  ShopifyAppTests
//
//  Created by Radwa on 27/06/2022.
//

import XCTest
import RxSwift
@testable import ShopifyApp
class ProductTest: XCTestCase {
    var productViewModel: ProductDetailsViewModelType!
    var disposeBag: DisposeBag!
    var appDelegate = UIApplication.shared.delegate as! AppDelegate
    override func setUpWithError() throws {
        productViewModel = ProductDetailsViewModel(appDelegate: appDelegate)
       disposeBag = DisposeBag()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
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
    
    func testCollection(){
            let expect = expectation(description: "load response")
        productViewModel!.productObservable.asObservable().subscribe { product in
                expect.fulfill()
                XCTAssertNotNil(product.element)
            }.disposed(by: disposeBag)
        productViewModel.getProduct(id: "7706242121986")
            waitForExpectations(timeout: 10)

        }

}
