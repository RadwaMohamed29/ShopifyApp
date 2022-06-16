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
    func getAddDetailsAndPostToCustomer(customerID:String, buildNo:String, streetName:String, city:String, country:String, completion: @escaping(Bool)->())
    func deleteAddress(addressID: String, customerID: String)
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
        network.deleteAddress(customerID: customerID, addressID: addressID, address: address) { [weak self] (data, response, error) in
            let json = try! JSONSerialization.jsonObject(with: data!, options: .allowFragments) as! Dictionary<String,Any>
//            if json.isEmpty {
//                print("deleted")
//                //delete address from coreData
//                self?.coreDataRepo.deleteAddress(id: addressId)
//                self?.addresses = self?.coreDataRepo.getAddresses()
//            }else{
//                print("cant delete")
//                self?.cantDeleteAddress()
//            }
            print(json)
            
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
    
    func getAddDetailsAndPostToCustomer(customerID:String, buildNo:String, streetName:String, city:String, country:String, completion: @escaping (Bool)->()){
        let address = Address(address1: buildNo, address2: streetName, city: city, country: country)
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
