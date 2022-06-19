//
//  OrderViewModel.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 04/06/2022.
//

import Foundation
import RxSwift
protocol OrderViewModelProtocol{
    func getAllOrdersForSpecificCustomer(id:String)throws
    var ordersObservable : Observable<[Order]> {get set}
    func getCurrentCustomer(id:String)throws
    var customerObservable : Observable<Customer> {get set}
    func addOrder(order:AkbrOrder,completion:@escaping(Bool)->())
}

class OrderViewModel:OrderViewModelProtocol{
   
    
    var network : NetworkServiceProtocol
    var ordersObservable: Observable<[Order]>
    private var ordersSubject =  PublishSubject<[Order]>()
    var customerObservable : Observable<Customer>
    private var customerSubject =  PublishSubject<Customer>()
    init() {
        ordersObservable = ordersSubject.asObserver()
        customerObservable = customerSubject.asObserver()
        network = APIClient()
    }
    func getAllOrdersForSpecificCustomer(id: String) throws {
        network.getCustomerOrders(id: id) { result in
            switch result{
            case .success(let response):
                 let orders = response.orders 
                self.ordersSubject.asObserver().onNext(orders)
            case .failure(let error):
                self.ordersSubject.asObserver().onError(error)
            }
    
        }
    }
    
    func getCurrentCustomer(id:String)throws{
        network.getCustomer(id: id) { result in
            switch result{
            case .success(let response):
                let customer = response
                self.customerSubject.asObserver().onNext(customer)
            case .failure(let error):
                self.customerSubject.asObserver().onError(error)
            }
        }
    }
    
    func addOrder(order: AkbrOrder, completion: @escaping (Bool) -> ()) {
        network.postOrder(order: order) { data, respinse, error in
            if error != nil{
                print(error?.localizedDescription ?? "")
            }else{
                if let data = data{
                    print(data)
                    do{
                    let dictionary = try? JSONSerialization.jsonObject(with: data, options:
                            .allowFragments) as? Dictionary<String, Any>
                        print(dictionary)
                        if dictionary?["errors"] != nil{
                            completion(false)
                        }else{
                            completion(true)
                        }
                    }catch{
                        completion(false)
                    }
                }
                
            }
        }
    }
    
}
