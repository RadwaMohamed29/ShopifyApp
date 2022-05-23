//
//  BrandsCollectionViewCell.swift
//  ShopifyApp
//
//  Created by Menna on 23/05/2022.
//

import UIKit

class BrandsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var brandImageView: UIImageView!
    @IBOutlet weak var viewBrandImage: UIView!
    @IBOutlet weak var brandLabel: UILabel!
    static let identifier = "BrandsCollectionViewCell"
    static func Nib()-> UINib{
        return UINib(nibName: "BrandsCollectionViewCell", bundle: nil)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
