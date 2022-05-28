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
    case HomeWithProductType(id:categoryID)
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
            return "products.json?collection_id=\(categoryID)&product_type=T-SHIRTS"
        case .ShoesType(id: let categoryID):
            return "products.json?collection_id=\(categoryID)&product_type=shoes"
        case .AccecoriesType(id: let categoryID):
            return "products.json?collection_id=\(categoryID)&product_type=ACCESSORIES"
        case .HomeWithProductType(id: let categoryID):
            return "products.json?product_type=\(categoryID)"
        }
    }
}
enum categoryID {
    case MEN
    case WOMEN
    case KIDS
    case SALE
    case Home(type:String)
    
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
        case .Home(type: let type):
            return "products.json?product_type=\(type)"
        }
    }
}
//https://c48655414af1ada2cd256a6b5ee391be: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@mobile-ismailia.myshopify.com/admin/api/2022-04/products.json?collection_id=395728126181‬&product_type=T-SHIRTS

//https://c48655414af1ada2cd256a6b5ee391be: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@mobile-ismailia.myshopify.com/admin/api/2022-04/products.json?collection_id=395728126181&product_type=shoes
//path    String    "https://c48655414af1ada2cd256a6b5ee391be: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@mobile-ismailia.myshopify.com/admin/api/2022-04/collections/395728126181\u{202c}/products.json"    
//path    String    "https://c48655414af1ada2cd256a6b5ee391be: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@mobile-ismailia.myshopify.com/admin/api/2022-04/products.json?collection_id=395728126181&product_type=shoes"    
//path    String    "https://c48655414af1ada2cd256a6b5ee391be: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@mobile-ismailia.myshopify.com/admin/api/2022-04/products.json?collection_id=395728126181\u{202c}&product_type=shoes"
