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
        
        let lpgr = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongPress))
        lpgr.minimumPressDuration = 0.5
        favouriteCollectionView.addGestureRecognizer(lpgr)
        let favProductCell = UINib(nibName: "FavouriteCollectionViewCell", bundle: nil)
        favouriteCollectionView.register(favProductCell, forCellWithReuseIdentifier: "FavouriteproductCell")
        favouriteCollectionView.delegate = self
        favouriteCollectionView.dataSource = self
        getFavoriteProductsFromCoreData()
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
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
        
        for product in listOfSelectedProducts{
            var product = product
            productViewModel?.checkProductInCart(id: "\(product.id )")
            guard let inCart = productViewModel?.isProductInCart else{return}
            if(inCart){
                let alert = UIAlertController(title: "Already In Cart!", message: "Some of selected is in Cart!. if you need to increase the amount of product , you can do it from your cart ", preferredStyle: .alert)
                let okBtn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okBtn)
                self.present(alert, animated: true, completion: nil)
                
                print("alert \(inCart)")
            }else{
                getProduct(productId: "\(product.id )") { result in
                    if result {
                        if Utilities.utilities.getUserNote() == "0"{
                            self.postDraftOrder()
                            DispatchQueue.main.asyncAfter(deadline:.now()+2.0){
                                self.updateCustomer()
                                self.showActivityIndicator(indicator: self.indicator, startIndicator: false)
                            }
                        }else{
                            self.getItemsDraft()
                            DispatchQueue.main.asyncAfter(deadline:.now()+2.0){
                                self.editDraftOrder()
                                self.showActivityIndicator(indicator: self.indicator, startIndicator: false)
                            }
                        }
                    }
                }
                do{
                    try productViewModel?.addProductToCoreDataCart(id: "\(product.id)",title:product.title,image:product.scr,price:product.price, itemCount: 1, quantity:1, completion: { _ in})
                }catch let error{
                    print(error.localizedDescription)
                }
                Shared.showMessage(message: "Added To Cart Successfully!", error: false)
            }
            product.isSelected = false
        }
        lastIndex = nil
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
            cell.productImage.layer.borderWidth = 2
            cell.productImage.layer.borderColor = UIColor.systemGreen.cgColor
            countOfSelectedItem = 1
            listOfSelectedProducts.append(favProducts[indexPath.row])
            favProducts[indexPath.row].isSelected =  true
            if lastIndex == nil{
                lastIndex = indexPath
            }else{
                favProducts[lastIndex!.row].isSelected =  false
                listOfSelectedProducts.remove(at: 0)
                let cellHash = self.favouriteCollectionView.cellForItem(at: lastIndex!) as! FavouriteCollectionViewCell
                cellHash.productImage.layer.borderWidth = 1
                cellHash.productImage.layer.borderColor = UIColor.lightGray.cgColor
                countOfSelectedItem = 0
                lastIndex = indexPath
            }
        }else{
            let cellHash = self.favouriteCollectionView.cellForItem(at: lastIndex!) as! FavouriteCollectionViewCell
            cellHash.productImage.layer.borderWidth = 1
            cellHash.productImage.layer.borderColor = UIColor.lightGray.cgColor
            countOfSelectedItem = 0
            favProducts[indexPath.row].isSelected = false
            listOfSelectedProducts = []
            lastIndex = nil
//            let numberOfItems = listOfSelectedProducts.count
//            for i in 0..<numberOfItems{
//                if listOfSelectedProducts[i].id == favProducts[indexPath.row].id{
//                    listOfSelectedProducts.remove(at: i)
//                    favProducts[indexPath.row].isSelected = false
//                    return
//                }
//            }
            
        }
    }
}





