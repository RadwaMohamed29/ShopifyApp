//
//  CategoryViewModel.swift
//  ShopifyApp
//
//  Created by Peter Samir on 26/05/2022.
//

import Foundation
import RxCocoa
import RxSwift

protocol CategoryViewModelProtocol {
    var categoryObservable:Observable<[ProductElement]>
    { get set }
    var categorySubject:PublishSubject<[ProductElement]>{get set}
    func getFilteredProducts(target:Endpoints)
    
}

class CategoryViewModel:CategoryViewModelProtocol{
    var categoryObservable: Observable<[ProductElement]>
    
    var categorySubject: PublishSubject<[ProductElement]> = PublishSubject<[ProductElement]>()
    
    var network:NetworkServiceProtocol
    
    
    init(network:NetworkServiceProtocol) {
        self.network = network
        categoryObservable = categorySubject.asObserver()
    }
    
    func getFilteredProducts(target:Endpoints){
        network.getFilteredCategory(target: target) {[weak self] result in
            switch result{
            case .success(let response):
                guard let res = response.products else {return}
                self?.categorySubject.asObserver().onNext(res)
            case .failure(let error):
                self?.categorySubject.asObserver().onError(error)
            }
        }
    }
}
// guard let res = response.products else {return}
//self?.categorySubject.asObserver().onNext(res)
