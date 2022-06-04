//
//  NetworkService.swift
//  ShopifyApp
//
//  Created by Peter Samir on 25/05/2022.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol{


    func getBrandsFromAPI(completion: @escaping(Result<Brands,ErrorType>) -> Void)


    func productDetailsProvider(id:String ,completion :@escaping (Result<Products,ErrorType>)->Void)

    func getAllProduct(completion : @escaping (Result<AllProducts,ErrorType>)->Void)
    func productOfBrandsProvider(id:String ,completion :@escaping (Result<AllProducts,ErrorType>)->Void)

    
    func getFilteredCategory(target:Endpoints, completion: @escaping(Result<CategoryProducts, ErrorType>)->())
    
    func registerCustomerProtocol(newCustomer: Customer,completion: @escaping(Data?, URLResponse?, Error?)->())
    func getAllCustomers(completion: @escaping (Result<LoginResponse,ErrorType>)->Void)
}
