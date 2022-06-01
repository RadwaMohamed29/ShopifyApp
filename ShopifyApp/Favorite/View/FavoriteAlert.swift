//
//  FavoriteAlert.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 01/06/2022.
//

import Foundation
import UIKit
import SwiftMessages

protocol SharedFavouriteProtocol{
    func presentAlert(alert:UIAlertController)->Void
}
class FavoriteShared{
    static var sharedProtocol : SharedFavouriteProtocol?
    
    static func removeProductFromFavoriteList(recognizer: UIButton,delegate: AppDelegate,listOfProducts:FavoriteProducts,sharedProtocol:SharedFavouriteProtocol){
        self.sharedProtocol = sharedProtocol
        let viewModel = ProductDetailsViewModel(appDelegate: delegate)
        var alertMessage = ""
        var alertTitle = ""
        viewModel.checkFavorite(id: "\(listOfProducts.id)")
        
       
           
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
    
   static func showConformDialog(title:String,alertMessage:String,index:Int,favBtn :UIButton,isFav:Bool,viewModel: ProductDetailsViewModel,listOfProducts: FavoriteProducts){
      let favouriteAlert = UIAlertController(title: title, message: alertMessage, preferredStyle: .alert)
      let confirmAction = UIAlertAction(title: "Yes", style: .default) { (action) -> Void in
          self.actionForConfirmationOfFavoriteButton(index: index,favBtn: favBtn,isFav: isFav,viewModel: viewModel, listOfProducts: listOfProducts)
  }
        let cancleAction = UIAlertAction(title: "No", style: .default, handler: nil)
        
        favouriteAlert.addAction(confirmAction)
        favouriteAlert.addAction(cancleAction)
       
       sharedProtocol!.presentAlert(alert: favouriteAlert)
        
    }
    
   static func actionForConfirmationOfFavoriteButton(index:Int,favBtn: UIButton,isFav:Bool,viewModel: ProductDetailsViewModel,listOfProducts: FavoriteProducts){
    
       else if isFav == true{
            do{
                try viewModel.removeProductFromFavorites(productID: "\(listOfProducts.id)", completionHandler: { response in
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
