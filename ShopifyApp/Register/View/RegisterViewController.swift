//
//  RegisterViewController.swift
//  ShopifyApp
//
//  Created by Radwa on 24/05/2022.
//

import UIKit
import TextFieldEffects
import NVActivityIndicatorView
import RxSwift
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
        firstName = firstNameText.text ?? ""
        lastName = lastNameText.text ?? ""
        email = emailText.text ?? ""
        password = passwordText.text ?? ""
        if firstName != "" && lastName != ""{
            if userDefualt.isValidEmail(email){
                
                if password.count >= 6{
                    registerViewModel.isEmailExist(email: email)
//                    registerViewModel.isExistObservable.subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
//                        .observe(on: MainScheduler.asyncInstance)
//                        .subscribe { <#Bool#> in
//                            <#code#>
//                        } onError: { <#Error#> in
//                            <#code#>
//                        } onCompleted: {
//                            <#code#>
//                        } onDisposed: {
//                            <#code#>
//                        }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 10.0){ [self] in
                        if  registerViewModel.isExist == false {
                            registerViewModel.registerCustomer(firstName: firstName ?? "", lastName: lastName ?? "" , email: email ?? "", password: password ?? "")
                            self.showActivityIndicator(indicator: self.indicator, startIndicator: false)
                            self.navigationController?.popViewController(animated: true)
                            print("from view  \(String(describing: firstName ?? ""))")
                        }else{
                            lblValidation.isHidden = false
                            lblValidation.text = "This user already exists"
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
