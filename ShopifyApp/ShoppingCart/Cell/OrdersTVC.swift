//
//  OrdersTVC.swift
//  Shopify
//
//  Created by Hassan on 14/03/2022.
//

import UIKit

class OrdersTVC : UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var subButton: UIButton!
    
    @IBOutlet weak var quantityLbl: UILabel!
    
   
    @IBOutlet weak var addToWishlist: UIButton!
    
    @IBOutlet weak var deleteProductBtn: UIButton!
    
    
    static let identifier = "ordersTVC"
    static func nib() ->UINib{
        UINib(nibName: "OrdersTVC", bundle: nil)
    }
    
    var addItemQuantity : (()->())?
    var subItemQuantity : (()->())?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func addQuantity(_ sender: Any) {
        addItemQuantity?()
    }
    
    @IBAction func subQuantity(_ sender: Any) {
        subItemQuantity?()
    }
}
