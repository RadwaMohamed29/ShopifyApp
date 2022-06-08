//
//  SettingsVC.swift
//  ShopifyApp
//
//  Created by Menna on 05/06/2022.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var currencySegmant: UISegmentedControl!
    @IBOutlet weak var currentAdd: UILabel!
    @IBOutlet weak var currencyChange: UISegmentedControl!
    @IBOutlet weak var logut: UIButton!
    var settingViewModeel = SettingsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    @IBAction func websiteBtn(_ sender: Any) {
    }
    
    @IBAction func faceBookBtn(_ sender: Any) {
    }
    @IBAction func aboutBtn(_ sender: Any) {
        
    }
    @IBAction func addressBtn(_ sender: Any) {
        let addressVC = AddressViewController(nibName: "AddressViewController", bundle: nil)
        self.navigationController?.pushViewController(addressVC, animated: true)
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
        Utilities.utilities.logout()
        self.navigationController?.popViewController(animated: true)
    }

    @IBAction func currencyBtn(_ sender: Any) {
        switch currencySegmant.selectedSegmentIndex {
        case 0:
            self.settingViewModeel.seCurrency(key: "currency", value: "USD")
        case 1:
            self.settingViewModeel.seCurrency(key: "currency", value: "EGP")
        default:
            break
        }
        print(currencySegmant.titleForSegment(at:currencySegmant.selectedSegmentIndex )!)
        
    }
}
