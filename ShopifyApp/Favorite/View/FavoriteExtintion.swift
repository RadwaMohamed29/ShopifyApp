//
//  FavoriteExtintion.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 01/06/2022.
//

import Foundation
import UIKit
import Kingfisher
extension FavouriteViewController :UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteproductCell", for: indexPath) as! FavouriteCollectionViewCell
        let url = URL(string: favProducts[indexPath.row].scr)
        let processor = DownsamplingImageProcessor(size: cell.productImage.bounds.size)
        |> RoundCornerImageProcessor(cornerRadius: 20)
        cell.productImage.kf.indicatorType = .activity
        cell.productImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        cell.ProductName.text = favProducts[indexPath.row].title
        cell.priceOfTheProduct.text = "$ \(favProducts[indexPath.row].price)"
        cell.productImage.layer.borderWidth = 0
        cell.productImage.layer.borderColor = UIColor.lightGray.cgColor
        cell.productImage.layer.cornerRadius = 20
        
        cell.favouriteBtn.tag = indexPath.row
        cell.favouriteBtn.addTarget(self, action: #selector(favPress(recognizer:)), for: .touchUpInside)
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
        if countOfSelectedItem > 0 {
            selectOrUnselectProduct(indexPath: indexPath)
        }else if countOfSelectedItem == 0 {
            detailsVC.productId = favProducts[indexPath.row].id
            self.navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width / 2.4
        let availableHieght = view.frame.width/1.7
        return CGSize(width: availableWidth, height: availableHieght)
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
                        self.favouriteCollectionView.reloadData()
                        if self.favProducts.count == 0 {
                            self.noDataView.isHidden = false
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
