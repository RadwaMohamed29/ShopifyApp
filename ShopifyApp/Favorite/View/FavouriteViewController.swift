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
class FavouriteViewController: UIViewController,SharedProtocol {
    func presentAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    var countOfSelectedItem = 0
    var disBag = DisposeBag()
    var listOfSelectedProducts:[FavoriteProducts] = []
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
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        lpgr.minimumPressDuration = 0.5
        favouriteCollectionView.addGestureRecognizer(lpgr)
        let favProductCell = UINib(nibName: "FavouriteCollectionViewCell", bundle: nil)
        favouriteCollectionView.register(favProductCell, forCellWithReuseIdentifier: "FavouriteproductCell")
        favouriteCollectionView.delegate = self
        favouriteCollectionView.dataSource = self
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
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
        favProducts = (productViewModel?.favoriteProducts)!
        favouriteCollectionView.reloadData()
    }
    
   
    
    @IBAction func addSelectedItemToCart(_ sender: Any) {
        for product in listOfSelectedProducts{
            var product = product
            productViewModel?.checkProductInCart(id: "\(product.id )")
            guard let inCart = productViewModel?.isProductInCart else{return}
            
            if(inCart){
                let alert = UIAlertController(title: "Already In Bag!", message: "Some of selected is in bag!. if you need to increase the amount of product , you can do it from your bag ", preferredStyle: .alert)
                let okBtn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okBtn)
                self.present(alert, animated: true, completion: nil)
                
                print("alert \(inCart)")
            }else{
                do{
                    try productViewModel?.addProductToCoreDataCart(id: "\(product.id)",title:product.title,image:product.scr,price:product.price, itemCount: 1, completion: { result in
                        switch result{
                        case true:
                            Shared.showMessage(message: "Added To Bag Successfully!", error: false)
                            print("add to cart \(inCart)")
                            
                        case false :
                            print("faild to add to cart")
                        }
                    })
                    
                }catch let error{
                    print(error.localizedDescription)
                }
                
            }
            product.isSelected = false
        }
        
        listOfSelectedProducts = []
        countOfSelectedItem = 0
        favouriteCollectionView.reloadData()
        
    }
   
    @objc func handleLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .ended {
            return
        }
        let p = gesture.location(in: self.favouriteCollectionView)
        
        if let indexPath = self.favouriteCollectionView.indexPathForItem(at: p) {
            selectOrUnselectProduct(indexPath: indexPath)
            // do stuff with the cell
        } else {
            print("couldn't find index path")
        }
    }
    
    func selectOrUnselectProduct(indexPath:IndexPath){
        let cell = self.favouriteCollectionView.cellForItem(at: indexPath) as! FavouriteCollectionViewCell
        if favProducts[indexPath.row].isSelected == false{
            cell.productImage.layer.borderWidth = 1
            countOfSelectedItem += 1
            listOfSelectedProducts.append(favProducts[indexPath.row])
            favProducts[indexPath.row].isSelected =  true
        }else{
            cell.productImage.layer.borderWidth = 0
            countOfSelectedItem -= 1
            let numberOfItems = listOfSelectedProducts.count
            for i in 0..<numberOfItems{
                if listOfSelectedProducts[i].id == favProducts[indexPath.row].id{
                    listOfSelectedProducts.remove(at: i)
                }
            }
            favProducts[indexPath.row].isSelected = false
        }
    }
}





