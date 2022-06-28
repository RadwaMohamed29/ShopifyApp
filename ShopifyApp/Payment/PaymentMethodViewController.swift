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
        HandelConnection.handelConnection.checkNetworkConnection { [weak self] isConnected in
            if isConnected{
                if self?.segmentedControl.selectedSegmentIndex == 1{
                    self?.startCheckout(amount: String(self?.totalPrice ?? 0))
                }else{
                    self?.checkoutDelegate?.approvePayment(discoun: self?.discount ?? 0)
                }
            }else{
                let alert = UIAlertController(title: "Network Connection!", message: "Check your network please!", preferredStyle: .alert)
                let okBtn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okBtn)
                self?.present(alert, animated: true, completion: nil)
            }
            
        }
       
    }
    
    @IBAction func segment(_ sender: Any) {
        if segmentedControl.selectedSegmentIndex == 1{
            btnPayMethod.setTitle("Continue with PayPal", for: .normal)
        }else{
            btnPayMethod.setTitle("Place Order", for: .normal)
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
