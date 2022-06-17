//
//  Shared.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 28/05/2022.
//

import Foundation
import UIKit
import SwiftMessages
import NVActivityIndicatorView


protocol SharedProtocol{
    func presentAlert(alert:UIAlertController)->Void
}
class Shared{
    static var sharedProtocol : SharedProtocol?
    
    static func setOrRemoveProductToFavoriteList(recognizer: UIButton,delegate: AppDelegate,product:FavouriteProduct,sharedProtocol:SharedProtocol){
        self.sharedProtocol = sharedProtocol
        let viewModel = ProductDetailsViewModel(appDelegate: delegate)
        var alertMessage = ""
        var alertTitle = ""
        viewModel.checkFavorite(id: product.id ?? "0")
        
                alertMessage = "Are you sure to remove this product from your favourite list."
                alertTitle = "Remove favorite product"
                showConformDialog(title: alertTitle,alertMessage: alertMessage, index: recognizer.tag,favBtn: recognizer,isFav: true,viewModel: viewModel,product: product)
    }
    
   static func showConformDialog(title:String,alertMessage:String,index:Int,favBtn :UIButton,isFav:Bool,viewModel: ProductDetailsViewModel,product: FavouriteProduct){
      let favouriteAlert = UIAlertController(title: title, message: alertMessage, preferredStyle: .alert)
      let confirmAction = UIAlertAction(title: "Yes", style: .default) { (action) -> Void in
          self.actionForConfirmationOfFavoriteButton(index: index,favBtn: favBtn,isFav: isFav,viewModel: viewModel, product: product)
  }
        let cancleAction = UIAlertAction(title: "No", style: .default, handler: nil)
        
        favouriteAlert.addAction(confirmAction)
        favouriteAlert.addAction(cancleAction)
       
       sharedProtocol!.presentAlert(alert: favouriteAlert)
        
    }
    
   static func actionForConfirmationOfFavoriteButton(index:Int,favBtn: UIButton,isFav:Bool,viewModel: ProductDetailsViewModel,product: FavouriteProduct){
        if isFav == false{
            do{
                try viewModel.addFavouriteProductToCoreData(product: product, completion: { response in
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
                try viewModel.removeProductFromFavorites(productID: product.id ?? "", completionHandler: { response in
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

extension Shared{
    static func showMessage(message:String, error:Bool){
            
            let view = MessageView.viewFromNib(layout: .messageView)
            if error == true {
                view.configureTheme(.error)
            }else{
                view.configureTheme(.success)
            }
            view.button?.isHidden = true
            view.titleLabel?.isHidden = true
            view.bodyLabel?.text = message
            
            var config = SwiftMessages.Config()
            config.presentationStyle = .top
            SwiftMessages.show(config: config, view: view)
        }
 
}
extension UIViewController{
    func showActivityIndicator(indicator: NVActivityIndicatorView? ,startIndicator: Bool){
        guard let indicator = indicator else {return}
        DispatchQueue.main.async {
            indicator.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(indicator)
            
            NSLayoutConstraint.activate([
                indicator.widthAnchor.constraint(equalToConstant: 40),
                indicator.heightAnchor.constraint(equalToConstant: 40),
                indicator.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
                indicator.centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
            ])
        }
        if startIndicator{
            indicator.startAnimating()
        }else{
            indicator.stopAnimating()
        }
    }
    
    func setTxtFieldStyle(txt:[UITextField]) {
        for txtField in txt{
            txtField.layer.cornerRadius = 15.0
            txtField.layer.borderWidth = 0.5
        }
    }
}

extension Shared{
    static func formatePrice(priceStr:String?) -> String {
           let settingViewModel = SettingsViewModel()
           let currency  = settingViewModel.getCurrency(key: "currency")
           if  currency == "EGP" {
           return "\(toEGP(amount:Double(priceStr ?? "")! )) EGP"
           }
           else {
               return "\(priceStr!) USD"
               
           }
       }
     static  func toEGP(amount:Double) -> Double {
            
           return Double(round(100*(amount * 15.669931))/100)
       }
    
  
}
