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


    @IBAction func navigateTest(_ sender: Any) {
        let detailsVC = ProductDetailsViewController(nibName: String(describing: ProductDetailsViewController.self), bundle: nil)
    
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }
    
}
