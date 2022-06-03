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
    static let identifier = "ordersTVC"
    static func nib() ->UINib{
        UINib(nibName: "OrdersTVC", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    var deleteFromBagProducts:()->() = {}
    var addCount:()->() = {}
    var subCount:()->() = {}
    @IBAction func deleteCart(_ sender: Any) {
        deleteFromBagProducts()
    }
    @IBAction func subCount(_ sender: Any) {
        subCount()
    }
    @IBAction func addCount(_ sender: Any) {
        addCount()

  }
}
