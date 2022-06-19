//
//  CheckoutViewController.swift
//  ShopifyApp
//
//  Created by Peter Samir on 24/05/2022.
//

import UIKit
import Kingfisher
class CheckoutViewController: UIViewController {
    
    
    @IBOutlet weak var subTotalLB: UILabel!
    
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
    var cartProducts : [CartProduct] = []
    var items :[LineItems] = []
    var adress : Address?
    var subTotal :Double?
    var discount : Double = 40
    var order : Order?
    override func viewDidLoad() {
        super.viewDidLoad()
        subTotal = Utilities.utilities.getTotalPrice()
        let total = subTotal!-discount
        subTotalLB.text = "\(subTotal!)"
        totalPrice.text = "Total: \(total)"
        smallView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        smallView.layer.cornerRadius = 20
        
    }
    
    @IBAction func btnConfirmPayment(_ sender: Any) {
        let payment = PaymentMethodViewController(nibName: "PaymentMethodViewController", bundle: nil)
        self.present(payment, animated: true, completion: nil)
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
}
