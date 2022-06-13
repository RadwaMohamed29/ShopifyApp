//
//  APIClient.swift
//  ShopifyApp
//
//  Created by Radwa on 18/05/2022.
//

import Foundation
import Alamofire
private let BASE_URL = "https://54e7ce1d28a9d3b395830ea17be70ae1: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@mad-ism2022.myshopify.com/admin/api/2022-04/"

class APIClient: NetworkServiceProtocol{


    func getDiscountCode(priceRule: String, completion: @escaping (Result<DiscountCode, ErrorType>) -> Void) {
        request(endpoint: .getDiscountCode(priceRule: priceRule), method: .GET, compeletion: completion)
    }

    func postAddressToCustomer(id: String, address: NewAddress, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        apiPost(endPoint: .AddressByID(id: id), methods: .POST, modelType: address, completion: completion)
    }
    

    func getAllCustomers(completion: @escaping (Result<AllCustomers, ErrorType>) -> Void) {
        request(endpoint: .Customers, method: .GET, compeletion: completion)
    }
    

    func getCustomerOrders(id: String,completion: @escaping (Result<Orders, ErrorType>) -> Void) {
        request(endpoint: .CustomerOrders(id: id), method: .GET, compeletion: completion)
    }    
    func registerCustomerProtocol(newCustomer: Customer, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        apiPost(endPoint: .Customers, methods: .POST, modelType: newCustomer, completion: completion)
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

    func getCustomerAddresses(id:String, completion:@escaping (Result<CustomerAddress, ErrorType>)->()) {
        request(endpoint: .AddressByID(id: id), method: .GET, compeletion: completion)
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
    
    func apiPost<T:Codable>(endPoint:Endpoints, methods:Methods, modelType:T, completion: @escaping (Data?, URLResponse?, Error?)->()) {
            guard let url = URL(string: "\(BASE_URL)\(endPoint.path)") else {return}
            var request = URLRequest(url: url)
            request.httpMethod = "\(Methods.POST)"
            let session = URLSession.shared
            request.httpShouldHandleCookies = false
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: modelType.asDictionary(), options: .prettyPrinted)
            }catch let error{
                print(error.localizedDescription)
            }
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            
            session.dataTask(with: request) {(data, response, error)in
                completion(data, response, error)
            }.resume()
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
                print("object discount\(object)")
            }    catch {

                    completion(.failure(.parsingError))
              //  print(fatalError(error.localizedDescription))

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
    
// https://c48655414af1ada2cd256a6b5ee391be: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@mobile-ismailia.myshopify.com/admin/api/2022-04/collections/395728126181‬/products.json
    
//    https://c48655414af1ada2cd256a6b5ee391be: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@mobile-ismailia.myshopify.com/admin/api/2022-04/products.json?collection_id=395728126181&product_type=shoes
}

//395963597058

//https://54e7ce1d28a9d3b395830ea17be70ae1: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@mad-ism2022.myshopify.com/admin/api/2022-04/smart_collections.json

//https://54e7ce1d28a9d3b395830ea17be70ae1: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@mad-ism2022.myshopify.com/admin/api/2022-04/custom_collections.json
