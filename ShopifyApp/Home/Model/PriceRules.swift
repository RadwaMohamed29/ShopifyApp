//
//  PriceRules.swift
///  ShopifyApp
//
//  Created by Menna on 7/06/2022.
//

import Foundation
struct PriceRules: Codable {
    let priceRules: [PriceRule]
}

struct PriceRule: Codable {
    let id: Int
    let valueType: String
    let value: String
    let customerSelection: String
    let targetType: String
    let targetSelection: String

}
