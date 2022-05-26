//
//  Product.swift
//  ShopifyApp
//
//  Created by Radwa on 25/05/2022.
//

import Foundation
import SwiftUI

struct Products: Codable{
    let product: [Product]?
    
}

struct Product: Codable{
    let id: Int?
    let title: String?
    let body_html: String?
    let variants: [Variants]?
    let images: [Images]?
    let options: [Options]?
    let image: Image?
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case title = "product_title"
        case body_html = "body_html"
        case variants = "variants"
        case images = "images"
        case options = "options"
        case image = "image"
        
    }
}

struct Variants: Codable{
    let product_id: Int?
    let price:Int?
    let title:String?
    
    enum CodingKeys: String, CodingKey{
        case product_id = "product_id"
        case price = "price"
        case title = "title"
    }
}

struct Images: Codable{
    let product_id: Int?
    let str:String?
    
    enum CodingKeys: String, CodingKey{
        case product_id = "product_id"
        case str = "product_images"
    }
    
}

struct Options: Codable{
    let product_id: Int?
    let name: String?
    let values: [String]?
    
    enum CodingKeys: String, CodingKey{
        case product_id = "product_id"
        case name = "name"
        case values = "values"
    }
    
}
struct Image: Codable{
    let product_id: Int?
    let str: String?
    enum CodingKeys: String, CodingKey{
        case product_id = "product_id"
        case str = "product_str"
    }
}
