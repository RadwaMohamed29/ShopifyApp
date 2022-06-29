//
//  LaunchViewController.swift
//  ShopifyApp
//
//  Created by Radwa on 05/06/2022.
//

import UIKit
import Lottie

class LaunchViewController: UIViewController {

    @IBOutlet weak var splashView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        let animationView = AnimationView()

        animationView.animation = Animation.named("Animation")
        animationView.contentMode = .scaleAspectFit
        animationView.frame = view.bounds
        animationView.loopMode = .loop
        animationView.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        animationView.center = view.center

           

        animationView.play()
        view.addSubview(animationView)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else {return}
            let a = TabBarViewController(nibName:"TabBarViewController", bundle: nil)
            if !Utilities.utilities.isFirstTimeInApp(){
                Utilities.utilities.setIsFirstTimeInApp()
                let onboarding = FirstOnBoardingViewController(nibName:"FirstOnBoardingViewController", bundle: nil)
                self.navigationController?.pushViewController(onboarding, animated: true)
            }else{
                self.navigationController?.pushViewController(a, animated: true)
            }
            
        }

    }


  

}
