//
//  CategoryViewModelTest.swift
//  ShopifyAppTests
//
//  Created by Peter Samir on 29/06/2022.
//

import XCTest
@testable import ShopifyApp

class CategoryViewModelTest: XCTestCase {

    var categoryVM:CategoryViewModel!
    
    let productArray = ["Adidas", "puma", "Nike", "Mercural", "puma", "Gucci", "Tommy"]
    override func setUpWithError() throws {
        categoryVM = CategoryViewModel(network: APIClient())
    }

    override func tearDownWithError() throws {
        categoryVM = nil
    }

    func testSearchWithWord() {
        // test trimming spaces, and lowercased chars
        let word = "puma  "
        if word.isEmpty{
            return
        }
        let filteredProducts = productArray.filter { prod in
            return prod.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
        }
        XCTAssertTrue(filteredProducts.count == 2)
    }

}
