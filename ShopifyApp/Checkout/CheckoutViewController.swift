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
    
    func approvePayment()
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
    var cartProducts : [CartProduct] = []
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
        orderViewModel = OrderViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        couponTxtField.text = Utilities.utilities.getCode()
    }
    
    func approvePayment() {
        orderViewModel?.addOrder(order: order!, completion: {[weak self] result in
            
            switch result{
            case true:
                do{
                    try self?.orderViewModel?.removeItemsFromCartToSpecificCustomer()
                    Utilities.utilities.setCodeUsed(code: self!.copon,isUsed: true)
                    DispatchQueue.main.async {
                        let homeVC = TabBarViewController(nibName: "TabBarViewController", bundle: nil)
                        self?.navigationController?.pushViewController(homeVC, animated: true)
                        Shared.showMessage(message: "Order will arrive soon", error: false)
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
        items = convertFromListOfCartProdeuctTolistOfLineItems(products: cartProducts)
        order = prepareOrderObject(items: items, adress: adress!,price: "\(total ?? 0)")
        let payment = PaymentMethodViewController(nibName: "PaymentMethodViewController", bundle: nil)
        
        //coupon check
        payment.checkoutDelegate = self
        payment.totalPrice = total
        self.navigationController?.pushViewController(payment, animated: true)
    }
    
    @IBAction func btnCheckDiscount(_ sender: Any) {
        if !couponTxtField.text!.isEmpty{
            copon = couponTxtField.text ?? ""
            if Utilities.utilities.getCode() == couponTxtField.text {
                if Utilities.utilities.isCodeUsed(code: couponTxtField.text ?? "") != true{
                    //MARK: discount not applicable on currency with both (EGP and USD).. please check it boda❤️
                    discount = subTotal! * (30/100)
                    discountLB.text = "\(discount)"
                    total = subTotal! - discount
                    totalPrice.text = "\(total ?? 0)"
                    let payment = PaymentMethodViewController(nibName: "PaymentMethodViewController", bundle: nil)
                    payment.totalPrice = Double(total ?? 0)
                }else{
                    Shared.showMessage(message: "This coupon is used", error: false)
                }
            }
        }
        
    }
}

extension CheckoutViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cartProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemCollectionViewCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor(red: 0.031, green: 0.498, blue: 0.537, alpha: 1).cgColor
        cell.layer.cornerRadius = 20
        setImage(image: cell.image, index: indexPath.row)
        cell.price.text = Shared.formatePrice(priceStr: cartProducts[indexPath.row].price)
        cell.amount.text = "\(cartProducts[indexPath.row].count)"
        
        
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
    
    func setImage(image: UIImageView,index : Int)  {
        let url = URL(string: cartProducts[index].image ?? "")
          let processor = DownsamplingImageProcessor(size: image.bounds.size)
                       |> RoundCornerImageProcessor(cornerRadius: 20)
          image.kf.indicatorType = .activity
        image.kf.setImage(
              with: url,
              options: [
                  .processor(processor),
                  .scaleFactor(UIScreen.main.scale),
                  .transition(.fade(1)),
                  .cacheOriginalImage
              ])
        image.layer.borderWidth = 1
        image.layer.borderColor = UIColor.lightGray.cgColor
        image.layer.cornerRadius = 20
    }
    func convertFromListOfCartProdeuctTolistOfLineItems(products:[CartProduct]) -> [LineItems]{
        var items : [LineItems] = []
        for item in products{
            items.append(convertFromCartProdeuctToLineItems(cartProduct: item))
        }
        return items
    }
    func convertFromCartProdeuctToLineItems(cartProduct : CartProduct)->LineItems{
        let lineItems = LineItems(id: nil
                                  , giftCard: false
                                  , name: cartProduct.title ?? ""
                                  , price: "\(cartProduct.price ?? "0")"
                                  , productExists: true
                                  , productID: Int(cartProduct.id ?? "0")
                                  , quantity: Int(cartProduct.count)
                                  , title: cartProduct.title ?? "")
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
    
    
}
