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
    var allBrandObservable :Observable<[Smart_collections]>{get set}
    var allDiscountObservable :Observable<[Discount_codes]>{get set}
    func  getAllBrands()
    func getDiscountCode(priceRule: String)
}
class HomeViewModel: DataOfBrands {
    var allDiscountObservable: Observable<[Discount_codes]>
    var allBrandObservable: Observable<[Smart_collections]>
    var network = APIClient()
    private var allBrandsSubject : PublishSubject = PublishSubject<[Smart_collections]>()
    private var allDiscountSubject : PublishSubject = PublishSubject<[Discount_codes]>()
    init(){
        allBrandObservable = allBrandsSubject.asObserver()
        allDiscountObservable = allDiscountSubject.asObserver()
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
    
    func getDiscountCode(priceRule: String) {
        network.getDiscountCode(priceRule: priceRule) { [weak self] result in
            switch result {
            case .success(let response):
                guard let discountCode = response.discount_codes else{return}
                self?.allDiscountSubject.asObserver().onNext(discountCode)
            case .failure(let error):
                self?.allDiscountSubject.asObserver().onError(error)
        }
      }
    }

}
