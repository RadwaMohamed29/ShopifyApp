//
//  ItemCollectionViewCell.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 17/06/2022.
//

import UIKit
import Kingfisher
class ItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var amount: UILabel!
    @IBOutlet weak var price: UILabel!
    var productVM : ProductDetailsViewModel?

    override func awakeFromNib() {
        super.awakeFromNib()
        productVM = ProductDetailsViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
        // Initialization code
    }
    
    func updateUI(item: LineItem) {
        let id = String(describing: item.productID)
        productVM!.getProductImage(id: id)
        productVM!.bindImageURLToView = { self.onSuccessUpdateView() }
    }
    func onSuccessUpdateView() {
      let itemsImages = productVM!.imageURL!
        DispatchQueue.main.async {
            let processor = DownsamplingImageProcessor(size: self.image.bounds.size)
            self.image.kf.indicatorType = .activity
            self.image.kf.setImage(
                with:URL(string: itemsImages),
                placeholder: UIImage(named: "placeholderImage"),
                options: [
                    .processor(processor),
                    .scaleFactor(UIScreen.main.scale),
                    .cacheOriginalImage
                ])

        }
    }

}
