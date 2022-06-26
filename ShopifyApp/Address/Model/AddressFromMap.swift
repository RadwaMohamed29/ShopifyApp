//
//  AddressFromMap.swift
//  ShopifyApp
//
//  Created by Peter Samir on 26/06/2022.
//

import Foundation


class AddressFromMap{
    
    var streetName:String
    var city:String
    var country:String
    
    init(streetName:String, city:String, country:String) {
        self.country = country
        self.city = city
        self.streetName = streetName
    }
}
