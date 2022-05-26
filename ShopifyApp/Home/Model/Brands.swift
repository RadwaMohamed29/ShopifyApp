//
//  Brands.swift
//  ShopifyApp
//
//  Created by Menna on 26/05/2022.
//

import Foundation
struct Brands:Codable{
    let smart_collections : [Smart_collections]?
}

struct Smart_collections: Codable{
    let id : Int?
    let handle : String?
    let title : String?
    let updated_at : String?
    let body_html : String?
    let published_at : String?
    let sort_order : String?
    let template_suffix : String?
    let disjunctive : Bool?
    let rules : [Rules]?
    let published_scope : String?
    let admin_graphql_api_id : String?
    let image : ImageBrand?

}
struct Rules : Codable {
    let column : String?
    let relation : String?
    let condition : String?
}
struct ImageBrand : Codable {
    let created_at : String?
    let alt : String?
    let width : Int?
    let height : Int?
    let src : String?
}

