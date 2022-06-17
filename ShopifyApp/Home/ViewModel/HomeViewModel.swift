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
                print("disssssssssssss\(discountCode.count)")
                self?.allDiscountSubject.asObserver().onNext(discountCode)
            case .failure(let error):
                self?.allDiscountSubject.asObserver().onError(error)
        }
      }
    }

    var bindAddsViewModelToView : (()->()) = {}
    var adds: [Discount_codes]? {
        didSet {
            self.bindAddsViewModelToView()
        }
    }
    var bindViewModelErrorToView : (()->()) = {}
    var showError: String? {
        didSet {
            self.bindViewModelErrorToView()
        }
    }
    let userDefualt = Utilities()

    func fetchAdds (priceRuleID: String = "1173393834242"){
        
        network.getDiscountCode(priceRule: priceRuleID){ [weak self] result in
            switch result {
            case .success(let response):
                guard let discountCode = response.discount_codes else{return}
                self?.adds = discountCode
              // print("discount code: \(self?.adds?[0].code ?? "5")")
                self?.userDefualt.setDiscountCode(code: discountCode[0].code ?? "")
                
            case .failure(let error):
                print(error.localizedDescription)
        }
        }
    }
}
