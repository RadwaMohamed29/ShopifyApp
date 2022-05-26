//
//  HomeViewModel.swift
//  ShopifyApp
//
//  Created by Menna on 26/05/2022.
//

import Foundation
import RxCocoa
import RxSwift
protocol DataOfBrands{
    func  getAllBrands()
  var allBrandObservable :Observable<[Smart_collections]>{get set}
}
class HomeViewModel: DataOfBrands {
    var allBrandObservable: Observable<[Smart_collections]>
    
    var network = APIClient()
    private var allBrandsSubject : PublishSubject = PublishSubject<[Smart_collections]>()
    init(){
        allBrandObservable = allBrandsSubject.asObserver()
    }
    func getAllBrands() {
        network.getBrandsFromAPI { [weak self] result in
            switch result {
            case .success(let response):
                guard let allBrands = response.smart_collections else{return}
                self?.allBrandsSubject.asObserver().onNext(allBrands)
            case .failure(let error):
                self?.allBrandsSubject.asObserver().onError(error)
            }
        }
    }
}
