//
//  FavouriteViewController.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 23/05/2022.
//

import UIKit
import Kingfisher
import RxSwift
import Lottie
class FavouriteViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,SharedProtocol {
    func presentAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    var disBag = DisposeBag()
    var productViewModel : ProductDetailsViewModel?
    var localDataSource : LocalDataSource?
    @IBOutlet weak var noDataView: UIView!
    
    @IBOutlet weak var favouriteCollectionView: UICollectionView!

    var favProducts : [FavoriteProducts] = []
    var productName :String?
    var productImage : String?
    var productSize : Int?
    var productRate : Double?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorite"
        
        productViewModel = ProductDetailsViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
        getFavoriteProductsFromCoreData()

        let favProductCell = UINib(nibName: "FavouriteCollectionViewCell", bundle: nil)
        favouriteCollectionView.register(favProductCell, forCellWithReuseIdentifier: "FavouriteproductCell")
        favouriteCollectionView.delegate = self
      favouriteCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    func getFavoriteProductsFromCoreData(){
        
        do{
            try  productViewModel?.getAllFavoriteProducts(completion: { response in
                //MARK: LSA M5LST4
                switch response{
                case true:
                    print("data retrived successfuly")
                case false:
                    print("data cant't retrieved")
                }
            })

        }
        catch let error{
            print(error.localizedDescription)
        }
        favProducts = (productViewModel?.favoriteProducts)!
        favouriteCollectionView.reloadData()
       
    }
    override func viewWillAppear(_ animated: Bool) {
        if !favProducts.isEmpty{
            noDataView.isHidden = true
        }
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       return favProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
       
      let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteproductCell", for: indexPath) as! FavouriteCollectionViewCell
        let url = URL(string: favProducts[indexPath.row].scr)
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
        cell.ProductName.text = favProducts[indexPath.row].title
        cell.priceOfTheProduct.text = "$ \(favProducts[indexPath.row].price)"
        cell.productImage.layer.borderWidth = 1
        cell.productImage.layer.borderColor = UIColor.lightGray.cgColor
        cell.productImage.layer.cornerRadius = 20
        
        cell.favouriteBtn.tag = indexPath.row
        cell.favouriteBtn.addTarget(self, action: #selector(longPress(recognizer:)), for: .touchUpInside)
        return cell
    }


    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detailsVC = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
        detailsVC.productId = favProducts[indexPath.row].id
        self.navigationController?.pushViewController(detailsVC, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width / 2.4
        let availableHieght = view.frame.width/1.7
        return CGSize(width: availableWidth, height: availableHieght)
    }
    
    
    func showConformDialog(title:String,alertMessage:String,index:Int,favBtn :UIButton,isFav:Bool){
            let favouriteAlert = UIAlertController(title: title, message: alertMessage, preferredStyle: .alert)
            let confirmAction = UIAlertAction(title: "Yes", style: .default) { (action) -> Void in
                self.actionForConfirmationOfFavoriteButton(index: index,favBtn: favBtn,isFav: isFav)
        }
            let cancleAction = UIAlertAction(title: "No", style: .default, handler: nil)
            
            favouriteAlert.addAction(confirmAction)
            favouriteAlert.addAction(cancleAction)
            self.present(favouriteAlert, animated: true, completion: nil)
            
        }
        @objc private func longPress(recognizer: UIButton) {
         
            var alertMessage = ""
            var alertTitle = ""
            self.productViewModel?.checkFavorite(id: "\(self.favProducts[recognizer.tag].id)")
            
           
               
                if self.productViewModel?.isFav == false {
                    alertMessage = "Are you sure to add this product to your favourite list."
                   alertTitle = "Add favorite product"
                    showConformDialog(title: alertTitle,alertMessage: alertMessage, index: recognizer.tag,favBtn: recognizer,isFav: false)
                    
                }else{
                    alertMessage = "Are you sure to remove this product from your favourite list."
                    alertTitle = "Remove favorite product"
                    showConformDialog(title: alertTitle,alertMessage: alertMessage, index: recognizer.tag,favBtn: recognizer,isFav: true)
                }
           
          }
        func actionForConfirmationOfFavoriteButton(index:Int,favBtn: UIButton,isFav:Bool){
           
            if isFav == true{
                do{
                    try self.productViewModel?.removeProductFromFavorites(productID: "\(favProducts[index].id)", completionHandler: { response in
                        switch response{
                        case true:
                            print("removed seuccessfully")
                            self.getFavoriteProductsFromCoreData()
                            self.favouriteCollectionView.reloadData()
                            
                        case false:
                            print("Failed to remove")
                        }
                    })
                }catch let error{
                    print(error.localizedDescription)
                }
            }
          
        }


}
