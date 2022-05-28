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
    var  favoriteProducts : [FavoriteProducts]? {get set}
    var  productObservable: Observable<Product>{get set}
    var allProductsObservable :Observable<[Product]>{get set}
    func addFavouriteProductToCoreData(product:Product , completion: @escaping (Bool)->Void) throws
    func getAllFavoriteProducts(completion: @escaping (Bool)->Void) throws
    func removeProductFromFavorites(productID:String, completionHandler:@escaping (Bool) -> Void) throws
}


final class ProductDetailsViewModel: ProductDetailsViewModelType{
    
    
    var favoriteProducts: [FavoriteProducts]?
    var isFav : Bool?
   
    
    private var listOfProduct : [Product] = []
    var network = APIClient()
    var localDataSource :LocalDataSource
   
    var productObservable: Observable<Product>
    var allProductsObservable :Observable<[Product]>
    private var productSubject: PublishSubject = PublishSubject<Product>()
    private var allProductsSubject : PublishSubject = PublishSubject<[Product]>()

    
   
    init(appDelegate :AppDelegate){
        localDataSource = LocalDataSource(appDelegate: appDelegate)
        productObservable = productSubject.asObserver()
        allProductsObservable = allProductsSubject.asObserver()
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

    func getAllFavoriteProducts(completion: @escaping (Bool)->Void) throws{
        
        do{
           try  favoriteProducts =  localDataSource.getProductFromCoreData()
            completion(true)
        }catch let error{
            completion(false)
            throw error
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
    
    func addFavouriteProductToCoreData(product:Product , completion: @escaping (Bool)->Void) throws{
        
        do{
            try  localDataSource.saveProductToCoreData(newProduct: product)
            completion(true)
        }
        catch let error{
            completion(false)
            throw error
        }
    }
    
    func removeProductFromFavorites(productID: String, completionHandler: @escaping (Bool) -> Void) throws {
        do{
           try localDataSource.removeProductFromCoreData(productID: productID)
            completionHandler(true)
        }catch let error{
            completionHandler(false)
            throw error
        }
        
    }
    
    
    func checkFavorite(id : String){
        do{
           try isFav = localDataSource.isFavouriteProduct(productID: id)
        }catch let error{
            print(error.localizedDescription)
        }
       
    }
 

}
