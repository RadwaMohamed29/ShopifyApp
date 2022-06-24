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
    func getProduct(id:String)
    func getAllProducts()
    var  favoriteProducts : [FavouriteProduct]? {get set}
    var  productObservable: Observable<Product>{get set}
    var  allProductsObservable :Observable<[Product]>{get set}
    var  brandsObservable :Observable<[Product]>{get set}
    func addFavouriteProductToCoreData(product:FavouriteProduct , completion: @escaping (Bool)->Void) throws
    func getAllFavoriteProducts(completion: @escaping (Bool)->Void) throws
    func removeProductFromFavorites(productID:String, completionHandler:@escaping (Bool) -> Void) throws
    func getProductOfBrand(id:String)
    func addProductToCoreDataCart(id: String,title:String,image:String,price:String, itemCount: Int,quantity:Int,completion: @escaping (Bool)->Void) throws
    func checkProductInCart(id: String)
    func getAllProductsInCart(completion: @escaping (Bool)->Void) throws
    func removeProductFromCart(productID:String, completionHandler:@escaping (Bool) -> Void) throws
    func updateCount(productID : Int , count : Int,completionHandler:@escaping (Bool) -> Void) throws
    func updatePrice(completion: @escaping (Double?)-> Void)throws
    func postDraftOrder(lineItems: LineItemDraftTest, customerID: Int , completion: @escaping (Bool)->Void)
    func editCustomer(customer: EditCustomer, customerID: Int, completion: @escaping (Bool)->())
    func editDraftOrder(draftOrder: PutOrderRequestTest, draftID: Int, completion: @escaping (Bool)->())
    func getItemsDraftOrder(idDraftOrde: Int)
    var itemDraftOrderObservable: Observable<DraftOrderTest>{get set}
    var lineItem : Array<LineItem>{get set}
    //var totalPrice: Double{get set}



}


final class ProductDetailsViewModel: ProductDetailsViewModelType{
  //  var totalPrice=0.0
    
    var favoriteProducts: [FavouriteProduct]?
    var productsInCart: [CartProduct]?
    var isFav : Bool?
    var isProductInCart: Bool?
    private var listOfProduct : [Product] = []
    var network = APIClient()
    var localDataSource :LocalDataSource
    let userDefult = Utilities()
    var lineItem = Array<LineItem>()
    


    var productObservable: Observable<Product>
    var allProductsObservable :Observable<[Product]>
    var brandsObservable: Observable<[Product]>
    var itemDraftOrderObservable: Observable<DraftOrderTest>
    private var productSubject: PublishSubject = PublishSubject<Product>()
    private var allProductsSubject : PublishSubject = PublishSubject<[Product]>()
    private var brandsSubject : PublishSubject = PublishSubject<[Product]>()
    private var itemDraftOrderSubject: PublishSubject = PublishSubject<DraftOrderTest>()

