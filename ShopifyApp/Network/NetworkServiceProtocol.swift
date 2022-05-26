//
//  NetworkService.swift
//  ShopifyApp
//
//  Created by Peter Samir on 25/05/2022.
//

import Foundation

protocol NetworkServiceProtocol{
    func productDetailsProvider(id:String ,completion :@escaping (Result<Products,ErrorType>)->Void)
    
    func getFilteredCategory(target:Endpoints, completion: @escaping(Result<CategoryProducts, ErrorType>)->())
}
