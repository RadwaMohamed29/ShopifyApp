//
//  OnBoardingViewController.swift
//  ShopifyApp
//
//  Created by Peter Samir on 20/06/2022.
//

import UIKit

class OnBoardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction func getStartedBtn(_ sender: Any) {
        let tabBar = TabBarViewController(nibName:"TabBarViewController", bundle: nil)
        self.navigationController?.pushViewController(tabBar, animated: true)
    }
    
}
