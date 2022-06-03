//
//  APIClient.swift
//  ShopifyApp
//
//  Created by Radwa on 18/05/2022.
//

import Foundation
import Alamofire
private let BASE_URL = "https://c48655414af1ada2cd256a6b5ee391be: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@mobile-ismailia.myshopify.com/admin/api/2022-04/"

class APIClient: NetworkServiceProtocol{
    func registerCustomerProtocol(newCustomer: Customer, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        registerCustomer(endpoint: .Customers, newCustomer: newCustomer, completion: completion)
    }
    
  
    
    func productOfBrandsProvider(id: String, completion: @escaping (Result<AllProducts, ErrorType>) -> Void) {
        request(endpoint: .CollectionID(id: id), method: .GET, compeletion: completion)
    }
    

    func getAllProduct(completion: @escaping (Result<AllProducts, ErrorType>) -> Void) {
        request(endpoint: .allProducts, method: .GET, compeletion: completion)
    }
    
    


    func getBrandsFromAPI(completion: @escaping (Result<Brands, ErrorType>) -> Void) {
        request(endpoint: .Smart_collections, method: .GET, compeletion: completion)
    }
    
    func getFilteredCategory(target: Endpoints, completion: @escaping (Result<CategoryProducts, ErrorType>) -> ()) {
        request(endpoint: target, method: .GET, compeletion: completion)
    }


    
    func productDetailsProvider(id: String, completion: @escaping (Result<Products, ErrorType>) -> Void) {
        request(endpoint: .ProductDetails(id: id), method: .GET, compeletion: completion)
    }
    

    func request<T:Codable>(endpoint: Endpoints, method: Methods, compeletion: @escaping (Result<T, ErrorType>) -> Void) {
        let path = "\(BASE_URL)\(endpoint.path)"
        print("here is the path: \(path)")
        let urlString = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        guard let urlString = urlString else {
            compeletion(.failure(.urlBadFormmated))
            return
        }
        
        guard let urlRequest = URL(string: urlString) else {
            compeletion(.failure(.InternalError))
            return
        }
        
        var  request = URLRequest(url: urlRequest)
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        request.httpMethod = "\(method)"
        callNetwork(urlRequest: request, completion: compeletion)
       
        
    }
    
    func callNetwork<T:Codable>(urlRequest:URLRequest, completion: @escaping (Result<T, ErrorType>) -> Void) {
        
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            guard error == nil else {
                completion(.failure(.ServerError))
                return
            }
            guard let data = data else {
                completion(.failure(.ServerError))
                return
            }
            
            do{
                let object = try JSONDecoder().decode(T.self, from: data)
                completion(.success(object))
            }    catch {

                    completion(.failure(.parsingError))
                print(fatalError(error.localizedDescription))

                }
        }.resume()
    }
    
    func registerCustomer(endpoint: Endpoints,newCustomer: Customer, completion: @escaping(Data?, URLResponse?, Error?)->()){
        guard let url = URL(string: "\(BASE_URL)\(endpoint.path)") else {return}
        var request = URLRequest(url: url)
        request.httpMethod = "\(Methods.POST)"
        let session = URLSession.shared
        request.httpShouldHandleCookies = false
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: newCustomer.asDictionary(), options: .prettyPrinted)
            
        }catch let error{
            print(error.localizedDescription)
        }
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        session.dataTask(with: request) {(data, response, error)in
            completion(data, response, error)
        }.resume()
    
}

//https://c48655414af1ada2cd256a6b5ee391be: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@mobile-ismailia.myshopify.com/admin/api/2022-04/products.json?collection_id=products.json?product_type=SHOES&product_type=shoes
}
