//
//  RegistetUnitTest.swift
//  ShopifyAppTests
//
//  Created by Radwa on 26/06/2022.
//

import XCTest
@testable import ShopifyApp

class RegistetUnitTest: XCTestCase {
    var registerViewModel: RegisterViewModelType!
    var loginViewModel: LoginViewModelType!


    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        registerViewModel = RegisterViewModel()
        loginViewModel = LoginViewModel()
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
    
    
    func testRegister(){
        let result = expectation(description: "r")
        registerViewModel.registerCustomer(firstName: "radwa", lastName: "mohamed", email: "radwaa@gmail.com", password: "123123", completion: { result in
            switch result{
            case true:
                XCTAssertTrue(true)
            case false:
                XCTAssertFalse(false)
            }
          

        })
        registerViewModel.bindNavigate = {
            let navigate = self.registerViewModel.navigate
            result.fulfill()
            XCTAssertEqual(navigate, true)
        }
        waitForExpectations(timeout: 25, handler: nil)
    }

    func testLogin(){
        let result = expectation(description: "r")
        loginViewModel.loginCustomer(email: "hussien@gmail.com", password: "123123")
        loginViewModel.bindNavigate = {
            let navigate = self.loginViewModel.navigate
            result.fulfill()
            XCTAssertTrue(navigate == true)
        }
        
        waitForExpectations(timeout: 10, handler: nil)
        
    }
    


}
