//
//  CheckoutViewController.swift
//  ShopifyApp
//
//  Created by Peter Samir on 24/05/2022.
//

import UIKit
import Kingfisher
import RxSwift
class CheckoutViewController: UIViewController {
    
    
    @IBOutlet weak var subTotalLB: UILabel!
    
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
    var discount : Double = 40
    var total : Double?
    var order : OrderObject?
    var customer : Customer?
    var orderViewModel :OrderViewModelProtocol?
    override func viewDidLoad() {
        super.viewDidLoad()
        subTotal = Utilities.utilities.getTotalPrice()
        total = subTotal!-discount
        subTotalLB.text = "\(subTotal!)"
        totalPrice.text = "Total: \(total ?? 0)"
        smallView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        smallView.layer.cornerRadius = 20
        discountLB.text = "\(discount)"
        lableAdress.text = "\(adress!.address2 ?? "") st, \(adress!.city ?? ""), \(adress!.country ?? "")"
        orderViewModel = OrderViewModel()
        
    }
    
    @IBAction func btnConfirmPayment(_ sender: Any) {
        items = convertFromListOfCartProdeuctTolistOfLineItems(products: cartProducts)
        order = prepareOrderObject(items: items, adress: adress!)
        orderViewModel?.addOrder(order: order!, completion: { result in
            
            switch result{
            case true:
                DispatchQueue.main.async{
                    let payment = PaymentMethodViewController(nibName: "PaymentMethodViewController", bundle: nil)
                    self.present(payment, animated: true, completion: nil)
                }
               
            case false:
                print("can't post this order")
            }
        })
        
    }
    
}

extension CheckoutViewController : UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        cartProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "itemCell", for: indexPath) as! ItemCollectionViewCell
        setImage(image: cell.image, index: indexPath.row)
        cell.price.text = cartProducts[indexPath.row].price
        cell.amount.text = "\(cartProducts[indexPath.row].count)"
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 15, bottom: 15, right: 15)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth : Double
        let availableHieght :Double
        availableWidth = itemsCV.frame.width - 24
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
    func getCustomer(){
        do{
            try orderViewModel!.getCurrentCustomer(id:"\(Utilities.utilities.getCustomerId())")
            orderViewModel!.customerObservable.subscribe { result in
                self.customer = result
            } onError: { error in
                print(error.localizedDescription)
            }.disposed(by: disBag)

        }catch{}
        
    }
    
    func prepareOrderObject(items:[LineItems],adress:Address)->OrderObject{
        let customer : CustomerOrder?
        customer = CustomerOrder(id: Utilities.utilities.getCustomerId())
        let order = PostOrder(id: nil
                              , lineItems: items
                              , billingAdress: adress
                              , customer: customer!)
        let postOrder = OrderObject(order: order)
        return postOrder
    }
    
    
}
