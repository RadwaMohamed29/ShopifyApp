//
//  SettingsVC.swift
//  ShopifyApp
//
//  Created by Menna on 05/06/2022.
//

import UIKit

class SettingsVC: UIViewController {

    @IBOutlet weak var currentAdd: UILabel!
    @IBOutlet weak var currencyChange: UISegmentedControl!
    @IBOutlet weak var logut: UIButton!
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
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
