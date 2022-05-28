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
    func getProductFromCoreData() throws -> [Product]
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
        product.setValue(newProduct.image.src, forKey: "images")
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
    
    
    func getProductFromCoreData() throws -> [Product] {
        var favouriteProducts = [Product]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavouriteProduct")
        do{
            let productList = try context.fetch(fetchRequest) as? [Product]
            productList?.forEach  { favouriteProduct in
//                let idProduct: Int = favouriteProduct.value(forKey: "id") as? Int ?? 0
//                let titleProduct: String = favouriteProduct.value(forKey: "title") as? String ?? ""
//                let descProduct: String = favouriteProduct.value(forKey: "body_html") as? String ?? ""
//                let imagesProduct: [Images] = favouriteProduct.value(forKey: "images") as? [Images] ?? []
//                let priceProduct: [Variant] = favouriteProduct.value(forKey: "price") as? [Variant] ?? []
//                let valuesProduct: [Options] = favouriteProduct.value(forKey: "values") as? [Options] ?? []
                favouriteProducts.append(favouriteProduct)
                
                
//                favouriteProducts.append(Product(id: idProduct, title: titleProduct, bodyHTML: descProduct , vendor: "" , productType: "", createdAt: "", handle: "", updatedAt: "", publishedAt: "", publishedScope: "", tags: "", adminGraphqlAPIID: "", options: valuesProduct, images: imagesProduct , variant:priceProduct , image: "{}" )
//                )
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
