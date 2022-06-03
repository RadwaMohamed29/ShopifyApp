//
//  LocalDataSource.swift
//  ShopifyApp
//
//  Created by Radwa on 27/05/2022.
//

import Foundation
import CoreData

protocol LocalDataSourcable{
    func saveProductToCoreData(newProduct: Product) throws
    func removeProductFromCoreData(productID: String) throws
    func getProductFromCoreData() throws -> [FavoriteProducts]
    func isFavouriteProduct(productID: String) throws -> Bool
    
}

final class LocalDataSource: LocalDataSourcable{
   
    private var context: NSManagedObjectContext!
    private var contextCart: NSManagedObjectContext!
    private var entity: NSEntityDescription!
    private var entityCart: NSEntityDescription!
    init(appDelegate: AppDelegate){
        context = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "FavouriteProduct", in: context)
        contextCart = appDelegate.persistentContainer.viewContext
        entityCart = NSEntityDescription.entity(forEntityName: "CartProduct", in: context)
        
    }
    
    func saveProductToCoreData(newProduct: Product) throws {
        let product = NSManagedObject(entity: entity, insertInto: context)
        product.setValue("\(newProduct.id)", forKey: "id")
        product.setValue(newProduct.bodyHTML, forKey: "body_html")
        product.setValue(newProduct.image.src, forKey: "scr")
        product.setValue(newProduct.title, forKey: "title")
        product.setValue(newProduct.variant[0].price, forKey: "price")
        
        do{
            try context.save()
            
        }catch let error as NSError{
            throw error
        }
        
    }
    
    func removeProductFromCoreData(productID: String) throws {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteProduct")
        let myPredicate = NSPredicate(format: "id == %@", productID)
        fetchRequest.predicate = myPredicate
        do{
            let productList = try context.fetch(fetchRequest)
            for product in productList{
                context.delete(product)
            }
            try self.context.save()
        }catch let error as NSError{
            throw error
        }
    }
    
    
    func getProductFromCoreData() throws -> [FavoriteProducts] {
        var favouriteProducts = [FavoriteProducts]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteProduct")
        do{
            let productList = try context.fetch(fetchRequest)
            for product in productList {
                favouriteProducts.append(FavoriteProducts(id: product.value(forKey: "id" )as! String
                                                          , body_html: product.value(forKey: "body_html" )as! String
                                                          , price: product.value(forKey: "price" )as! String
                                                          , scr: product.value(forKey: "scr") as! String
                                                          , title: product.value(forKey: "title") as!String, isSelected: false
                                                         ))
            }
            
            
            
            return favouriteProducts
        }catch let error as NSError{
            throw error
        }
    }
    
    func isFavouriteProduct(productID: String) throws -> Bool {
        do{
            let products = try self.getProductFromCoreData()
            for item in products{
                if item.id == productID {
                    return true
                }
            }
        }catch let error{
            throw error
        }
        return false
    }
    func getCountOfProductInFav() ->Int {
        var count: Int = 0
        do{
           let productsInCart = try self.getProductFromCoreData()
         
                count = productsInCart.count
  
        }catch let error{
            print(error.localizedDescription)
        }
        
        return count
        
    }
    
}
extension LocalDataSource{

    func getCartFromCoreData() throws -> [CartProduct] {
        var selectedCart = [CartProduct]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CartProduct")
        
        do{
            let cartList = try contextCart.fetch(CartProduct.fetchRequest())
            cartList.forEach { list in
                selectedCart.append(list)
            }
            return selectedCart
        }catch let error as NSError{
            throw error
        }
    }
    
    
    func saveProductToCartCoreData(id: String,title:String,image:String,price:String, itemCount: Int )throws{
        let product = NSManagedObject(entity: entityCart, insertInto: contextCart)
        product.setValue(id, forKey: "id")
        product.setValue(title, forKey: "title")
        product.setValue(image, forKey: "image")
        product.setValue(price, forKey: "price")
        product.setValue(Int64(itemCount), forKey: "count")
        do{
            try contextCart.save()

        }catch let error as NSError{
            throw error
        }


    }
    func removeFromCartCoreData(itemId: String)throws{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CartProduct")
        let myPredicate = NSPredicate(format: "id == %@", itemId)
        fetchRequest.predicate = myPredicate
        do{
            let productList = try contextCart.fetch(fetchRequest)
            for product in productList{
                contextCart.delete(product)
            }
            try self.contextCart.save()
        }catch let error as NSError{
            throw error
        }
    }
    func checkCartCoreData(itemId: String) throws -> Bool{
        do{
            let products = try self.getCartFromCoreData()
            for item in products{
                if item.id == itemId {
                    return true
                }
            }
        }catch let error{
            throw error
        }
        return false
    }
    func updateCount(productID :Int , count : Int) throws{
        do{
            let products = try self.getCartFromCoreData()
            for item in products{
                if item.value(forKey:"id") as! String == "\(productID)"{
                    item.count = Int64(count)
                }
                try self.contextCart.save()
                }
            }
        }
    func getCountOfProductInCart() ->Int {
        var count: Int = 0
        do{
           let productsInCart = try self.getCartFromCoreData()
            count += productsInCart.count
        }catch let error{
            print(error.localizedDescription)
        }
        return count
        
    }
    
}
