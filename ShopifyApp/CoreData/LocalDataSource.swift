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
    func removeProductFromCoreData(productID: Int) throws
    func getProductFromCoreData() throws -> [FavoriteProducts]
    func isFavouriteProduct(productID: Int) throws -> Bool
    
}

final class LocalDataSource: LocalDataSourcable{
    private var context: NSManagedObjectContext!
    private var entity: NSEntityDescription!
    
    init(appDelegate: AppDelegate){
        context = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "FavouriteProduct", in: context)
    }
    
    func saveProductToCoreData(newProduct: Product) throws {
        let product = NSManagedObject(entity: entity, insertInto: context)
        product.setValue(newProduct.id, forKey: "id")
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
    
    func removeProductFromCoreData(productID: Int) throws {
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
                favouriteProducts.append(FavoriteProducts(id: product.value(forKey: "id" )as! Int
                                                          , body_html: product.value(forKey: "body_html" )as! String
                                                          , price: product.value(forKey: "price" )as! String
                                                          , scr: product.value(forKey: "scr") as! String
                                                          , title: product.value(forKey: "title") as!String
                                                         ))
            }
            
            
            
            return favouriteProducts
        }catch let error as NSError{
            throw error
        }
    }
    
    func isFavouriteProduct(productID: Int) throws -> Bool {
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
    
    
}
