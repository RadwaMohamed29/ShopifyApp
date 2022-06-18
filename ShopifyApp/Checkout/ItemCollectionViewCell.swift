//
//  ItemCollectionViewCell.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 17/06/2022.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var price: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
