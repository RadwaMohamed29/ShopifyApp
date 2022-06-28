//
//  CheckoutViewController.swift
//  ShopifyApp
//
//  Created by Peter Samir on 24/05/2022.
//

import UIKit
import Kingfisher
import RxSwift
import SwiftMessages

protocol PaymentCheckoutDelegation{
    
    func approvePayment(discoun: Double)
    func onPaymentFailed()
}

class CheckoutViewController: UIViewController,PaymentCheckoutDelegation{
    
    
    
    
    @IBOutlet weak var subTotalLB: UILabel!
    
    @IBOutlet weak var couponTxtField: UITextField!
    @IBOutlet weak var lableAdress: UILabel!
    @IBOutlet weak var totalPrice: UILabel!
    @IBOutlet weak var discountLB: UILabel!
    @IBOutlet weak var itemsCV: UICollectionView!{
        didSet{
            itemsCV.delegate = self
            itemsCV.dataSource = self
            
            let orderCell = UINib(nibName: "ItemCollectionViewCell", bundle: nil)
            itemsCV.register(orderCell, forCellWithReuseIdentifier: "itemCell")
        }
    }
    @IBOutlet weak var smallView: UIView!
    var disBag = DisposeBag()
    var productVM : ProductDetailsViewModel?
    var itemList : [LineItem] = []
    var items :[LineItems] = []
    var adress : Address?
    var subTotal :Double?
    var discount : Double = 0
    var total : Double?
    var order : OrderObject?
    var customer : Customer?
    var orderViewModel :OrderViewModelProtocol?
    var copon : String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        subTotal = Utilities.utilities.getTotalPrice()
        total = subTotal!-discount
        subTotalLB.text = "\(Shared.formatePrice(priceStr: String(subTotal!)))"
        totalPrice.text = "Total: \(Shared.formatePrice(priceStr: String(total ?? 0)))"
        smallView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        smallView.layer.cornerRadius = 20
        discountLB.text = "\(Shared.formatePrice(priceStr: String(discount)))"
        lableAdress.text = "\(adress!.address2 ?? "") st, \(adress!.city ?? ""), \(adress!.country ?? "")"
        productVM = ProductDetailsViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
        orderViewModel = OrderViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Utilities.utilities.isCodeUsed(code: Utilities.utilities.getCode() ) != true{
            couponTxtField.text = Utilities.utilities.getCode()
        }else{
            couponTxtField.text = ""
        }
        
    }
    
    func approvePayment(discoun: Double) {
        orderViewModel?.addOrder(order: order!, completion: {[weak self] result in
            
            switch result{
            case true:
                self?.productVM?.deleteDraftOrder(draftOrderID: Utilities.utilities.getDraftOrder())
                Utilities.utilities.setDraftOrder(id: 0)
                self?.updateCustomerNote()
                do{
                    try self?.orderViewModel?.removeItemsFromCartToSpecificCustomer()
                    if discoun != 0 {
                        Utilities.utilities.setCodeUsed(code: self!.copon,isUsed: true)
//                        Utilities.utilities.setCode(code: "")
                    }
                    DispatchQueue.main.async {
                        let homeVC = TabBarViewController(nibName: "TabBarViewController", bundle: nil)
                        self?.navigationController?.pushViewController(homeVC, animated: true)
                        Shared.showMessage(message: "Order placed successfully", error: false)
                    }
                }catch let error{
                    let alert = UIAlertController(title: "Checkout", message: "\(error.localizedDescription)", preferredStyle: .alert)
                    let cancle = UIAlertAction(title: "Cancel", style: .cancel)
                    alert.addAction(cancle)
                    self?.present(alert, animated: true, completion: nil)
                }
            case false:
                print("can't post this order")
            }
        })
    }
    
    func onPaymentFailed() {
        
    }
    
    @IBAction func btnConfirmPayment(_ sender: Any) {
        items = convertFromListOfCartProdeuctTolistOfLineItems(products: itemList)
        order = prepareOrderObject(items: items, adress: adress!,price: "\(total ?? 0)")
        HandelConnection.handelConnection.checkNetworkConnection { [weak self] isConnected in
            if isConnected{
                let payment = PaymentMethodViewController(nibName: "PaymentMethodViewController", bundle: nil)
                payment.checkoutDelegate = self
                payment.totalPrice = self?.total
                payment.discount = self?.discount
                self?.navigationController?.pushViewController(payment, animated: true)
            }else{
                let alert = UIAlertController(title: "Network Connection!", message: "Check your network please!", preferredStyle: .alert)
                let okBtn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okBtn)
                self?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func btnCheckDiscount(_ sender: Any) {
            copon = couponTxtField.text ?? ""
            if Utilities.utilities.getCode() == copon {
                if Utilities.utilities.isCodeUsed(code: copon ) != true{
                    discount = subTotal! * (30/100)
                    discountLB.text = "\(Shared.formatePrice(priceStr: String(discount)))"
                    total = subTotal! - discount
                    totalPrice.text = "Total: \(Shared.formatePrice(priceStr: String(total ?? 0)))"
                    let payment = PaymentMethodViewController(nibName: "PaymentMethodViewController", bundle: nil)
                    payment.totalPrice = Double(total ?? 0)
                }else{
                    Shared.showMessage(message: "This coupon is used", error: false)
                }
            }else{
                discount = 0
                discountLB.text = "\(discount)"
                total = subTotal! - discount
                totalPrice.text = "\(total ?? 0)"
            }
        }
        
    
}

extension CheckoutViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemCollectionViewCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 0.031, green: 0.498, blue: 0.537, alpha: 1).cgColor
        cell.layer.cornerRadius = 20
        cell.updateUI(item: itemList[indexPath.row])
        cell.price.text = Shared.formatePrice(priceStr: itemList[indexPath.row].price)
        cell.amount.text = "\(itemList[indexPath.row].quantity)"
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 15, bottom: 15, right: 15)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth : Double
        let availableHieght :Double
        availableWidth = itemsCV.frame.width - 64
        availableHieght = itemsCV.frame.height - 24
        return CGSize(width: availableWidth, height: availableHieght)
    }

    func convertFromListOfCartProdeuctTolistOfLineItems(products:[LineItem]) -> [LineItems]{
        var items : [LineItems] = []
        for item in products{
            items.append(convertFromCartProdeuctToLineItems(cartProduct: item))
        }
        return items
    }
    func convertFromCartProdeuctToLineItems(cartProduct : LineItem)->LineItems{
        let lineItems = LineItems(id: nil
                                  , giftCard: false
                                  , name: cartProduct.title
                                  , price: "\(cartProduct.price )"
                                  , productExists: true
                                  , productID: Int(cartProduct.id )
                                  , quantity: Int(cartProduct.quantity)
                                  , title: cartProduct.title )
        return lineItems
    }

    
    func prepareOrderObject(items:[LineItems],adress:Address,price: String)->OrderObject{
        let customer : CustomerOrder?
        customer = CustomerOrder(id: Utilities.utilities.getCustomerId())
        let order = PostOrder(id: nil
                              , lineItems: items
                              , billingAdress: adress
                              , customer: customer!
                              ,tags: price)
        let postOrder = OrderObject(order: order)
        return postOrder
    }
    
    func updateCustomerNote(){
        if Utilities.utilities.isLoggedIn(){
            let editCustomer = EditCustomerRequest(id: Utilities.utilities.getCustomerId()
                                                   , email: Utilities.utilities.getCustomerEmail()
                                                   , firstName: Utilities.utilities.getCustomerName()
                                                   , password: "\(Utilities.utilities.getUserPassword())"
                                                   , note: "0")
            Utilities.utilities.setUserNote(note: editCustomer.note)
            productVM?.editCustomer(customer: EditCustomer(customer: editCustomer)
                                    ,customerID: Utilities.utilities.getCustomerId()
                                    ,completion: { result in
                        switch result{
                        case true:
                            print("note Deleted\(editCustomer.note)")
                        case false:
                            print("note can't Deleted")
                        }
                        
                    })
        }
        
    }
}
