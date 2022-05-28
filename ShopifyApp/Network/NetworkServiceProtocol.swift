//
//  NetworkService.swift
//  ShopifyApp
//
//  Created by Peter Samir on 25/05/2022.
//

import Foundation

protocol NetworkServiceProtocol{


    func getBrandsFromAPI(completion: @escaping(Result<Brands,ErrorType>) -> Void)


    func productDetailsProvider(id:String ,completion :@escaping (Result<Products,ErrorType>)->Void)

    func getAllProduct(completion : @escaping (Result<AllProducts,ErrorType>)->Void)
    
    func productOfBrandsProvider(id:String ,completion :@escaping (Result<AllProducts,ErrorType>)->Void)


}
