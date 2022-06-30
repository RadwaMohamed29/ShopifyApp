//
//  SizeTableViewCell.swift
//  ShopifyApp
//
//  Created by Radwa on 23/05/2022.
//

import UIKit

class SizeTableViewCell: UITableViewCell {

    @IBOutlet weak var sixe: UILabel!
    var index: Int?
    var product: Product!{
        didSet{
            self.sixe.text = product.options[index!].name
            
            
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
