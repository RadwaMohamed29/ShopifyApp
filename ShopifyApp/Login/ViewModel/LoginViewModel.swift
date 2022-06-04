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
    var navigate:Bool!{get set}
    var notFound:Bool!{get set}
    var bindNavigate:(()->()) {get set}
    var bindDontNavigate:(()->()) {get set}
    var alertMessage: String! {get}
    
}
class LoginViewModel: LoginViewModelType{
    let network = APIClient()
    let userDefualt = Utilities()
    
    var alertMessage: String!{
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

    var bindNavigate:(()->()) = {}
    var bindDontNavigate:(()->()) = {}
    private var listOfCustomer : [CustomerModel] = []
    func loginCustomer(email: String, password: String) {
        if userDefualt.isValidEmail(email) {
            if password.count >= 6 {
                network.login(email: email, password: password) { [weak self] result  in
                    switch result {
                    case .success(let response):
                        guard let customer = response.customers else {return}
                        self!.listOfCustomer = customer
                        for item in customer {
                            let comingMail = item.email ?? ""
                            let comingPassword = item.tags ?? ""
                            if comingMail == email && comingPassword == password {
                                // address
                                self?.userDefualt.login()
                                self?.userDefualt.addId(id: item.id ?? 0)
                                self?.navigate = true
                                break
                            }
                        }
                        guard let _ = self?.navigate else{
                            self?.notFound = true
                            self?.alertMessage = "Can't login, please check your information"
                            return
                        }
                    case .failure(let error):
                        self?.alertMessage = "An error occured while logging-in, please try again later"
                        print(error)
                    }
                }
            }
            else{
                alertMessage = "Password should be 6 characters at least"
            }
        }
        else{
            alertMessage = "Please enter a valid email"
        }
    }
    
    
    
}
