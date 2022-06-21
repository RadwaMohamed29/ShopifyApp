//
//  Order.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 04/06/2022.
//

import Foundation
struct Orders: Codable {
    let orders: [Order]
}
struct OrderObject : Codable{
    var order : PostOrder
}
struct PostOrder : Codable{
    let id: Int?
    let lineItems: [LineItems]
    let billingAdress : Address
    let customer : CustomerOrder
    let tags : String
    enum CodingKeys: String, CodingKey {
        case id
        case lineItems = "line_items"
        case billingAdress = "billing_address"
        case customer
        case tags
        
    }
}
struct Order: Codable {
    let id: Int
    let createdAt: String
    let totalDiscounts, totalPrice, totalTax, totalPriceUsd: String
    let discountCodes: [OrderDiscountCode]?
    let email, financialStatus, name: String
    let fulfillmentStatus:String?
    let orderNumber: Int
    let orderStatusURL: String
    let lineItems: [LineItems]
    let tags : String

    
    enum CodingKeys: String, CodingKey {
        case id
        case createdAt = "created_at"
        case totalDiscounts = "total_discounts"
        case totalPrice = "total_price"
        case totalTax = "total_tax"
        case totalPriceUsd = "total_price_usd"
        case discountCodes = "discount_codes"
        case email
        case financialStatus = "financial_status"
        case fulfillmentStatus = "fulfillment_status"
        case name
        case orderNumber = "order_number"
        case orderStatusURL = "order_status_url"
        case lineItems = "line_items"
        case tags

        
    }
}

// MARK: - currencyLineItem
struct LineItems: Codable {
    let id: Int?
    let giftCard: Bool
    let name, price: String
    let productExists: Bool
    let productID:Int?
    let quantity: Int
    let title: String

    enum CodingKeys: String, CodingKey {
        case id
        case giftCard = "gift_card"
        case name, price
        case productExists = "product_exists"
        case productID = "product_id"
        case quantity
        case title
    }
}
struct CustomerOrder :Codable{
   var id : Int?
}
struct OrderDiscountCode: Codable {
    let code, amount, type: String
}
