//
//  FirstOnBoardingViewController.swift
//  ShopifyApp
//
//  Created by Peter Samir on 20/06/2022.
//

import UIKit

class FirstOnBoardingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }

    @IBAction func btnOnboarding2(_ sender: Any) {
        let onboard2 = OnBoardingViewController(nibName: "OnBoardingViewController", bundle: nil)
        self.navigationController?.pushViewController(onboard2, animated: true)
    }

}
