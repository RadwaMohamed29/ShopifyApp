//
//  CategoryViewModel.swift
//  ShopifyApp
//
//  Created by Peter Samir on 26/05/2022.
//

import Foundation

class CategoryViewModel{
    var network:NetworkServiceProtocol
    
    
    init(network:NetworkServiceProtocol) {
        self.network = network
    }
    
    func getFilteredProducts(target:Endpoints){
        
    }
}
