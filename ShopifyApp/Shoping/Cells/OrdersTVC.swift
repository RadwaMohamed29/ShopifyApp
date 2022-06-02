//
//  OrdersTVC.swift
//  Shopify
//
//  Created by Menn on 24/05/2022.
//

import UIKit

class OrdersTVC : UITableViewCell {
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var productTitle: UILabel!
    
    @IBOutlet weak var productPrice: UILabel!
    
    @IBOutlet weak var productCount: UILabel!
    
    @IBOutlet weak var subBtn: UIButton!
  

    var countNumber=1

    var ItemCart : [CartProduct] = []{
        didSet{
            self.productCount.text = "\(ItemCart.count)"
            self.countNumber = Int(ItemCart[0].count)
        }
    }
//    var bagProduct : CartProduct? {
//
//    }
    static let identifier = "ordersTVC"
    static func nib() ->UINib{
        UINib(nibName: "OrdersTVC", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    var deleteFromBagProducts:()->() = {}
    var addItemQuantity : (Int)->() = {_ in }
    var subItemQuantity : (Int)->() = {_ in }
    @IBAction func deleteCart(_ sender: Any) {
        deleteFromBagProducts()
    }
    @IBAction func subCount(_ sender: Any) {
        if countNumber > 1 {
            subBtn.isEnabled = true
            countNumber-=1
            self.productCount.text = "\(countNumber)"
            self.subItemQuantity(countNumber)

        }
        else{
            subBtn.isEnabled = false
        }

    }
    @IBAction func addCount(_ sender: Any) {
        subBtn.isEnabled = true
        countNumber+=1
        self.productCount.text = "\(countNumber)"
        self.addItemQuantity(countNumber)
        
  }
}
