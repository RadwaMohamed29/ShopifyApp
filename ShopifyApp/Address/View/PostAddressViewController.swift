//
//  PostAddressViewController.swift
//  ShopifyApp
//
//  Created by Peter Samir on 05/06/2022.
//

import UIKit


class PostAddressViewController: UIViewController {

    let userDefault = Utilities()
    var streetName, cityName, country:String?
    var isEdit = false
    var timer = Timer()
    var editedAddress:Address!
    var addressID: Int!
    var phone: String!
    @IBOutlet weak var myView: UIView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var buildNoTxtV: UITextField!
    @IBOutlet weak var streetNameTxtF: UITextField!
    @IBOutlet weak var cityTxtF: UITextField!
    @IBOutlet weak var countryTxtF: UITextField!
    private var viewModel:AddressViewModelProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = AddressViewModel(network: APIClient())
        // in UIViewController Extension
        setTxtFieldStyle(txt: [buildNoTxtV, streetNameTxtF, cityTxtF, countryTxtF])
        fillTextFields()
    }
    
    func fillTextFields() {
        if isEdit{
            buildNoTxtV.text = (phone ?? ""  )
            streetNameTxtF.text = (streetName ?? "")
            cityTxtF.text = (cityName ?? "")
            countryTxtF.text = (country ?? "")
        }
    }
    
    func editAddress(){
        print (buildNoTxtV.text!)

        editedAddress = Address( address2: streetNameTxtF.text!, city: cityTxtF.text!, country: countryTxtF.text!, phone: buildNoTxtV.text!)
        if validateAddressInput(){
            if buildNoTxtV.text!.count != 11 || buildNoTxtV.text!.prefix(2) != "01"{
                Shared.showMessage(message: "please enter a valid phone number", error: true)
                return
            }
            viewModel?.editAddress(address: editedAddress, addressID: String(addressID), customerID: String(userDefault.getCustomerId()),completion: {[weak self] isSucceded in
                HandelConnection.handelConnection.checkNetworkConnection {[weak self] isConn in
                    if isConn{
                        if isSucceded{
                            self?.myView.layer.opacity = 0.5
                            self?.showProgressBar()
                            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                                Shared.showMessage(message: "Address Updated Successfully", error: false)
                                self?.navigationController?.popViewController(animated: true)
                            })
                        }else{
                            self?.showProgressBar()
                            DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                                Shared.showMessage(message: "You may be Entered Wrong Country", error: true)
                            })
                        }
                    }else{
                        self?.showSnackBar()
                    }
                }
                
            })
        }else {
            Shared.showMessage(message: "please fill all fields", error: true)
        }
        
    }
    
    @IBAction func btnConfirm(_ sender: Any) {
        if isEdit{
            editAddress()
        }else{
            if buildNoTxtV.text!.count != 11 || buildNoTxtV.text!.prefix(2) != "01"{
                Shared.showMessage(message: "please enter a valid phone number", error: true)
                return
            }
            if validateAddressInput() {
                let id:String = String((userDefault.getCustomerId()))
                viewModel?.getAddDetailsAndPostToCustomer(customerID: id, phone: buildNoTxtV.text!, streetName: streetNameTxtF.text!, city: cityTxtF.text!, country: countryTxtF.text!,completion: {[weak self] isSucceded in
                    HandelConnection.handelConnection.checkNetworkConnection {[weak self] isConn in
                        if isConn{
                            if isSucceded{
                                self?.myView.layer.opacity = 0.5
                                self?.showProgressBar()
                                DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                                    Shared.showMessage(message: "Address Added Successfully", error: false)
                                    self?.navigationController?.popViewController(animated: true)
                                })
                            }else{
                                self?.showProgressBar()
                                DispatchQueue.main.asyncAfter(deadline: .now()+2, execute: {
                                    Shared.showMessage(message: "You may be Entered Wrong Country", error: true)
                                })
                            }
                        }else{
                            self?.showSnackBar()
                        }
                    }
                    
                })
             
            }else{
                Shared.showMessage(message: "please fill all fields", error: true)
            }
        }
 
    
        
    }
    
    func showProgressBar()  {
        progressView.isHidden = false
        var progress:Float = 0.0
        progressView.progress = progress
        timer = Timer.scheduledTimer(withTimeInterval: 0.08, repeats: true, block: { [weak self] timer in
            progress += 0.05
            self?.progressView.progress = progress
            if self?.progressView.progress == 1{
                self?.progressView.progress = 0
                self?.progressView.isHidden = true
            }
        })
    }
    
    func validateAddressInput() ->Bool {
        
        guard let _ = buildNoTxtV, let _ = streetNameTxtF, let _ = cityTxtF, let _ = countryTxtF else{
            return false
        }
        let buildno = trimWhiteSpaces(str: buildNoTxtV.text ?? "")
        let streetName = trimWhiteSpaces(str: streetNameTxtF.text ?? "")
        let city = trimWhiteSpaces(str: cityTxtF.text ?? "")
        let country = trimWhiteSpaces(str: countryTxtF.text ?? "")
        if buildno != "" && streetName != "" && city != "" && country != "" {
            return true
        }else{
            return false
        }
    }
    
    func trimWhiteSpaces(str:String) -> String{
        let trimmedStr = str.trimmingCharacters(in: NSCharacterSet.whitespaces)
        return trimmedStr
    }
}
//6256076292354
//https://54e7ce1d28a9d3b395830ea17be70ae1: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@mad-ism2022.myshopify.com/admin/api/2022-04/customers/6256076292354/addresses.json
