//
//  Shared.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 28/05/2022.
//

import Foundation
import UIKit
protocol SharedProtocol{
    func presentAlert(alert:UIAlertController)->Void
}
class Shared{
    static var sharedProtocol : SharedProtocol?
    
    static func setOrRemoveProductToFavoriteList(recognizer: UIButton,delegate: AppDelegate,listOfProducts:[Product],sharedProtocol:SharedProtocol){
        self.sharedProtocol = sharedProtocol
        let viewModel = ProductDetailsViewModel(appDelegate: delegate)
        var alertMessage = ""
        var alertTitle = ""
        viewModel.checkFavorite(id: "\(listOfProducts[recognizer.tag].id)")
        
       
           
        if viewModel.isFav == false {
                alertMessage = "Are you sure to add this product to your favourite list."
               alertTitle = "Add favorite product"
            showConformDialog(title: alertTitle,alertMessage: alertMessage, index: recognizer.tag,favBtn: recognizer,isFav: false,viewModel: viewModel,listOfProducts:listOfProducts)
                
            }else{
                alertMessage = "Are you sure to remove this product from your favourite list."
                alertTitle = "Remove favorite product"
                showConformDialog(title: alertTitle,alertMessage: alertMessage, index: recognizer.tag,favBtn: recognizer,isFav: true,viewModel: viewModel,listOfProducts:listOfProducts)
            }
    }
    
   static func showConformDialog(title:String,alertMessage:String,index:Int,favBtn :UIButton,isFav:Bool,viewModel: ProductDetailsViewModel,listOfProducts: [Product]){
      let favouriteAlert = UIAlertController(title: title, message: alertMessage, preferredStyle: .alert)
      let confirmAction = UIAlertAction(title: "Yes", style: .default) { (action) -> Void in
          self.actionForConfirmationOfFavoriteButton(index: index,favBtn: favBtn,isFav: isFav,viewModel: viewModel, listOfProducts: listOfProducts)
  }
        let cancleAction = UIAlertAction(title: "No", style: .default, handler: nil)
        
        favouriteAlert.addAction(confirmAction)
        favouriteAlert.addAction(cancleAction)
       
       sharedProtocol!.presentAlert(alert: favouriteAlert)
        
    }
    
   static func actionForConfirmationOfFavoriteButton(index:Int,favBtn: UIButton,isFav:Bool,viewModel: ProductDetailsViewModel,listOfProducts: [Product]){
        if isFav == false{
            do{
                try viewModel.addFavouriteProductToCoreData(product: listOfProducts[index], completion: { response in
                    switch response{
                    case true:
                        print("add seuccessfully")
                        favBtn.setImage(UIImage(systemName: "heart.fill"), for : UIControl.State.normal)
                    case false:
                        print("faild to add")
                        favBtn.setImage(UIImage(systemName: "heart"), for : UIControl.State.normal)
                    }
                    
                })
            }catch let error{
                print(error.localizedDescription)
            }
        }
       else if isFav == true{
            do{
                try viewModel.removeProductFromFavorites(productID: "\(listOfProducts[index].id)", completionHandler: { response in
                    switch response{
                    case true:
                        print("removed seuccessfully")
                        favBtn.setImage(UIImage(systemName: "heart"), for : UIControl.State.normal)
                    case false:
                        print("faild to remove")
                        favBtn.setImage(UIImage(systemName: "heart.fill"), for : UIControl.State.normal)
                    }
                })
            }catch let error{
                print(error.localizedDescription)
            }
        }
      
    }
    
}
