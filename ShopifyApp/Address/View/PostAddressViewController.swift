//
//  PostAddressViewController.swift
//  ShopifyApp
//
//  Created by Peter Samir on 05/06/2022.
//

import UIKit


class PostAddressViewController: UIViewController {

    var buildNo, streetName, cityName, country:String?
    var isEdit = false
    var timer = Timer()
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
        fillTextFields()
    }

    func fillTextFields() {
        if isEdit{
            buildNoTxtV.text = (buildNo ?? "")
            streetNameTxtF.text = (streetName ?? "")
            cityTxtF.text = (cityName ?? "")
            countryTxtF.text = (country ?? "")
        }
    }
    
    @IBAction func btnConfirm(_ sender: Any) {
        if validateAddressInput() {
            viewModel?.getAddDetailsAndPostToCustomer(customerID: "6466443772133", buildNo: buildNoTxtV.text!, streetName: streetNameTxtF.text!, city: cityTxtF.text!, country: countryTxtF.text!,completion: {[weak self] isSucceded in
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
