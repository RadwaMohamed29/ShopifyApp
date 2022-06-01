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
}
