//
//  RegisterViewModel.swift
//  ShopifyApp
//
//  Created by Radwa on 03/06/2022.
//

import Foundation

protocol RegisterViewModelType{
    func registerCustomer(firstName: String, lastName: String, email: String, password: String)
    
}

class RegisterViewModel: RegisterViewModelType{
    let network = APIClient()
    let userDefualt = Utilities()
    
    func registerCustomer(firstName: String, lastName: String, email: String, password: String) {
        if firstName != ""{
            let customer = CustomerModel(first_name: firstName, last_name: lastName, email: email, phone: nil , tags: password, id: nil , verified_email: true, addresses: nil )
            let newCustomer = Customer(customer: customer)
            registerCustomer(customer: newCustomer)
        }else{
            print("invalid data ")
        }
    }
    
    func registerCustomer(customer: Customer){
        network.registerCustomerProtocol(newCustomer: customer) {[weak self] (data, response, error )in
            if error != nil{
                print(error)
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
