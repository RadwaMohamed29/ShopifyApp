//
//  LoginViewModel.swift
//  ShopifyApp
//
//  Created by Menna on 04/06/2022.
//

import Foundation
import SwiftMessages
protocol LoginViewModelType{
    func loginCustomer(email: String, password: String)
    var bindNavigate:(()->()) {get set}
    var bindDontNavigate:(()->()) {get set}
    var navigate:Bool!{get set}
    var notFound:Bool!{get set}
    var errorMessage: String! {get}
}
class LoginViewModel: LoginViewModelType{
    let network = APIClient()
    let userDefualt = Utilities()
    private var listOfCustomer : [CustomerModel] = []
    var bindNavigate:(()->()) = {}
    var bindDontNavigate:(()->()) = {}
    var errorMessage: String!{
        didSet{
            bindDontNavigate()
        }
    }
    var navigate: Bool! {
        didSet{
            bindNavigate()
        }
    }
    var notFound: Bool!{
        didSet{
            bindDontNavigate()
        }
    }
    func loginCustomer(email: String, password: String) {
        if userDefualt.isValidEmail(email) {
            if password.count >= 6 {
                network.getAllCustomers{ [weak self] result  in
                    switch result {
                    case .success(let response):
                        guard let customer = response.customers else {return}
                        self!.listOfCustomer = customer
                        for item in customer {
                            let comingMail = item.email ?? ""
                            let comingPassword = item.tags ?? ""
                            if comingMail == email && comingPassword == password {
                                self?.userDefualt.login()
                                self?.userDefualt.addId(id: item.id ?? 0)
                                self?.userDefualt.addCustomerName(customerName: "\(item.first_name!) \(item.last_name!)")
                                self?.userDefualt.setUserPassword(password: item.tags ?? "")
                                self?.userDefualt.addCustomerEmail(customerEmail: item.email ?? "")
                                self?.userDefualt.addCustomerEmail(customerEmail: item.note ?? "")
                                self?.navigate = true
                                break
                            }
                        }
                        guard let _ = self?.navigate else{
                            self?.notFound = true
                            self?.errorMessage = "user not exist, please check your information"
                            return
                        }
                    case .failure(let error):
                        self?.errorMessage = "Error occured while logging-in, please try again later"
                        print(error)
                    }
                }
            }
            else{
                errorMessage = "Password should be 6 characters at least"
            }
        }
        else{
            errorMessage = "Please enter a valid email"
        }
    }
    
    
    
}
