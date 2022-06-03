//
//  Utilities.swift
//  ShopifyApp
//
//  Created by Menna on 01/06/2022.
//

import Foundation
class Utilities{
    static let utilities = Utilities()
    func setTotalPrice(totalPrice:Double){
        UserDefaults.standard.set(totalPrice, forKey: "Total_Price")
    }
    
    
    func addCustomerId(id: Int){
        UserDefaults.standard.set(id, forKey: "id")
    }
    
    func getCustomerId()->Int{
        return UserDefaults.standard.value(forKey: "id") as? Int ?? 0
    }
    
    func addCustomerName(customerName: String){
        UserDefaults.standard.set(customerName, forKey: "name")
    }
    
    func getCustomerName()-> String{
        return UserDefaults.standard.value(forKey: "name") as? String ?? ""
    }
    
    func addCustomerEmail(customerEmail: String){
        UserDefaults.standard.set(customerEmail, forKey: "email")
    }
    
    func getCustomerEmail()-> String{
        return UserDefaults.standard.value(forKey: "email") as? String ?? ""
    }
}
