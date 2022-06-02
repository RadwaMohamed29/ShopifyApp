//
//  WishListExtenyion.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 01/06/2022.
//

import Foundation
import UIKit
import Kingfisher

extension MeViewController : UICollectionViewDataSource ,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if favProducts.count > 2{
            return 2
        }
        return favProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteproductCell", for: indexPath) as! FavouriteCollectionViewCell
        setImage(image: cell.productImage, index: indexPath.row)
        cell.priceOfTheProduct.text = favProducts[indexPath.row].price
        cell.ProductName.text = favProducts[indexPath.row].title
        cell.favouriteBtn.tag = indexPath.row
          cell.favouriteBtn.addTarget(self, action: #selector(favPress(recognizer:)), for: .touchUpInside)
          return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 15, bottom: 15, right: 15)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width / 2.5
        
        let availableHieght = view.frame.width/2.3
        
        return CGSize(width: availableWidth, height: availableHieght)
    }
  
    
    func setImage(image: UIImageView,index : Int)  {
        let url = URL(string: favProducts[index].scr)
          let processor = DownsamplingImageProcessor(size: image.bounds.size)
                       |> RoundCornerImageProcessor(cornerRadius: 20)
          image.kf.indicatorType = .activity
        image.kf.setImage(
              with: url,
              options: [
                  .processor(processor),
                  .scaleFactor(UIScreen.main.scale),
                  .transition(.fade(1)),
                  .cacheOriginalImage
              ])
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = 20
    }

    func showConformDialog(title:String,alertMessage:String,index:Int,favBtn :UIButton,isFav:Bool){
        let favouriteAlert = UIAlertController(title: title, message: alertMessage, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { (action) -> Void in
            self.actionForConfirmationOfFavoriteButton(index: index,favBtn: favBtn,isFav: isFav)
        }
        let cancleAction = UIAlertAction(title: "No", style: .default, handler: nil)
        
        favouriteAlert.addAction(confirmAction)
        favouriteAlert.addAction(cancleAction)
        self.present(favouriteAlert, animated: true, completion: nil)
        
    }
    @objc private func favPress(recognizer: UIButton) {
        
        var alertMessage = ""
        var alertTitle = ""
        self.productViewModel?.checkFavorite(id: "\(self.favProducts[recognizer.tag].id)")
        alertMessage = "Are you sure to remove this product from your favourite list."
        alertTitle = "Remove favorite product"
        showConformDialog(title: alertTitle,alertMessage: alertMessage, index: recognizer.tag,favBtn: recognizer,isFav: true)
        
       
        
    }
    func actionForConfirmationOfFavoriteButton(index:Int,favBtn: UIButton,isFav:Bool){
        
        if isFav == true{
            do{
                try self.productViewModel?.removeProductFromFavorites(productID: "\(favProducts[index].id)", completionHandler: { response in
                    switch response{
                    case true:
                        print("removed seuccessfully")
                        self.getFavoriteProductsFromCoreData()
                        self.wishListCV.reloadData()
                        if self.favProducts.count == 0 {
                           // self.noDataView.isHidden = false
                        }
                        
                    case false:
                        print("Failed to remove")
                    }
                })
            }catch let error{
                print(error.localizedDescription)
            }
        }
        
    }

}
