//
//  LaunchViewController.swift
//  ShopifyApp
//
//  Created by Radwa on 05/06/2022.
//

import UIKit
import Lottie

class LaunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let animationView = AnimationView()
        animationView.animation = Animation.named("LuanchAnimation")
        //animationView.contentMode = .scaleAspectFit
        animationView.frame = view.bounds
        animationView.loopMode = .loop
        animationView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        animationView.center = view.center
       
        animationView.play()
        view.addSubview(animationView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) { [weak self] in
            guard let self = self else {return}
            let a = TabBarViewController(nibName:"TabBarViewController", bundle: nil)
            self.navigationController?.pushViewController(a, animated: true)
        }

    }


  

}
