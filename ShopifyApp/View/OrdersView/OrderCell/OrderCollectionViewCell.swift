//
//  OrderCollectionViewCell.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 04/06/2022.
//

import UIKit

class OrderCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var countOfItems: UILabel!
    @IBOutlet weak var price: UILabel!
    @IBOutlet weak var date: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
