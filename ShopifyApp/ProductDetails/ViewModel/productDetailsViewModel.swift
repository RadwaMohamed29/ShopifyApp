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
    func  getProduct(id:String)
    var  productObservable: Observable<Product>{get set}
}

//https://c48655414af1ada2cd256a6b5ee391be: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@mobile-ismailia.myshopify.com/admin/api/2022-04/products/7782820085989.json

final class ProductDetailsViewModel: ProductDetailsViewModelType{
    
    var network = APIClient()
    var productObservable: Observable<Product>
    private var productSubject: PublishSubject = PublishSubject<Product>()
   
    init(){
        productObservable = productSubject.asObserver()
    }

    func getProduct(id:String) {
        network.productDetailsProvider(id: id, completion: {[weak self] result in
            switch result {
            case .success(let response):
                guard let product = response.product else {return}
                self?.productSubject.asObserver().onNext(product)
                print(product.title)
            case .failure(let error):
                self?.productSubject.asObserver().onError(error)
                print(error.localizedDescription)
            }
        })
        

    }

    
    
    
}
