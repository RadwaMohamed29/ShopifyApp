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

    @IBOutlet weak var screenView: UIView!
    @IBOutlet weak var lblValidation: UILabel!
    @IBOutlet weak var lastNameText: MadokaTextField!
    @IBOutlet weak var passwordText: MadokaTextField!
    @IBOutlet weak var emailText: MadokaTextField!
    @IBOutlet weak var firstNameText: MadokaTextField!
    var firstName, lastName, email, password: String!
    let userDefualt = Utilities()
    let indicator = NVActivityIndicatorView(frame: .zero, type: .ballRotateChase, color: .label, padding: 0)
    var registerViewModel: RegisterViewModelType = RegisterViewModel()
    var isFromLogin: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        lblValidation.isHidden = true
        bindToViewModel()
     //   updateCustomer()
 
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    func bindToViewModel(){
        registerViewModel.bindNavigate = { [weak self] in
            DispatchQueue.main.async {
                self?.showActivityIndicator(indicator: self?.indicator, startIndicator: false)
                self?.navigate()
            }
          
        }
        registerViewModel.bindDontNavigate = { [weak self] in
            DispatchQueue.main.async {
                self?.showActivityIndicator(indicator: self?.indicator, startIndicator: false)
            }
        }
    }
   
    func navigate(){
            self.showActivityIndicator(indicator: self.indicator, startIndicator: false)
            if self.registerViewModel.navigate == true{
                if self.isFromLogin == true{
                    let home = TabBarViewController(nibName: "TabBarViewController", bundle: nil)
                    self.navigationController?.pushViewController(home, animated: true)
                }else{
                    self.navigationController?.popViewController(animated: true)
                }
            }
    }
    
//    func updateCustomer(){
//        if userDefualt.isLoggedIn(){
//            if userDefualt.getDraftOrder() != 0{
//                let editCustomer = EditCustomerRequest(id: userDefualt.getCustomerId(), email: userDefualt.getCustomerEmail(), firstName: userDefualt.getCustomerName(), password: "", note: String(userDefualt.getDraftOrder()))
//                registerViewModel.editCustomer(customer: EditCustomer(customer: editCustomer), customerID: userDefualt.getCustomerId(), completion: { result in
//                    switch result{
//                    case true:
//                        print("note added")
//                    case false:
//                        print("note can't add")
//                    }
//                    
//                })
//            }
//        }
//    }
//
    @IBAction func signUpBtn(_ sender: Any) {
        self.lblValidation.isHidden = true
        firstName = firstNameText.text
        lastName = lastNameText.text
        email = emailText.text
        password = passwordText.text
        self.showActivityIndicator(indicator: self.indicator, startIndicator: true)
        if firstName != "" && lastName != ""{
            if userDefualt.isValidEmail(email){
                
                if password.count >= 6{
                        registerViewModel.registerCustomer(firstName: firstName , lastName: lastName , email: email, password: password){ result in
                            switch result{
                            case true:
                                print("from view  \(String(describing: self.firstName ?? ""))")
                            case false:
                                
                                //if self.registerViewModel.flag == true{
                                    DispatchQueue.main.async {
                                        self.showActivityIndicator(indicator: self.indicator, startIndicator: false)
                                        self.lblValidation.isHidden = false
                                        self.lblValidation.text = "This user already exists"
                                    }
                                    
                                //}
//                                else{
//                                    DispatchQueue.main.async {
//                                        self.showActivityIndicator(indicator: self.indicator, startIndicator: false)
//                                        self.showSnackBar()
//                                        self.indicator.isHidden = true
//                                        
//                                    }
//                                }
                            }
                        }
                }else{
                    lblValidation.isHidden = false
                    self.showActivityIndicator(indicator: self.indicator, startIndicator: false)
                    lblValidation.text = "Password must be more than 5 digit "
                }
              
            }else{
                lblValidation.isHidden = false
                self.showActivityIndicator(indicator: self.indicator, startIndicator: false)
                lblValidation.text = "Please, enter valid email"
            }
        }else{
            lblValidation.isHidden = false
            self.showActivityIndicator(indicator: self.indicator, startIndicator: false)
            lblValidation.text = "Required full name "
        }
       
        
    }
    
    @IBAction func signInBtn(_ sender: Any) {
        let a = LoginViewController(nibName:"LoginViewController", bundle: nil)
        a.isFromRegister = true
        self.navigationController?.pushViewController(a, animated: true)
    }
}
