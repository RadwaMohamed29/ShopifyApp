//
//  RegisterViewModel.swift
//  ShopifyApp
//
//  Created by Radwa on 03/06/2022.
//

import Foundation
import RxSwift

protocol RegisterViewModelType{
    func registerCustomer(firstName: String, lastName: String, email: String, password: String)
    func isEmailExist(email: String)
    var isExist: Bool {get set}
    var isExistObservable : Observable<Bool> {get set}
}

class RegisterViewModel: RegisterViewModelType{
    var isExist: Bool
    var isExistObservable: Observable<Bool>
    private var isExistSubject =  PublishSubject<Bool>()
    let network : NetworkServiceProtocol
    let userDefualt = Utilities()
    
    private var listOfCustomer : [CustomerModel] = []
    init(){
        network = APIClient()
        isExistObservable = isExistSubject.asObserver()
        isExist = false
    }
    func registerCustomer(firstName: String, lastName: String, email: String, password: String) {
        if firstName != ""{
            let customer = CustomerModel(first_name: firstName, last_name: lastName, email: email, phone: nil , tags: password, id: nil , verified_email: true, addresses: nil )
            let newCustomer = Customer(customer: customer)
            registerCustomer(customer: newCustomer)
        }else{
            print("invalid data ")
        }
    }
    
    
    func isEmailExist(email: String) {
        network.login(email: email, password: ""){ [weak self] result  in
            switch result{
            case .success(let response):
                guard let checkedCustomer = response.customers else {return}
                self?.listOfCustomer = checkedCustomer
                for item in checkedCustomer {
                    let comingMail = item.email ?? ""
                    if comingMail == email{
                        self?.isExist = true
                        return
                    }
                    else{
                        self?.isExist = false
                    }
                }
                if self?.isExist == true{
                    self?.isExistSubject.asObserver().onNext(true)
                }else{
                    self?.isExistSubject.asObserver().onNext(false)
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
    }
   
    func registerCustomer(customer: Customer){
        network.registerCustomerProtocol(newCustomer: customer) {[weak self] (data, response, error )in
            if error != nil{
                print(error!)
            }else{
                if let data = data{
                    let json = try! JSONSerialization.jsonObject(with: data, options:
                                                                        .allowFragments) as! Dictionary<String, Any>
                    let savedCustomer = json["customer"] as? Dictionary<String,Any>
                    let id = savedCustomer?["id"] as? Int ?? 0
                    let customerName = savedCustomer?["first_name"] as? String ?? ""
                    let customerEmail = savedCustomer?["email"] as? String ?? ""
                    
                    if id != 0 {
                        self?.userDefualt.addCustomerId(id: id)
                        self?.userDefualt.login()
                        self?.userDefualt.addCustomerEmail(customerEmail: customerEmail)
                        self?.userDefualt.addCustomerName(customerName: customerName)
                        
                        print("add to userDefualt successfully!!!")
                    }else{
                        print("error to register")
                    }
                }
            }
        }
    }


}
