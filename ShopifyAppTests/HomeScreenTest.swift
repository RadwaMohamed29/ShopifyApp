//
//  HomeScreenTest.swift
//  ShopifyAppTests
//
//  Created by Menna on 26/06/2022.
//

import XCTest
import RxSwift
@testable import ShopifyApp
class HomeScreenTest: XCTestCase {
    var homeViewModel : HomeViewModel?
    var bag :DisposeBag!
    override func setUpWithError() throws {
        homeViewModel = HomeViewModel()
        bag = DisposeBag()

        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        homeViewModel = nil

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
        homeViewModel!.allBrandObservable.asObservable().subscribe { smartCollection in
            expect.fulfill()
            XCTAssertNotNil(smartCollection.element)
        }.disposed(by: bag)
        homeViewModel!.getAllBrands()
        waitForExpectations(timeout: 5)
        
    }
    func testAds(){
        let expect = expectation(description: "load response")
        homeViewModel!.allDiscountObservable.asObservable().subscribe { discound in
            expect.fulfill()
            XCTAssertNotNil(discound.element)
        }.disposed(by: bag)
        homeViewModel!.getDiscountCode(priceRule: "1173393670402")
        waitForExpectations(timeout: 5)
    }
    

}
