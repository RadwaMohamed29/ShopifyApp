//
//  DraftOrders.swift
//  ShopifyApp
//
//  Created by Menna on 17/06/2022.
//

import Foundation
struct DraftOrders: Codable {
    let draftOrder: DraftOrderItem

    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}

struct DraftOrderItem: Codable {
    let lineItems: [LineItemDraft]
    let customer: CustomerId
    let useCustomerDefaultAddress: Bool

    enum CodingKeys: String, CodingKey {
        case lineItems = "line_items"
        case customer
        case useCustomerDefaultAddress = "use_customer_default_address"
    }
}

struct CustomerId: Codable {
    let id: Int
}

struct LineItemDraft: Codable {
    let quantity, variantID: Int
    let product_id:Int
    let title:String
    enum CodingKeys: String, CodingKey {
        case quantity
        case variantID = "variant_id"
        case product_id = "product_id"
        case title = "title"
    }
}

struct PutOrderRequest: Codable {
    let draftOrder: ModifyDraftOrderRequest

    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}

struct ModifyDraftOrderRequest: Codable {
    let dratOrderId: Int
    let lineItems: [LineItemDraft]
    
    enum CodingKeys: String, CodingKey {
        case lineItems = "line_items"
        case dratOrderId = "id"
    }
}
