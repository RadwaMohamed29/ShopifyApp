//
//  AbsCollectionViewCell.swift
//  ShopifyApp
//
//  Created by Menna on 23/05/2022.
//

import UIKit

class AbsCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var adsImageView: UIImageView!
    static let identifier = "AbsCollectionViewCell"
    static func Nib()-> UINib{
        return UINib(nibName: "AbsCollectionViewCell", bundle: nil)
    }
   
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
