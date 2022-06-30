//
//  RegisterViewModel.swift
//  ShopifyApp
//
//  Created by Radwa on 03/06/2022.
//

import Foundation

protocol RegisterViewModelType{
    func registerCustomer(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Bool)->Void)
    var bindNavigate:(()->()) {get set}
    var bindDontNavigate:(()->()) {get set}
    var navigate:Bool!{get set}
    var flag: Bool {get set}
    //  func editCustomer(customer: EditCustomer, customerID: Int, completion: @escaping (Bool)->())
    //func isEmailExist(email: String)-> Bool
}

class RegisterViewModel: RegisterViewModelType{
    
    var bindNavigate:(()->()) = {}
    var bindDontNavigate:(()->()) = {}
    var navigate: Bool! {
        didSet{
            bindNavigate()
        }
    }
    let network = APIClient()
    let userDefualt = Utilities()
    private var listOfCustomer : [CustomerModel] = []
    var flag: Bool = false
    
    func registerCustomer(firstName: String, lastName: String, email: String, password: String, completion: @escaping (Bool)->Void ) {
        flag = false
        network.getAllCustomers{ [weak self] result  in
            switch result{
            case .success(let response):
                guard let checkedCustomer = response.customers else {return}
                self?.listOfCustomer = checkedCustomer
                for item in checkedCustomer {
                    let comingMail = item.email ?? ""
                    if comingMail == email{
                        self?.flag=true
                    }
                }
                if self?.flag == false{
                    let customer = CustomerModel(first_name: firstName, last_name: lastName, email: email, phone: nil , tags: password, id: nil , verified_email: true, addresses: nil , note: "0" )
                    let newCustomer = Customer(customer: customer)
                    self?.registerCustomer(customer: newCustomer){ result in
                        switch result{
                        case true:
                            completion(true)
                            self?.navigate = true
                        case false:
                            completion(false)
                            self?.navigate = false
                        }
                        
                    }
                    
                }else{
                    self?.navigate = false
                    completion(false)
                }
                
            case .failure(let error):
                print(error)
            }
            
        }
        
    }
    
    func registerCustomer(customer: Customer, completion: @escaping (Bool)->Void ){
        network.registerCustomerProtocol(newCustomer: customer) {[weak self] (data, response, error )in
            if error != nil{
                print(error!)
                completion(false)
            }else{
                if let data = data{
                    let json = try! JSONSerialization.jsonObject(with: data, options:
                                                                        .allowFragments) as! Dictionary<String, Any>
                    let savedCustomer = json["customer"] as? Dictionary<String,Any>
                    let id = savedCustomer?["id"] as? Int ?? 0
                    let customerName = savedCustomer?["first_name"] as? String ?? ""
                    let customerLastName = savedCustomer?["last_name"] as? String ?? ""
                    let customerEmail = savedCustomer?["email"] as? String ?? ""
                    let customerPassword = savedCustomer?["tags"] as? String ?? ""

                    let customerNote = savedCustomer?["note"] as? String ?? "0"

                    
                    if id != 0 {
                        self?.userDefualt.login()
                        self?.userDefualt.addCustomerId(id: id)
                        self?.userDefualt.addCustomerEmail(customerEmail: customerEmail)
                        self?.userDefualt.addCustomerName(customerName: "\(customerName) \(customerLastName)")
                        self?.userDefualt.login()
                        self?.userDefualt.setUserPassword(password: customerPassword)

                        self?.userDefualt.setUserNote(note: customerNote)

                        print("passwordUserrrr\( String(describing: self?.userDefualt.getUserPassword()))")
                        completion(true)

                        //self?.navigate = true
                        
                        print("add to userDefualt successfully!!!")
                    }else{
                        completion(false)
                        //self?.navigate = false
                        print("error to register")
                    }
                }
            }
        }
    }
    
    func editCustomer(customer: EditCustomer, customerID: Int, completion: @escaping (Bool)->()) {
        network.editeCustomer(id: customerID, editeCustomer: customer, completion: { (data, response, error) in
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
                              
                              
        )
    }
    
    
}
