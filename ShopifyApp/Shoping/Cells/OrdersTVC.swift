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
    
    var countNumber = 1
    static let identifier = "ordersTVC"
    static func nib() ->UINib{
        UINib(nibName: "OrdersTVC", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var deleteFromBagProducts:()->() = {}
    var updateSavedCount:(Int)->() = {_ in }
    var addItemQuantity : (Int)->() = {_ in }
    var subItemQuantity : (Int)->() = {_ in }
    @IBAction func subCount(_ sender: Any) {
        if countNumber != 0 {
            countNumber-=1
            self.productCount.text = "\(countNumber)"
            self.subItemQuantity(countNumber)
            
        }
        else{
            deleteFromBagProducts()
        }
    }
    @IBAction func addCount(_ sender: Any) {
        countNumber+=1
        self.productCount.text = "\(countNumber)"
        self.addItemQuantity(countNumber)
        
  }
}
