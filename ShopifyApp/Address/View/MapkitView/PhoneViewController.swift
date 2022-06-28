//
//  PhoneViewController.swift
//  ShopifyApp
//
//  Created by Peter Samir on 26/06/2022.
//

import UIKit

class PhoneViewController: UIViewController {

    var phoneDelegate:PhoneDelegate!
    @IBOutlet weak var phonetxtField: UITextField!
    @IBOutlet weak var labelWrongPhone: UILabel!
    var userDefault = Utilities()
    var viewModel: AddressViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddressViewModel(network: APIClient())
        setTxtFieldStyle(txt: [phonetxtField])
    }

    @IBAction func btnConfirmAddress(_ sender: Any) {
        if phonetxtField.text!.count != 11 || phonetxtField.text!.prefix(2) != "01"{
            labelWrongPhone.isHidden = false
        }else{
            phoneDelegate.getPhone(phone: phonetxtField.text!)
            self.presentingViewController?.dismiss(animated: true)
        }
    }
    
    
    
}
