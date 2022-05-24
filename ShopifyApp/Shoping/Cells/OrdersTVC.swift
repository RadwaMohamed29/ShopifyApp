//
//  OrdersTVC.swift
//  Shopify
//
//  Created by Menn on 24/05/2022.
//

import UIKit

class OrdersTVC : UITableViewCell {

    
    static let identifier = "ordersTVC"
    static func nib() ->UINib{
        UINib(nibName: "OrdersTVC", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
//    @IBAction func addQuantity(_ sender: Any) {
//        addItemQuantity?()
//    }
//
//    @IBAction func subQuantity(_ sender: Any) {
//        subItemQuantity?()
//    }
}
