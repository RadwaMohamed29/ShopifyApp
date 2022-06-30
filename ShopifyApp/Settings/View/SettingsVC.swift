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
    var settingViewModel : SettingsViewModelType = SettingsViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
        checkCurrencySegmantState()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    @IBAction func websiteBtn(_ sender: Any) {
        settingViewModel.openWebsite(url:"https://shopify.dev/api/admin-rest")
    }
    
    @IBAction func faceBookBtn(_ sender: Any) {
        settingViewModel.openWebsite(url: "https://www.facebook.com/shopify/")
    }
    @IBAction func aboutBtn(_ sender: Any) {
        let aboutVC = AboutViewController(nibName: "AboutViewController", bundle: nil)
        self.present(aboutVC, animated: true)
    }
    @IBAction func addressBtn(_ sender: Any) {
        let addressVC = AddressViewController(nibName: "AddressViewController", bundle: nil)
        addressVC.isComingWithOrder = false
        self.navigationController?.pushViewController(addressVC, animated: true)
    }
    
    @IBAction func logoutBtn(_ sender: Any) {
         //  Utilities.utilities.setDraftOrder(id: 0)
           Utilities.utilities.setUserNote(note: "0")
        Utilities.utilities.addCustomerId(id: 0)
        Utilities.utilities.logout()
        Utilities.utilities.addCustomerName(customerName: "")
        Utilities.utilities.setCurrency(Key: "currency", value: "")
      //  let key = Utilities.utilities.getCode()
       // Utilities.utilities.setCodeUsed(code: key,isUsed: false)
        self.navigationController?.popViewController(animated: true)
    }
    

    @IBAction func currencyBtn(_ sender: Any) {
        switch currencySegmant.selectedSegmentIndex {
        case 0:
            self.settingViewModel.setCurrency(key: "currency", value: "USD")
        case 1:
            self.settingViewModel.setCurrency(key: "currency", value: "EGP")
           
        default:
            break
        }
        print(currencySegmant.titleForSegment(at:currencySegmant.selectedSegmentIndex )!)
        
    }
    func checkCurrencySegmantState(){
        
        if settingViewModel.getCurrency(key: "currency") == "USD"{
            currencySegmant.selectedSegmentIndex = 0
        }else {
            currencySegmant.selectedSegmentIndex = 1
        }
        
    }
//    @objc func youtubeTapped(sender:UIButton){
//        let url = sender.accessibilityValue!
//        viewModel.openInYoutube(url: url)
//    }
}
