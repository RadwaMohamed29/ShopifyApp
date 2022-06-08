//
//  Customer.swift
//  ShopifyApp
//
//  Created by Radwa on 01/06/2022.
//

import Foundation


struct AllCustomers: Codable{
    let customers: [CustomerModel]?
}

struct Customer: Codable{
    let customer: CustomerModel
}

struct CustomerModel: Codable {
    let first_name, last_name, email, phone, tags: String?
    let id: Int?
    let verified_email: Bool?
    let addresses: [Address]?
}

struct Address: Codable {
    var address1, address2, city: String?
    var country: String?
//    var id: Int!
//    var country_name, country_code, name, province_code, address2, customer_id, company:String?
}

struct NewAddress:Codable{
    let address:Address
}

extension Encodable {
  func asDictionary() throws -> [String: Any] {
    let data = try JSONEncoder().encode(self)
    guard let dictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any] else {
      throw NSError()
    }
    return dictionary
  }
    
}
struct CustomerAddress: Codable {
    var addresses: [Address]?
}
