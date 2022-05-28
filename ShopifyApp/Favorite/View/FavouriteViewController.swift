//
//  FavouriteViewController.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 23/05/2022.
//

import UIKit
import Kingfisher
import RxSwift
class FavouriteViewController: UIViewController ,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
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
//        localDataSource = LocalDataSource(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
//        do{
//            favProducts = try localDataSource!.getProductFromCoreData()
//        }catch{
//
//        }
       
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
//        productViewModel?.favoriteProductObservable.subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
//            .observe(on: MainScheduler.asyncInstance)
//            .subscribe(onNext: { [weak self] products in
//                self?.favProducts = products
//            }).disposed(by: disBag)
       
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
        
        cell.favouriteBtn.tag = indexPath.row
        cell.favouriteBtn.addTarget(self, action: #selector(showConformDialog), for: .touchUpInside)
        return cell
    }


 

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width / 2.4
        let availableHieght = view.frame.width/1.7
        return CGSize(width: availableWidth, height: availableHieght)
    }
    
    
  @objc  func showConformDialog(){
      let favouriteAlert = UIAlertController(title: "REMOVE FAVOURITE PRODUCT", message: "Are you sure to remove this product from your favourite list.", preferredStyle: .alert)
      // Present alert to user
      let confirmAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
      let cancleAction = UIAlertAction(title: "No", style: .default, handler: nil)
      
      favouriteAlert.addAction(confirmAction)
      favouriteAlert.addAction(cancleAction)
      self.present(favouriteAlert, animated: true, completion: nil)    }

}
