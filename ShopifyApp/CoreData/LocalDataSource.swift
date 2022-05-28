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
extension LocalDataSource{
    
    func getCartFromCoreData() throws -> [CartModel] {
        var selectedCart = [CartModel]()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "entityCart")
        do{
            let cartList = try contextCart.fetch(fetchRequest)
            for product in cartList {
                selectedCart.append(CartModel(id: product.value(forKey: "id")as? String
                                    ,title: product.value(forKey: "title")as? String
                                    ,price: product.value(forKey: "price")as? String
                                    ,image: product.value(forKey: "image")as? String
                                    ,quantity: product.value(forKey: "quantity")as? Int
                                     ,sizes: product.value(forKey: "sizes")as? [String]
                ))
            }
            return selectedCart
        }catch let error as NSError{
            throw error
        }
    }
    
    
    func saveProductToCartCoreData(newItem: Product, itemCount: Int = 1)throws{
        let product = NSManagedObject(entity: entityCart, insertInto: contextCart)
        product.setValue(newItem.id, forKey: "id")
        product.setValue(newItem.title, forKey: "title")
        product.setValue(newItem.image.src, forKey: "image")
        product.setValue(newItem.variant[0].price, forKey: "price")
        product.setValue(newItem.variant[0].inventoryQuantity, forKey: "quantity")
        product.setValue(newItem.options[0].values, forKey: "size")
    //    let data = NSKeyedArchiver.archivedData(withRootObject: product.options[0].values)
        do{
            try contextCart.save()

        }catch let error as NSError{
            throw error
        }


    }
    func removeFromCartCoreData(itemId: Int)throws{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "entityCart")
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
    func checkCartCoreData(itemId: Int) throws -> Bool{
        do{
            let products = try self.getProductFromCoreData()
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
}
