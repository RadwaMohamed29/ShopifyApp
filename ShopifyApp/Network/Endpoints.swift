//
//  Endpoints.swift
//  ShopifyApp
//
//  Created by Peter Samir on 25/05/2022.
//

import Foundation


enum Endpoints {
    
    case MenCategoryProduct
    case WomenCategoryProduct
    case KidsCategoryProduct
    case ProductDetails(id:String)
    
    var path:String{
        switch self {
        
        case .MenCategoryProduct:
            return "collections/268359598278/products.json"
        case .WomenCategoryProduct:
            return "collections/268359631046/products.json"
        case .KidsCategoryProduct:
            return "collections/268359663814/products.json"
        case .ProductDetails(id: let productId):
            return "products/\(productId).json"
        }
    }
}
