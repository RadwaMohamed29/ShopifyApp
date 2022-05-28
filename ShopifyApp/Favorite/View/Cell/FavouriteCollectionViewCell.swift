//
//  FavouriteCollectionViewCell.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 22/05/2022.
//

import UIKit

class FavouriteCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var rateOfTheProduct: UILabel!
    @IBOutlet weak var priceOfTheProduct: UILabel!
    @IBOutlet weak var ProductName: UILabel!

    @IBOutlet weak var favouriteBtn: UIButton!
    @IBOutlet weak var productImage: UIImageView!
    @IBOutlet weak var bottomView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
