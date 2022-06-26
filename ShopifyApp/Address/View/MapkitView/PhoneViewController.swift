//
//  PhoneViewController.swift
//  ShopifyApp
//
//  Created by Peter Samir on 26/06/2022.
//

import UIKit

class PhoneViewController: UIViewController {

    @IBOutlet weak var phonetxtField: UITextField!
    @IBOutlet weak var labelWrongPhone: UILabel!
    var address:AddressFromMap!
    var userDefault = Utilities()
    var viewModel: AddressViewModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddressViewModel(network: APIClient())
        // Do any additional setup after loading the view.
    }

    @IBAction func btnConfirmAddress(_ sender: Any) {
    }
    
    
    func postAddress() {
        
    self.viewModel.getAddDetailsAndPostToCustomer(customerID: String((self.userDefault.getCustomerId())), phone: "00214", streetName: address.streetName, city: address.city, country: address.country) { isSucceeded in
        HandelConnection.handelConnection.checkNetworkConnection { isConn in
            if isConn{
                if isSucceeded{
                    self.navigationController?.popViewController(animated: true)
                }else{
                    self.showLocationAlert(text: "something went wrong, may be address already added")
                }
            }else{
                self.showLocationAlert(text: "Please check your internet connection..")
            }
        }
    }
    }
}
