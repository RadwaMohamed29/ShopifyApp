//
//  DraftOrder.swift
//  ShopifyApp
//
//  Created by Menna on 20/06/2022.
//

import Foundation
struct DraftOrderResponseTest: Codable {
    let draftOrder: DraftOrderTest?

    enum CodingKeys: String, CodingKey {
        case draftOrder = "draft_order"
    }
}

// MARK: - DraftOrder
struct DraftOrderTest: Codable {
    let id: Int
    let note: String?
    let email: String
    let taxesIncluded: Bool
    let currency: String
    let createdAt, updatedAt: Date
    let taxExempt: Bool
    let name, status: String
    let lineItems: [LineItem]
    let invoiceURL: String
    let taxLines: [TaxLine]
    let tags: String
    let totalPrice, subtotalPrice, totalTax: String
    let adminGraphqlAPIID: String
    let customer: CustomerDraftTest

    enum CodingKeys: String, CodingKey {
        case id, note, email
        case taxesIncluded = "taxes_included"
        case currency
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxExempt = "tax_exempt"
        case name, status
        case lineItems = "line_items"
        case invoiceURL = "invoice_url"
        case taxLines = "tax_lines"
        case tags
        case totalPrice = "total_price"
        case subtotalPrice = "subtotal_price"
        case totalTax = "total_tax"
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case customer
    }
}


// MARK: - Customer
struct CustomerDraftTest: Codable {
    let id: Int
    let email: String
    let acceptsMarketing: Bool
    let createdAt, updatedAt: Date
    let firstName, lastName: String
    let ordersCount: Int
    let state, totalSpent: String
    let lastOrderID: Int?
    let note: String
    let verifiedEmail: Bool
    let multipassIdentifier: String
    let taxExempt: Bool
    let phone: String?
    let tags: String
    let lastOrderName: String?
    let currency: String
    let acceptsMarketingUpdatedAt: Date
    let emailMarketingConsent: EmailMarketingConsent
    let adminGraphqlAPIID: String

    enum CodingKeys: String, CodingKey {
        case id, email
        case acceptsMarketing = "accepts_marketing"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case ordersCount = "orders_count"
        case state
        case totalSpent = "total_spent"
        case lastOrderID = "last_order_id"
        case note
        case verifiedEmail = "verified_email"
        case multipassIdentifier = "multipass_identifier"
        case taxExempt = "tax_exempt"
        case phone, tags
        case lastOrderName = "last_order_name"
        case currency
        case acceptsMarketingUpdatedAt = "accepts_marketing_updated_at"
        case emailMarketingConsent = "email_marketing_consent"
        case adminGraphqlAPIID = "admin_graphql_api_id"
    }
}


// MARK: - EmailMarketingConsent
struct EmailMarketingConsent: Codable {
    let state, optInLevel: String
    //let consentUpdatedAt: JSONNull?

    enum CodingKeys: String, CodingKey {
        case state
        case optInLevel = "opt_in_level"
    }
}


// MARK: - LineItem
struct LineItem: Codable {
    let id, variantID, productID: Int
    let title, variantTitle, sku, vendor: String
    let quantity: Int
    let requiresShipping, taxable, giftCard: Bool
    let fulfillmentService: String
    let grams: Int
    let taxLines: [TaxLine]
    //let appliedDiscount: JSONNull?
    let name: String
    //let properties: [JSONAny]
    let custom: Bool
    let price, adminGraphqlAPIID: String

    enum CodingKeys: String, CodingKey {
        case id
        case variantID = "variant_id"
        case productID = "product_id"
        case title
        case variantTitle = "variant_title"
        case sku, vendor, quantity
        case requiresShipping = "requires_shipping"
        case taxable
        case giftCard = "gift_card"
        case fulfillmentService = "fulfillment_service"
        case grams
        case taxLines = "tax_lines"
        case name, custom, price
        case adminGraphqlAPIID = "admin_graphql_api_id"
    }
}


// MARK: - TaxLine
struct TaxLine: Codable {
    let rate: Double
    let title, price: String
}

struct EmptyObject: Codable {
    
}
