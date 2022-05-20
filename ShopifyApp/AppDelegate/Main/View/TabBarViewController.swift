//
//  TabBarViewController.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 20/05/2022.
//

import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let homeVC  = HomeViewController()
        let categoryVC = CategoryViewController()
        let meVC = MeViewController()
        
        homeVC.title = "Home"
        categoryVC.title = "Category"
        meVC.title = "Me"
        
        self.setViewControllers([homeVC,categoryVC,meVC], animated: false)
       // self.tabBar.backgroundColor = .red
        
        guard let items  = self.tabBar.items else {return}
        let images = ["house","square.grid.2x2.fill","person"]
        for i in 0...2{
            items[i].image = UIImage(systemName: images[i])
            
        }
        self.tabBar.backgroundColor = .white
        
        self.tabBar.tintColor = .black
    }


}
