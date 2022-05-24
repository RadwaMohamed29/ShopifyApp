//
//  MeViewController.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 20/05/2022.
//

import UIKit
import Kingfisher

class MeViewController: UIViewController {

    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var noUserFound: UIView!
    @IBOutlet weak var userFounView: UIView!
    @IBOutlet weak var wishListCV: UICollectionView!{
        didSet{
            wishListCV.delegate = self
            wishListCV.dataSource = self
            
            let favProductCell = UINib(nibName: "FavouriteCollectionViewCell", bundle: nil)
            wishListCV.register(favProductCell, forCellWithReuseIdentifier: "FavouriteproductCell")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Profile"
    }

    override func viewWillAppear(_ animated: Bool) {
            noUserFound.removeFromSuperview()
        
    }
    @IBAction func gotoSignInScreen(_ sender: Any) {
    }
    @IBAction func gotoSignUpScreen(_ sender: Any) {
    }
    @IBAction func gotoCartScreen(_ sender: Any) {
    }
    @IBAction func gotoSetting(_ sender: Any) {
        
    }
    
    @IBAction func gotoOrdersScreens(_ sender: Any) {
    }
    @IBAction func gotoFavoriteScreen(_ sender: Any) {
        let favScreen = FavouriteViewController(nibName: "FavouriteViewController", bundle: nil)
        self.navigationController?.pushViewController(favScreen, animated: true)

    }
    
    @IBAction func navToPayment(_ sender: Any) {
        let payment = PaymentMethodViewController(nibName: "PaymentMethodViewController", bundle: nibBundle)
        self.navigationController?.pushViewController(payment, animated: true)
    }
}

extension MeViewController : UICollectionViewDataSource ,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteproductCell", for: indexPath) as! FavouriteCollectionViewCell
          let url = URL(string: "https://cdn.shopify.com/s/files/1/0643/6637/9237/products/85cc58608bf138a50036bcfe86a3a362.jpg?v=1652442194")
          let processor = DownsamplingImageProcessor(size: cell.productImage.bounds.size)
                       |> RoundCornerImageProcessor(cornerRadius: 20)
          cell.productImage.kf.indicatorType = .activity
          cell.productImage.kf.setImage(
              with: url,
              placeholder: UIImage(named: "placeholderImage"),
              options: [
                  .processor(processor),
                  .scaleFactor(UIScreen.main.scale),
                  .transition(.fade(1)),
                  .cacheOriginalImage
              ])
          
          cell.favouriteBtn.tag = indexPath.row
          cell.favouriteBtn.addTarget(self, action: #selector(showConformDialog), for: .touchUpInside)
          return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 15, bottom: 15, right: 15)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width / 2.5
        
        let availableHieght = view.frame.width/2.3
        
        return CGSize(width: availableWidth, height: availableHieght)
    }
    @objc  func showConformDialog(){
        let favouriteAlert = UIAlertController(title: "REMOVE FAVOURITE PRODUCT", message: "Are you sure to remove this product from your favourite list.", preferredStyle: .alert)
        // Present alert to user
        let confirmAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
        let cancleAction = UIAlertAction(title: "No", style: .default, handler: nil)
        
        favouriteAlert.addAction(confirmAction)
        favouriteAlert.addAction(cancleAction)
        self.present(favouriteAlert, animated: true, completion: nil)
        
    }

  }

