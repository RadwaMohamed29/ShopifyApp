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
    let title, bodyHTML, vendor, productType: String
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

//struct Variants: Codable {
//    let id, product_id: Int
//    let title, price, sku: String
//    let position: Int
//    let inventory_policy: String
//    let fulfillment_service: String
//    let inventory_management: String
//    let option1: String
//    let option2: String
//    let created_at, updated_at: String
//    let taxable: Bool
//    let grams: Int
//    let weight: Int
//    let weight_unit: String
//    let inventory_item_id, inventory_quantity, old_inventory_quantity: Int
//    let requires_shipping: Bool
//    let admin_graphql_api_id: String
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case productID = "product_id"
//        case title, price, sku, position
//        case inventoryPolicy = "inventory_policy"
//        case fulfillmentService = "fulfillment_service"
//        case inventoryManagement = "inventory_management"
//        case option1, option2
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case taxable, grams
//        case weight
//        case weightUnit = "weight_unit"
//        case inventoryItemID = "inventory_item_id"
//        case inventoryQuantity = "inventory_quantity"
//        case oldInventoryQuantity = "old_inventory_quantity"
//        case requiresShipping = "requires_shipping"
//        case adminGraphqlAPIID = "admin_graphql_api_id"
//    }
//}
//
//struct Option: Codable {
//    let productID, id: Int
//    let name: Name
//    let position: Int
//    let values: [String]
//
//    enum CodingKeys: String, CodingKey {
//        case productID = "product_id"
//        case id, name, position, values
//    }
//}
//
//
//enum Name: String, Codable {
//    case color = "Color"
//    case size = "Size"
//}
//
//enum ProductType: String, Codable {
//    case accessories = "ACCESSORIES"
//    case shoes = "SHOES"
//    case tShirts = "T-SHIRTS"
//}
//enum PublishedScope: String, Codable {
//    case web = "web"
//}
//
//enum Status: String, Codable {
//    case active = "active"
//}
//
//enum FulfillmentService: String, Codable {
//    case manual = "manual"
//}
//
//enum InventoryManagement: String, Codable {
//    case shopify = "shopify"
//}
//
//enum InventoryPolicy: String, Codable {
//    case deny = "deny"
//}
//
//// MARK: - Variant
//struct Variants: Codable {
//    let productID, id: Int
//    let title, price, sku: String
//    let position: Int
//    let inventoryPolicy: InventoryPolicy
//    let compareAtPrice: String?
//    let fulfillmentService: FulfillmentService
//    let inventoryManagement: InventoryManagement
//    let option1: String
//    let option2: Option2?
//    let createdAt, updatedAt: String
//    let taxable: Bool
//    let barcode: String?
//    let grams: Int
//    let weight: Int
//    let weightUnit: WeightUnit
//    let inventoryItemID, inventoryQuantity, oldInventoryQuantity: Int
//    let requiresShipping: Bool
//    let adminGraphqlAPIID: String
//
//    enum CodingKeys: String, CodingKey {
//        case productID = "product_id"
//        case id, title, price, sku, position
//        case inventoryPolicy = "inventory_policy"
//        case compareAtPrice = "compare_at_price"
//        case fulfillmentService = "fulfillment_service"
//        case inventoryManagement = "inventory_management"
//        case option1, option2
//        case createdAt = "created_at"
//        case updatedAt = "updated_at"
//        case taxable, barcode, grams
//        case weight
//        case weightUnit = "weight_unit"
//        case inventoryItemID = "inventory_item_id"
//        case inventoryQuantity = "inventory_quantity"
//        case oldInventoryQuantity = "old_inventory_quantity"
//        case requiresShipping = "requires_shipping"
//        case adminGraphqlAPIID = "admin_graphql_api_id"
//    }
//}
//
//
//enum Option2: String, Codable {
//    case beige = "beige"
//    case black = "black"
//    case blue = "blue"
//    case burgandy = "burgandy"
//    case gray = "gray"
//    case lightBrown = "light_brown"
//    case red = "red"
//    case white = "white"
//    case yellow = "yellow"
//}
//
//enum WeightUnit: String, Codable {
//    case kg = "kg"
//}

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
