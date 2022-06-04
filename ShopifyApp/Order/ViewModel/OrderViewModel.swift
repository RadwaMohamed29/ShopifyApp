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
    
}

class OrderViewModel:OrderViewModelProtocol{
    var network : NetworkServiceProtocol
    var ordersObservable: Observable<[Order]>
    private var ordersSubject =  PublishSubject<[Order]>()
    init() {
        ordersObservable = ordersSubject.asObserver()
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
    
    
}
