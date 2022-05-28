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
    case SaleCategoryProduct
    case ProductDetails(id:String)
    case TshirtType(id:String)
    case ShoesType(id:String)
    case AccecoriesType(id:String)
    
    var path:String{
        switch self {
        case .SaleCategoryProduct:
            return "collections/395728224485/products.json"
        case .HomeCategoryProducts:
            return "products.json"
        case .MenCategoryProduct:
            return "collections/395728126181‬/products.json"
        case .WomenCategoryProduct:
            return "collections/395728158949/products.json"
        case .KidsCategoryProduct:
            return "collections/395728191717/products.json"
        case .ProductDetails(id: let productId):
            return "products/\(productId).json"
        case .TshirtType(id: let categoryID):
            return "collection_id=\(categoryID)&product_type=T-SHIRTS"
        case .ShoesType(id: let categoryID):
            return "collection_id=\(categoryID)&product_type=shoes"
        case .AccecoriesType(id: let categoryID):
            return "collection_id=\(categoryID)&product_type=ACCESSORIES"
        }
    }
}
enum categoryID {
    case MEN
    case WOMEN
    case KIDS
    case SALE
    case Home
    
    var ID:String{
        switch self {
        case .MEN:
            return "395728126181‬"
        case .WOMEN:
            return "395728158949"
        case .KIDS:
            return "395728191717"
        case .SALE:
            return "395728224485"
        case .Home:
            return "products.json"
        }
    }
}

