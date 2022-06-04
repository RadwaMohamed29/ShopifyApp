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
    var searchedList : [ProductElement]{get set}
    func searchWithWord(word:String)
}

class CategoryViewModel:CategoryViewModelProtocol{
    var searchedList: [ProductElement] = []
    
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
                self?.searchedList = res
                self?.categorySubject.asObserver().onNext(self!.searchedList)
            case .failure(let error):
                self?.categorySubject.asObserver().onError(error)
            }
        }
    }
    
    func searchWithWord(word:String){
        if word.isEmpty{
            categorySubject.onNext(searchedList)
            return
        }
        let filterProducts = searchedList.filter { Product in
            return Product.title.lowercased().contains(word.lowercased())
        }
        categorySubject.onNext(filterProducts)
    }
}
