//
//  FavouriteViewController.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 23/05/2022.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import CoreMedia
import Lottie
import NVActivityIndicatorView
class FavouriteViewController: UIViewController {
    var lastIndex :IndexPath?
    var countOfSelectedItem = 0
    var disBag = DisposeBag()
    var listOfSelectedProducts:[FavoriteProducts] = []
    @IBOutlet weak var addToCart: UIButton!
    var favouriteProductsCD : [FavouriteProduct] = []
    let indicator = NVActivityIndicatorView(frame: .zero, type: .ballRotateChase, color: .label, padding: 0)
    var productViewModel : ProductDetailsViewModel?
    @IBOutlet weak var noDataView: UIView!
    
    @IBOutlet weak var favouriteCollectionView: UICollectionView!
    var productDetails : Product?
    var itemList: [LineItem] = []
    var favProducts : [FavoriteProducts] = []
    var productName :String?
    var productImage : String?
    var productSize : Int?
    var productRate : Double?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Favorite"
        
        productViewModel = ProductDetailsViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
        

        let favProductCell = UINib(nibName: "FavouriteCollectionViewCell", bundle: nil)
        favouriteCollectionView.register(favProductCell, forCellWithReuseIdentifier: "FavouriteproductCell")
        favouriteCollectionView.delegate = self
        favouriteCollectionView.dataSource = self
        getFavoriteProductsFromCoreData()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        addToCart.isHidden = true
        super.viewWillAppear(animated)
                if !favProducts.isEmpty{
            noDataView.isHidden = true
        }
        else{
            noDataView.isHidden = false
        }
        
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
        favouriteProductsCD = (productViewModel?.favoriteProducts)!
        favProducts = []
        for product in favouriteProductsCD {
            
            favProducts.append(FavoriteProducts(id: (product.id)!, body_html: product.body_html!, price: product.price!, scr: product.scr!, title: product.title!, isSelected: false))
        }
        favouriteCollectionView.reloadData()
    }
    
   
    
    @IBAction func addSelectedItemToCart(_ sender: Any) {
           }
   
 
    
   
}





