//
//  PaymentMethodViewController.swift
//  ShopifyApp
//
//  Created by Peter Samir on 24/05/2022.


import UIKit
import Braintree
import BraintreeDropIn
import SwiftMessages

class PaymentMethodViewController: UIViewController {
    
    var totalPrice:Double?
    var checkoutDelegate:PaymentCheckoutDelegation?
    var discount :Double?
    let authorization = "sandbox_rzprnvv6_z6cj5tnwx5cyps9m"
    @IBOutlet weak var labelTotalPrice: UILabel!
    @IBOutlet weak var btnPayMethod: UIButton!
    var braintreeAPIClient:BTAPIClient!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        labelTotalPrice.text = Shared.formatePrice(priceStr: String(totalPrice ?? 0))
    }
    
        
    @IBAction func btnpay(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 1{
            startCheckout(amount: String(totalPrice ?? 0))
        }else{
            checkoutDelegate?.approvePayment(discoun: discount ?? 0)
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
        var err:Error?
        payPalDriver.tokenizePayPalAccount(with: request) { [weak self] (tokenizedPayPalAccount, error) in
            if tokenizedPayPalAccount != nil {
            } else if let error = error {
                err = error
                print("error is \(error)")
            }
            if err == nil{
                self?.checkoutDelegate?.approvePayment(discoun: self?.discount ?? 0)
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
