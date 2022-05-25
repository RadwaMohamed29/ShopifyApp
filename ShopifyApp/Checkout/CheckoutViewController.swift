//
//  CheckoutViewController.swift
//  ShopifyApp
//
//  Created by Peter Samir on 24/05/2022.
//

import UIKit

class CheckoutViewController: UIViewController {

    
    @IBOutlet weak var smallView: UIView!
    @IBOutlet weak var couponView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        smallView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        couponView.layer.cornerRadius = 20
        smallView.layer.cornerRadius = 60
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
