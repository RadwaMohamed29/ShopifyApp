//
//  AddressViewModel.swift
//  ShopifyApp
//
//  Created by Peter Samir on 04/06/2022.
//

import Foundation
import RxSwift

protocol AddressViewModelProtocol{
    
    var networkObservable:Observable<Bool> { get set }
    var addressObservable:Observable<[Address]> { get set }
//    var addressSubject:PublishSubject<[Address]>{ get set }
    func getAddressesForCurrentUser(id:String)
    func checkConnection()
    func getAddDetailsAndPostToCustomer(customerID:String, phone: String, streetName:String, city:String, country:String, completion: @escaping(Bool)->())
    func deleteAddress(addressID: String, customerID: String)
    func editAddress(address: Address,addressID: String, customerID: String, completion: @escaping (Bool)->())
}

class AddressViewModel:AddressViewModelProtocol{

    
    var networkObservable: Observable<Bool>
    var networkSubject = PublishSubject<Bool>()
    var addressObservable: Observable<[Address]>
    private var addressSubject: PublishSubject<[Address]> = PublishSubject<[Address]>()
    var network:NetworkServiceProtocol
    let address = NewAddress(address: Address())
    
    init(network:NetworkServiceProtocol) {
        self.network = network
        addressObservable = addressSubject.asObserver()
        networkObservable = networkSubject.asObserver()
    }
    
    func deleteAddress(addressID: String,customerID: String ) {
        network.deleteAddress(customerID: customerID, addressID: addressID, address: address) {(data, response, error) in
            let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String,Any>
            if json.isEmpty {
                print("deleted")
            }else{
                print("cant delete")
            }
            print(json)
            
        }
    }
    
    func editAddress(address: Address,addressID: String, customerID: String, completion: @escaping (Bool)->()) {
        network.updateAddress(customerID: customerID, addressID: addressID, address: address) { (data, response, error) in
            if error != nil {
                print ("can't edit address")
                return
            }
            else{
                if let data = data{
                    print(data)
                    do{
                    let json = try? JSONSerialization.jsonObject(with: data, options:
                            .allowFragments) as? Dictionary<String, Any>
                        if json?["errors"] != nil{
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
    
    func getAddDetailsAndPostToCustomer(customerID:String, phone: String, streetName:String, city:String, country:String, completion: @escaping (Bool)->()){
        let address = Address(address2: streetName, city: city, country: country, phone: phone)
        let newAddress = NewAddress(address: address)
        network.postAddressToCustomer(id: customerID, address: newAddress) { data, response, error in
            if error != nil{
                print(error!)
            }else{
                if let data = data{
                    print(data)
                    do{
                    let d = try? JSONSerialization.jsonObject(with: data, options:
                            .allowFragments) as? Dictionary<String, Any>
                        if d?["errors"] != nil{
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
    
    func checkConnection() {
        HandelConnection.handelConnection.checkNetworkConnection { [weak self] isconn in
            if isconn{
                self?.networkSubject.asObserver().onNext(true)
            }else{
                self?.networkSubject.asObserver().onNext(false)
            }
        }
    }
}
