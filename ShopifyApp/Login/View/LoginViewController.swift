//
//  LoginViewController.swift
//  ShopifyApp
//
//  Created by Radwa on 24/05/2022.
//

import UIKit
import TextFieldEffects
import NVActivityIndicatorView
class LoginViewController: UIViewController {

    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var emailLabel: MadokaTextField!
    @IBOutlet weak var passwordLabel: MadokaTextField!
    var viewModel: LoginViewModelType!
    let indicator = NVActivityIndicatorView(frame: .zero, type: .ballRotateChase, color: .label, padding: 0)
    var email, password: String!
    var isFromRegister: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
            self.viewModel = LoginViewModel()
            self.bindToViewModel()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func bindToViewModel(){
        viewModel.bindNavigate = { [weak self] in
            DispatchQueue.main.async {
                self?.showActivityIndicator(indicator: self?.indicator, startIndicator: false)
                self?.navigate()
            }
        }
        viewModel.bindDontNavigate = { [weak self] in
            let message = self?.viewModel.errorMessage ?? "user not exist, please check your information"
            DispatchQueue.main.async {
                self?.showActivityIndicator(indicator: self?.indicator, startIndicator: false)
            self?.errorLabel.text = message
            }
        }
    }
   
    func navigate(){
        DispatchQueue.main.async {
            self.showActivityIndicator(indicator: self.indicator, startIndicator: false)
            if self.isFromRegister == true{
                let home = TabBarViewController(nibName: "TabBarViewController", bundle: nil)
                self.navigationController?.pushViewController(home, animated: true)
            }else{
                self.navigationController?.popViewController(animated: true)
            }
            
        }
    }
    @IBAction func loginBtn(_ sender: Any) {
        self.showActivityIndicator(indicator: self.indicator, startIndicator: true)
        email = emailLabel.text ?? ""
        password = passwordLabel.text ?? ""
        viewModel.loginCustomer(email: email, password: password)
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        DispatchQueue.main.async {
         let a = RegisterViewController(nibName:"RegisterViewController", bundle: nil)
            a.isFromLogin = true
         self.navigationController?.pushViewController(a, animated: true)
       
        }
    }


}
