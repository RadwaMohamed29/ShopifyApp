//
//  Product.swift
//  ShopifyApp
//
//  Created by Radwa on 25/05/2022.
//

import Foundation
import SwiftUI
struct AllProducts :Codable{
    let products : [Product]?
}

struct Products: Codable{
    let product: Product?
    
}

struct Product: Codable{
    let id: Int
    var title, bodyHTML, vendor, productType: String
    let createdAt: String
    let handle: String
    let updatedAt, publishedAt: String
    let publishedScope, tags, adminGraphqlAPIID: String
    let options: [Options]
    let images: [Images]
    let variant: [Variant]
    let image: Image
    
    enum CodingKeys: String, CodingKey {
        case id, title
        case bodyHTML = "body_html"
        case vendor
        case productType = "product_type"
        case createdAt = "created_at"
        case handle
        case updatedAt = "updated_at"
        case publishedAt = "published_at"
        case publishedScope = "published_scope"
        case tags
        case adminGraphqlAPIID = "admin_graphql_api_id"
        case options, images, image
        case variant = "variants"
    }
}

struct Variant: Codable{
    let id, productID: Int
    let title, price, sku: String?
    let position: Int
    let inventoryPolicy: String
    let fulfillmentService: String
    let inventoryManagement: String
    let option1: String
    let option2: String
    let createdAt, updatedAt: String
    let taxable: Bool
    let grams: Int
    let weight: Int
    let weightUnit: String
    let inventoryItemID, inventoryQuantity, oldInventoryQuantity: Int
    let requiresShipping: Bool
    let adminGraphqlAPIID: String

    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case title, price, sku, position
        case inventoryPolicy = "inventory_policy"
        case fulfillmentService = "fulfillment_service"
        case inventoryManagement = "inventory_management"
        case option1, option2
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case taxable, grams
        case weight
        case weightUnit = "weight_unit"
        case inventoryItemID = "inventory_item_id"
        case inventoryQuantity = "inventory_quantity"
        case oldInventoryQuantity = "old_inventory_quantity"
        case requiresShipping = "requires_shipping"
        case adminGraphqlAPIID = "admin_graphql_api_id"
    }
    

}



struct Images: Codable{
    let id, productID, position: Int
    let createdAt, updatedAt: String
    let alt: String?
    let width, height: Double
    let src: String
    let adminGraphqlAPIID: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case position
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case alt, width, height, src
        case adminGraphqlAPIID = "admin_graphql_api_id"
    }
    
}

struct Options: Codable{
    let id, productID: Int
    let name: String
    let position: Int
    let values: [String]
    
    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case name, position, values
    }
    
}
struct Image: Codable{
    let id, productID, position: Int
    let createdAt, updatedAt: String
    let alt: String?
    let width, height: Double
    let src: String
    let adminGraphqlAPIID: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case productID = "product_id"
        case position
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case alt, width, height, src
        case adminGraphqlAPIID = "admin_graphql_api_id"
    }
    
}

struct FavoriteProducts:Codable{
    let id : String
    let body_html :String
    let price :String
    let scr:String
    let title:String
    var isSelected:Bool
}
