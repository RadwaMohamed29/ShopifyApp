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
    func  getAllProducts()
    func  getProductOfBrand(id:String)
    var  productObservable: Observable<Product>{get set}
    var  allProductsObservable :Observable<[Product]>{get set}
    var  brandsObservable :Observable<[Product]>{get set}
}

//https://c48655414af1ada2cd256a6b5ee391be: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@mobile-ismailia.myshopify.com/admin/api/2022-04/products/7782820085989.json

final class ProductDetailsViewModel: ProductDetailsViewModelType{
    func getProductOfBrand(id: String) {
        network.productOfBrandsProvider(id: id, completion:
                {[weak self] result in
                 switch result {
                 case .success(let response):
                     guard let product = response.products else {return}
                     self?.brandsSubject.asObserver().onNext(product)
                     print(product.count)
                 case .failure(let error):
                     self?.brandsSubject.asObserver().onError(error)
                     print(error.localizedDescription)
            }
       })
                                            
    }
    
    var brandsObservable: Observable<[Product]>
    private var listOfProduct : [Product] = []
    var network = APIClient()
    var productObservable: Observable<Product>
    var allProductsObservable :Observable<[Product]>
    private var productSubject: PublishSubject = PublishSubject<Product>()
    private var allProductsSubject : PublishSubject = PublishSubject<[Product]>()
    private var brandsSubject : PublishSubject = PublishSubject<[Product]>()


   
    init(){
        productObservable = productSubject.asObserver()
        allProductsObservable = allProductsSubject.asObserver()
        brandsObservable=brandsSubject.asObservable()

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


    func getAllProducts() {
        network.getAllProduct { [weak self] result in
            switch result {
            case .success(let response):
                guard let allProducts = response.products else{return}
                self?.listOfProduct = allProducts
                self?.allProductsSubject.asObserver().onNext(allProducts)
            case .failure(let error):
                self?.allProductsSubject.asObserver().onError(error)
            }
        }
    }

    func searchWithWord(word:String){
        if word.isEmpty{
            allProductsSubject.onNext(listOfProduct)
            return
        }
            let filterProducts = listOfProduct.filter { Product in
                return Product.title.lowercased().contains(word.lowercased())
        }
        allProductsSubject.onNext(filterProducts)

    }
}
