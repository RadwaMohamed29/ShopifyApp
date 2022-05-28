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
    func productOfBrandsProvider(id: String, completion: @escaping (Result<AllProducts, ErrorType>) -> Void) {
        request(endpoint: .CollectionID(id: id), method: .GET, compeletion: completion)
    }
    

    func getAllProduct(completion: @escaping (Result<AllProducts, ErrorType>) -> Void) {
        request(endpoint: .allProducts, method: .GET, compeletion: completion)
    }
    
    


    func getBrandsFromAPI(completion: @escaping (Result<Brands, ErrorType>) -> Void) {
        request(endpoint: .Smart_collections, method: .GET, compeletion: completion)
    
    }


    func productDetailsProvider(id: String, completion: @escaping (Result<Products, ErrorType>) -> Void) {
        request(endpoint: .ProductDetails(id: id), method: .GET, compeletion: completion)
    }
    

    func request<T:Codable>(endpoint: Endpoints, method: Methods, compeletion: @escaping (Result<T, ErrorType>) -> Void) {
        let path = "\(BASE_URL)\(endpoint.path)"
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
    
}
