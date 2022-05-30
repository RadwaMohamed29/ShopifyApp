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
    var availableStoredCount = 0
    var selectedSize = ""
    static let identifier = "ordersTVC"
    static func nib() ->UINib{
        UINib(nibName: "OrdersTVC", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    var deleteFromBagProducts:()->() = {}
    var updateSavedCount:(Int , Bool,String)->() = {_,_,_ in}
    @IBAction func subCount(_ sender: Any) {
        if countNumber == 0 {
            deleteFromBagProducts()
        }
        else{
            countNumber-=1
            self.productCount.text = "\(countNumber)"
            
            self.updateSavedCount(countNumber ,true,selectedSize)
        }
    }
    @IBAction func addCount(_ sender: Any) {
        
        if countNumber+1 <= availableStoredCount {
            countNumber+=1
            self.productCount.text = "\(countNumber)"
            self.updateSavedCount(countNumber,true,selectedSize)
        }else{
            self.updateSavedCount(countNumber,false,selectedSize)
        }
    }
    //    @IBAction func addQuantity(_ sender: Any) {
//        addItemQuantity?()
//    }
//
//    @IBAction func subQuantity(_ sender: Any) {
//        subItemQuantity?()
//    }
}
