//
//  AddressCellTableViewCell.swift
//  ShopifyApp
//
//  Created by Peter Samir on 04/06/2022.
//

import UIKit

class AddressCellTableViewCell: UITableViewCell {

    @IBOutlet weak var btnDelete: UIButton!
    @IBOutlet weak var labelAddress: UILabel!
    var deleteAddressByBottun:()->() = {}

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func deleteBtn(_ sender: Any) {
        deleteAddressByBottun()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
