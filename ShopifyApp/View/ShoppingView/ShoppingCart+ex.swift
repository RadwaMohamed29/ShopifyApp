//
//  ShoppingCart+apiEx.swift
//  ShopifyApp
//
//  Created by Menna on 26/06/2022.
//
import RxSwift
import Foundation
import Kingfisher
extension ShoppingCartVC :UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flag == true{
            return itemList.count
        }
        else {
            return CartProducts.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: OrdersTVC.identifier, for: indexPath) as! OrdersTVC
        cell.setAlert(shopping: self)
        cell.deleteFromBagProducts = {
            self.showDeleteAlert(indexPath: indexPath)
        }
        if flag == true{
            let item = self.itemList[indexPath.row]
            cell.updateUI(item: item)
            var count = self.itemList[indexPath.row].quantity
            let id = self.itemList[indexPath.row].productID
            if !quantityOfProducts.isEmpty{
                let quantity = quantityOfProducts[indexPath.row].variant[0].inventoryQuantity
                  cell.addCount={ [self] in
                   if Int(count) == Int(quantity) {
                        alertWarning(indexPath: indexPath, title: "warning", message: "quantity not avalible")
                    }
                    else{
                     count+=1
                     cell.productCount.text = "\(count)"
                     self.itemList[indexPath.row].quantity = count
                     self.totalPrice += Double(itemList[indexPath.row].price)!
                     self.totalLable.text = Shared.formatePrice(priceStr: String(self.totalPrice))
                     self.updateCount(productID: id, count: count)
                    }
                  }
                     cell.subCount={
                     if (count != 1)
                         {
                         cell.subBtn.isEnabled = true
                         count-=1
                         cell.productCount.text = "\(count)"
                         self.itemList[indexPath.row].quantity = count
                         self.totalPrice -= Double(self.itemList[indexPath.row].price)!
                         self.totalLable.text = Shared.formatePrice(priceStr: String(self.totalPrice))
                         self.updateCount(productID: id, count: count)
                         }
                         else{
                            self.alertWarning(indexPath: indexPath, title: "warning", message: "can't decrease count of item to zero")
                            }
                    
                }
            }
            
        }
              else {
                    let url = URL(string: CartProducts[indexPath.row].image!)
                    let processor = DownsamplingImageProcessor(size: cell.productImage.bounds.size)
                    cell.productTitle.text=CartProducts[indexPath.row].title
                    cell.productImage.kf.indicatorType = .activity
                    cell.productImage.kf.setImage(
                    with: url,
                    placeholder: UIImage(named: "placeholder"),
                    options: [
                        .processor(processor),
                        .scaleFactor(UIScreen.main.scale),
                        .transition(.fade(1)),
                        .cacheOriginalImage
                            ])
                    cell.productCount.text = " \(CartProducts[indexPath.row].count)"
                    cell.productPrice.text = Shared.formatePrice(priceStr: CartProducts[indexPath.row].price!)
                    cell.deleteFromBagProducts = {[weak self] in
                        self?.alertWarning(indexPath: indexPath,  title: "information", message: "check your internet connection")
                    }
            cell.addCount={
                self.alertWarning(indexPath: indexPath,  title: "information", message: "check your internet connection")

            }
            cell.subCount={
                self.alertWarning(indexPath: indexPath,  title: "information", message: "check your internet connection")

            }
        }
        
        return cell
            
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let detalisVC = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
        if flag == true{
            detalisVC.productId = String(itemList[indexPath.row].productID)
        }
        else {
            detalisVC.productId = CartProducts[indexPath.row].id
        }
        
        self.navigationController?.pushViewController(detalisVC, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        HandelConnection.handelConnection.checkNetworkConnection { result in
            if result{
                if editingStyle == .delete {
                    self.showDeleteAlert(indexPath: indexPath)
                }
                 
            }
            else{
                    self.alertWarning(indexPath: indexPath, title: "information", message: "check your internet connection")
                }
        }
  
    }
    

}
