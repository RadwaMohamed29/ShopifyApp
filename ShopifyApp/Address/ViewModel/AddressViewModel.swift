//
//  AddressViewModel.swift
//  ShopifyApp
//
//  Created by Peter Samir on 04/06/2022.
//

import Foundation
import RxSwift

protocol AddressViewModelProtocol{
    
    var addressObservable:Observable<[Address]> { get set }
//    var addressSubject:PublishSubject<[Address]>{ get set }
    func getAddressesForCurrentUser(id:String)
}

class AddressViewModel:AddressViewModelProtocol{
    
    var addressObservable: Observable<[Address]>
    private var addressSubject: PublishSubject<[Address]> = PublishSubject<[Address]>()
    var network:NetworkServiceProtocol
    
    init(network:NetworkServiceProtocol) {
        self.network = network
        addressObservable = addressSubject.asObserver()
    }
    
    func getAddressesForCurrentUser(id:String) {
        network.getCustomerAddresses(id:id) { [weak self] response in
            switch response{
            case .success(let response):
                guard let res = response.addresses
                else {return}
                self?.addressSubject.asObserver().onNext(res)
                
            case .failure(let error):
                self?.addressSubject.asObserver().onError(error)
            }
        }
    }   
}
