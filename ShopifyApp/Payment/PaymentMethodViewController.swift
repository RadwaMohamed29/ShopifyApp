//
//  PaymentMethodViewController.swift
//  ShopifyApp
//
//  Created by Peter Samir on 24/05/2022.


import UIKit
import Braintree
import BraintreeDropIn

class PaymentMethodViewController: UIViewController {
    
    let authorization = "sandbox_rzprnvv6_z6cj5tnwx5cyps9m"
    
    @IBOutlet weak var btnPayMethod: UIButton!
    var braintreeAPIClient:BTAPIClient!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
        
    @IBAction func btnpay(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 1{
            startCheckout(amount: "100")
        }else{
            
        }
    }
    
    @IBAction func segment(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 1{
            btnPayMethod.setTitle("PayPal", for: .normal)
        }else{
            btnPayMethod.setTitle("CASH", for: .normal)
        }
    }
    
    func startCheckout(amount:String) {
        self.braintreeAPIClient = BTAPIClient(authorization: authorization)
        let payPalDriver = BTPayPalDriver(apiClient: braintreeAPIClient!)
        let request = BTPayPalCheckoutRequest(amount: amount)
        request.currencyCode = "USD"
        payPalDriver.tokenizePayPalAccount(with: request) { (tokenizedPayPalAccount, error) in
            if let tokenizedPayPalAccount = tokenizedPayPalAccount {
            } else if let error = error {
                print(error)
            } else {
                print("the user canceled")
            }
        }
    }
    
}


extension PaymentMethodViewController : BTViewControllerPresentingDelegate{
    func paymentDriver(_ driver: Any, requestsPresentationOf viewController: UIViewController) {
            
    }
    
    func paymentDriver(_ driver: Any, requestsDismissalOf viewController: UIViewController) {
        
    }
}
