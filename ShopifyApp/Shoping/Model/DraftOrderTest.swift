//
//  DraftOrderTest.swift
//  ShopifyApp
//
//  Created by Menna on 18/06/2022.
//

import Foundation
struct DraftOrdersRequest: Codable {
    let draftOrder: DraftOrderItemTest?

    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}

// MARK: - DraftOrder
struct DraftOrderItemTest: Codable {
    var lineItems: [LineItemDraftTest]
    let customer: CustomerIdTest
    let useCustomerDefaultAddress: Bool

    enum CodingKeys: String, CodingKey {
        case lineItems = "line_items"
        case customer
        case useCustomerDefaultAddress = "use_customer_default_address"
    }
}

// MARK: - Customer
struct CustomerIdTest: Codable {
    let id: Int
}

// MARK: - LineItem
struct LineItemDraftTest: Codable {
    let quantity, variantID,productID: Int
    let title:String
    let vendor:String
    let price:String
    
    

    enum CodingKeys: String, CodingKey {
        case quantity
        case variantID = "variant_id"
        case productID = "product_id"
        case title
        case vendor
        case price
        
    }
}



//MARK: - PutOrderRequest
