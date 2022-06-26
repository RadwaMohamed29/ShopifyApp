//
//  CheckoutViewControllerTest.swift
//  ShopifyAppTests
//
//  Created by AbdElrahman sayed on 26/06/2022.
//

import XCTest
@testable import ShopifyApp
class CheckoutViewControllerTest: XCTestCase {
    var checkoutVC : CheckoutViewController?
    override func setUpWithError() throws {
        checkoutVC = CheckoutViewController(nibName: "CheckoutViewController", bundle: nil)
    }

    override func tearDownWithError() throws {
      checkoutVC = nil
    }

    func testChangeOnCouponStatuesAfterUseingIt() {
        let discount :Double =  5
        checkoutVC?.approvePayment(discoun: discount)
        let test = Utilities.utilities.isCodeUsed(code: Utilities.utilities.getCode())
        XCTAssertEqual(test, true)
    }
    
    func testNoChangeOnCouponStatuesAfterUseingIt() {
        Utilities.utilities.setCodeUsed(code: Utilities.utilities.getCode(),isUsed: false)
        let discount :Double =  0
        checkoutVC?.approvePayment(discoun: discount)
        let test = Utilities.utilities.isCodeUsed(code: Utilities.utilities.getCode())
        XCTAssertEqual(test, false)
    }
}
