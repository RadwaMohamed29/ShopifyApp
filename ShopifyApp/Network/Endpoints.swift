//
//  Endpoints.swift
//  ShopifyApp
//
//  Created by Peter Samir on 25/05/2022.
//

import Foundation


enum Endpoints {
    case HomeCategoryProducts
    case MenCategoryProduct
    case WomenCategoryProduct
    case KidsCategoryProduct
    case ProductDetails(id:String)
    
    var path:String{
        switch self {
        case .HomeCategoryProducts:
            return "products.json"
        case .MenCategoryProduct:
            return "collections/268359598278/products.json"
        case .WomenCategoryProduct:
            return "collections/395728158949/products.json"
        case .KidsCategoryProduct:
            return "collections/395728191717/products.json"
        case .ProductDetails(id: let productId):
            return "products/\(productId).json"
        }
    }
}
