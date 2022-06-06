//
//  RegisterViewController.swift
//  ShopifyApp
//
//  Created by Radwa on 24/05/2022.
//

import UIKit
import TextFieldEffects
import NVActivityIndicatorView

class RegisterViewController: UIViewController {

    @IBOutlet weak var lblValidation: UILabel!
    @IBOutlet weak var lastNameText: MadokaTextField!
    @IBOutlet weak var passwordText: MadokaTextField!
    @IBOutlet weak var emailText: MadokaTextField!
    @IBOutlet weak var firstNameText: MadokaTextField!
    var firstName, lastName, email, password: String!
    let userDefualt = Utilities()
    let indicator = NVActivityIndicatorView(frame: .zero, type: .ballRotateChase, color: .label, padding: 0)
    var registerViewModel: RegisterViewModelType = RegisterViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        lblValidation.isHidden = true
 
    }


    @IBAction func signUpBtn(_ sender: Any) {
        self.lblValidation.isHidden = true
        firstName = firstNameText.text
        lastName = lastNameText.text
        email = emailText.text
        password = passwordText.text
        
        if firstName != "" && lastName != ""{
            if userDefualt.isValidEmail(email){
                
                if password.count >= 6{
                        registerViewModel.registerCustomer(firstName: firstName , lastName: lastName , email: email, password: password){ result in
                            switch result{
                            case true:
                                DispatchQueue.main.async {
                                    let a = TabBarViewController(nibName:"TabBarViewController", bundle: nil)
                                    self.navigationController?.pushViewController(a, animated: true)
                                }
                               
                                print("from view  \(String(describing: self.firstName ?? ""))")
                            case false:
                                DispatchQueue.main.async {
                                    self.lblValidation.isHidden = false
                                    self.lblValidation.text = "This user already exists"
                                }
                               
                            }
                        }
                }else{
                    lblValidation.isHidden = false
                    lblValidation.text = "Password must be more than 5 digit "
                }
              
            }else{
                lblValidation.isHidden = false
                lblValidation.text = "Please, enter valid email"
            }
        }else{
            lblValidation.isHidden = false
            lblValidation.text = "Required full name "
        }
       
        
    }
    
    @IBAction func signInBtn(_ sender: Any) {
        let a = LoginViewController(nibName:"LoginViewController", bundle: nil)
        self.navigationController?.pushViewController(a, animated: true)
    }
}
