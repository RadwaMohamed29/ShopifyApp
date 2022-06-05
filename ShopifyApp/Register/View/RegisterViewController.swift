//
//  RegisterViewController.swift
//  ShopifyApp
//
//  Created by Radwa on 24/05/2022.
//

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var passwordText: UITextField!
    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var firstNameText: UITextField!
    var firstName, lastName, email, password: String!
    var registerViewModel: RegisterViewModelType = RegisterViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }

    @IBAction func signUpBtn(_ sender: Any) {
        firstName = firstNameText.text ?? ""
        lastName = "Mohamed"
        email = emailText.text ?? ""
        password = passwordText.text ?? ""
        
        registerViewModel.registerCustomer(firstName: firstName ?? "", lastName: lastName ?? "" , email: email ?? "", password: password ?? "")
        
        print("from view  \(String(describing: firstName ?? ""))")
        
    }
    
}
