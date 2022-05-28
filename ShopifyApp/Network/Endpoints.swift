//
//  Endpoints.swift
//  ShopifyApp
//
//  Created by Peter Samir on 25/05/2022.
//

import Foundation


enum Endpoints {
    case allProducts
    case MenCategoryProduct
    case WomenCategoryProduct
    case KidsCategoryProduct
    case ProductDetails(id:String)
    case Smart_collections
    case CollectionID(id:String)

    
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

        case .allProducts:
            return "products.json"

        case .Smart_collections:
            return "smart_collections.json"
        case .CollectionID(id: let collectionId):
            return "products.json?collection_id=\(collectionId)"
        }
    }
}
