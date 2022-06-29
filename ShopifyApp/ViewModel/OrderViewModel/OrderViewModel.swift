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
    func addOrder(order:OrderObject,completion:@escaping(Bool)->())
    func removeItemsFromCartToSpecificCustomer()throws
}

class OrderViewModel:OrderViewModelProtocol{
    var network : NetworkServiceProtocol
    var local : LocalDataSource
    var ordersObservable: Observable<[Order]>
    private var ordersSubject =  PublishSubject<[Order]>()

    init(appDelegate:AppDelegate) {
        ordersObservable = ordersSubject.asObserver()
        network = APIClient()
        local = LocalDataSource(appDelegate: appDelegate)
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
    

    
    func addOrder(order: OrderObject, completion: @escaping (Bool) -> ()) {
        network.postOrder(order: order) { data, respinse, error in
            if error != nil{
                print(error?.localizedDescription ?? "")
            }else{
                if let data = data{
                    print(data)
                    do{
                    let dictionary = try? JSONSerialization.jsonObject(with: data, options:
                            .allowFragments) as? Dictionary<String, Any>
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
    
    func removeItemsFromCartToSpecificCustomer() throws {
        do{
            try local.removeItemsFromCartToSpecificCustomer()
        }
        catch let error{
            throw error
        }
    }
    
}
