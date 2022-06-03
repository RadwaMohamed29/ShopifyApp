//
//  ReviewsCollectionViewCell.swift
//  ShopifyApp
//
//  Created by Radwa on 02/06/2022.
//

import UIKit

class ReviewsCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var customerReview: UILabel!
    @IBOutlet weak var customerName: UILabel!
    @IBOutlet weak var customerImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
//        customerImage.layer.borderWidth = 1
//        customerImage.layer.masksToBounds = false
//        customerImage.layer.borderColor = UIColor.black.cgColor
//        customerImage.layer.cornerRadius = customerImage.frame.height/2
//        customerImage.clipsToBounds = true
        
    }

}
