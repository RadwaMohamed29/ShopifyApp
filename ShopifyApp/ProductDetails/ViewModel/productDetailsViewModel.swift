//
//  productDetailsViewModel.swift
//  ShopifyApp
//
//  Created by Radwa on 25/05/2022.
//

import Foundation
import RxCocoa
import RxSwift

protocol ProductDetailsViewModelType{
   func  getProduct()
    var  productObservable: Driver<[Product]>{get set}
}

final class ProductDetailsViewModel: ProductDetailsViewModelType{
    var productObservable: Driver<[Product]>
    private var productSubject: PublishSubject = PublishSubject<[Product]>()
    init(){
        
    }
    
    func getProduct() {
        <#code#>
    }
    
    
    
    
}
