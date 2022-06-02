//
//  Customer.swift
//  ShopifyApp
//
//  Created by Radwa on 01/06/2022.
//

import Foundation


struct AllCustomers: Codable{
    let customers: [CustomerModel]
}

struct Customer: Codable{
    let customer: CustomerModel
}

struct CustomerModel: Codable {
    let firstName, lastName, email,phone: String?
    let password : String
    let verifiedEmail: Bool
    let addresses: [Address]

    enum CodingKeys: String, CodingKey {
        case firstName = "first_name"
        case lastName = "last_name"
        case email, phone
        case verifiedEmail = "verified_email"
        case addresses
        case password = "id"
    }
}

struct Address: Codable {
    let title, city: String?
    let zip, country: String?
    
    enum CodingKeys: String, CodingKey {
        case title = "address1"
        case city,zip,country
    }
}
