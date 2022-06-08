//
//  DiscountCode.swift
//  ShopifyApp
//
//  Created by Menna on 7/06/2022.
//
import Foundation


struct DiscountCode: Codable {
    let discount_codes: [Discount_codes]?
}

struct Discount_codes: Codable {
    let id, price_rule_id: Int
    let code: String
    let usage_count: Int
    let created_at, updated_at: String
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case price_rule_id = "price_rule_id"
        case code = "code"
        case usage_count = "usage_count"
        case created_at = "created_at"
        case updated_at = "updated_at"
    }
}
//"discount_codes": [
//   {
//     "id": 15795614384386,
//     "price_rule_id": 1173393670402,
//     "code": "3SN4V909M7EQ",
//     "usage_count": 0,
//     "created_at": "2022-06-06T17:30:21+02:00",
//     "updated_at": "2022-06-06T17:30:57+02:00"
//   }
// ]