    init(appDelegate :AppDelegate){
        localDataSource = LocalDataSource(appDelegate: appDelegate)
        productObservable = productSubject.asObserver()
        allProductsObservable = allProductsSubject.asObserver()
        brandsObservable=brandsSubject.asObservable()
        itemDraftOrderObservable=itemDraftOrderSubject.asObserver()
    }
    var bindImageURLToView: (() -> ()) = {}
    var bindDraftViewModelErrorToView: (() -> ()) = {}
    var imageURL: String? {
        didSet {
            self.bindImageURLToView()
        }
    }
    var showError: String? {
        didSet {
            self.bindDraftViewModelErrorToView()
        }
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
    
    func getProductOfBrand(id: String) {
        network.productOfBrandsProvider(id: id, completion:
                                            {[weak self] result in
            switch result {
            case .success(let response):
                guard let product = response.products else {return}
                self?.listOfProduct = product   
                self?.allProductsSubject.asObserver().onNext(product)
                print(product.count)
            case .failure(let error):
                self?.allProductsSubject.asObserver().onError(error)
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
            return Product.title.lowercased().trimmingCharacters(in: .whitespacesAndNewlines).contains(word.lowercased().trimmingCharacters(in: .whitespacesAndNewlines))
        }
        allProductsSubject.onNext(filterProducts)
        
    }
 
    func filterbyPrice(order:String) {
        if order == "high"{
            let filteredProducts = listOfProduct.sorted(by: {
                Double($0.variant[0].price!)! > Double($1.variant[0].price!)!})
            allProductsSubject.onNext(listOfProduct)
            allProductsSubject.onNext(filteredProducts)
        }else{
            let filteredProducts = listOfProduct.sorted(by: {
                Double($0.variant[0].price!)! < Double($1.variant[0].price!)!})
            allProductsSubject.onNext(listOfProduct)
            allProductsSubject.onNext(filteredProducts)
        }
    }
    
    func addFavouriteProductToCoreData(product:FavouriteProduct , completion: @escaping (Bool)->Void) throws{
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
    
    func checkProductInCart(id: String) {
        do{
            try isProductInCart = localDataSource.checkCartCoreData(itemId: id)
            //isProductInCart = true
        }catch {
            isProductInCart = false
        }
    }
    
    func addProductToCoreDataCart(id: String,title:String,image:String,price:String, itemCount: Int, quantity:Int, completion: @escaping (Bool) -> Void) throws {
        do{
            try localDataSource.saveProductToCartCoreData(id: id, title: title, image: image, price: price, itemCount: 1, quantity: quantity)
            completion(true)
            
        }catch let error {
            completion(false)
            throw error
        }
    }
    func addProductToCart(product:CartProduct , completion: @escaping (Bool)->Void) throws{
        do{
            try  localDataSource.saveInCart(newProduct: product)
            completion(true)
        }
        catch let error{
            completion(false)
            throw error
        }
    }
    
    func getAllProductsInCart(completion: @escaping (Bool) -> Void) throws {
        do{
            try  productsInCart =  localDataSource.getCartFromCoreData()
            completion(true)
        }catch let error{
            completion(false)
            throw error
        }
    }
    func removeProductFromCart(productID: String, completionHandler: @escaping (Bool) -> Void) throws {
        do{
            try localDataSource.removeFromCartCoreData(itemId: productID)
            completionHandler(true)
        }catch let error{
            completionHandler(false)
            throw error
        }
        
    }
    func updateCount(productID: Int, count: Int, completionHandler: @escaping (Bool) -> Void) throws {
        do{
            try localDataSource.updateCount(productID: Int(productID), count: count)
            completionHandler(true)
        }catch let error{
            completionHandler(false)
            throw error
        }
    }
    func updatePrice(completion: @escaping (Double?)-> Void)throws{
            var totalPrice: Double = 0.0
            do{
                try  productsInCart =  localDataSource.getCartFromCoreData()
                for item in productsInCart!{
                    guard let priceStr = item.price, let price = Double(priceStr) else {return}
                    totalPrice += Double(item.count)*price
                }
                Utilities.utilities.setTotalPrice(totalPrice: totalPrice)
                completion(totalPrice)
            }catch let error{
                completion(nil)
                throw error
            }
        }
//    func setTotalPriceFromApi(completion: @escaping (Double?)-> Void){
//        network.getItemsDraftOrder(idDraftOrde: Utilities.utilities.getDraftOrder()) {  result in
//            switch result {
//            case .success(let response):
//                 let items = response.draftOrder
//                print("lineItemPriceee\(self.lineItem)")
//                for item in self.lineItem {
//                    let price = Double(item.price)
//                    self.totalPrice += Double(item.quantity)*price!
//                }
//                self.itemDraftOrderSubject.asObserver().onNext(items)
//                Utilities.utilities.setTotalPrice(totalPrice: self.totalPrice)
//                completion(self.totalPrice)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//
//    }
    func postDraftOrder(lineItems: LineItemDraftTest, customerID: Int , completion: @escaping (Bool)->Void){
        var lineItem = Array<LineItemDraftTest>()
        lineItem.append(lineItems)
        if customerID != 0 {
            let order = DraftOrderItemTest(lineItems: lineItem, customer: CustomerIdTest(id: customerID), useCustomerDefaultAddress: true)
            let newOrder = DraftOrdersRequest(draftOrder: order)
            postOrder(draftOrder: newOrder)
            completion(true)
        }else{
            completion(false)
        }
    }
    func postOrder( draftOrder: DraftOrdersRequest) {
        network.postDraftOrder(draftOrder: draftOrder ) { data, response, error in
            if error != nil {
                print(error!)
            }else{
                if let data = data{
                    do{
                        let json = try! JSONSerialization.jsonObject(with: data, options:
                                .allowFragments) as! Dictionary<String, Any>
                        let draftOrder = json["draft_order"] as? Dictionary <String,Any>
                        let draftId = draftOrder?["id"] as? Int ?? 0
                        if draftId != 0{
                            self.userDefult.setDraftOrder(id: draftId)
                            print("add to user defualt ")
                        }
                        else{
                            print("can't save to user defualts")
                        }
                        
                    }
              
                }
            }}

    }
    func editCustomer(customer: EditCustomer, customerID: Int, completion: @escaping (Bool)->()) {
        network.editeCustomer(id: customerID, editeCustomer: customer, completion: { (data, response, error) in
            if error != nil {
                print ("can't edit customer")
                return
            }
            else{
                if let data = data{
                    print(data)
                    do{
                    let json = try? JSONSerialization.jsonObject(with: data, options:
                            .allowFragments) as? Dictionary<String, Any>
                        if json?["errors"] != nil{
                            completion(true)
                            
                        }else{
                            completion(false)
                        }
                    }
                }
            }
        })}
    func editDraftOrder(draftOrder: PutOrderRequestTest, draftID: Int, completion: @escaping (Bool)->()){
        network.modifyDraftOrder(draftOrderId: draftID, putOrder: draftOrder) { (data, response, error) in
            if error != nil {
                print ("can't edit draft order")
                return
            }
            else{
                if let data = data{
                    print(data)
                    do{
                    let json = try? JSONSerialization.jsonObject(with: data, options:
                            .allowFragments) as? Dictionary<String, Any>
                        if json?["errors"] != nil{
                            completion(false)
                            
                        }else{
                            completion(true)
                        }
                    }
                }
            }
        }
    }
    func getItemsDraftOrder(idDraftOrde: Int) {
        network.getItemsDraftOrder(idDraftOrde: idDraftOrde) { result in
            switch result {
            case .success(let response):
                 let items = response.draftOrder
                for item in items.lineItems {
                    self.lineItem.append(item)
                }
                self.itemDraftOrderSubject.asObserver().onNext(items)
            case .failure(let error):
                print(error.localizedDescription)
            }
          }
        }




}
