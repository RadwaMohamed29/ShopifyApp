//
//  MeViewController.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 20/05/2022.
//

import UIKit

class MeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }


    @IBAction func asd(_ sender: Any) {
        let a = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
         self.navigationController?.pushViewController(a, animated: true)
    }
    
}
