//
//  LoginViewController.swift
//  ShopifyApp
//
//  Created by Radwa on 24/05/2022.
//

import UIKit
class LoginViewController: UIViewController {

    @IBOutlet weak var emailLabel: UITextField!
    @IBOutlet weak var passwordLabel: UITextField!
    var viewModel: LoginViewModelType!
    var email, password: String!
    override func viewDidLoad() {
        super.viewDidLoad()
  
            self.viewModel = LoginViewModel()
            self.bindToViewModel()
        
        // Do any additional setup after loading the view.
    }
    func bindToViewModel(){
        viewModel.bindNavigate = { [weak self] in
            self?.navigate()
        }
        
        viewModel.bindDontNavigate = { [weak self] in
            let message = self?.viewModel.alertMessage ?? "Can't login, please check your info"
            self?.showAlret(message: message)
        }
    }
    func navigate(){
        DispatchQueue.main.async {
//         let a = HomeViewController(nibName:"HomeViewController", bundle: nil)
//         self.navigationController?.pushViewController(a, animated: true)
            self.navigationController?.popViewController(animated: true)
        print("success login")
        }
    }
    func showAlret(message:String){
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Warning", message: message, preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .default) { (action) in
                print("alert working")
            }
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
       
    }

    @IBAction func loginBtn(_ sender: Any) {
        email = emailLabel.text ?? ""
        password = passwordLabel.text ?? ""
        viewModel.loginCustomer(email: email, password: password)
    }
    
    @IBAction func registerBtn(_ sender: Any) {
        DispatchQueue.main.async {
         let a = RegisterViewController(nibName:"RegisterViewController", bundle: nil)
         self.navigationController?.pushViewController(a, animated: true)
       
        }
    }


}
