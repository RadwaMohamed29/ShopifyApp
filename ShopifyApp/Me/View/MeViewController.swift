//
//  MeViewController.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 20/05/2022.
//

import UIKit
import RxSwift

class MeViewController: UIViewController {

    var favProducts:[FavoriteProducts] = []
    var orderList : [Order] = []
    var favouriteProductsCD:[FavouriteProduct] = []
    var productViewModel : ProductDetailsViewModel?
    var disBag = DisposeBag()
    var orderViewModel : OrderViewModelProtocol = OrderViewModel()
    var isLoggedIn = false
    var meViewModel = MeViewModel()
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var noUserFound: UIView!
    @IBOutlet weak var userFounView: UIView!
    @IBOutlet weak var orderLisCV: UICollectionView!{
        didSet{
            orderLisCV.delegate = self
            orderLisCV.dataSource = self
            
            let orderCell = UINib(nibName: "OrderCollectionViewCell", bundle: nil)
            orderLisCV.register(orderCell, forCellWithReuseIdentifier: "orderCell")
        }
    }
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
        productViewModel = ProductDetailsViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
       
    }

    override func viewWillAppear(_ animated: Bool) {
        Utilities.utilities.checkUserIsLoggedIn { isLoggedIn in
            if isLoggedIn {
                self.noUserFound.isHidden = true
                self.userFounView.isHidden = false
                self.getFavoriteProductsFromCoreData()
                self.getAllOrders()
            }
            else{
                self.noUserFound.isHidden = false
                self.userFounView.isHidden = true
            }
        }
       
    }
    func getAllOrders(){
        do{
            try orderViewModel.getAllOrdersForSpecificCustomer(id: "6432303218917")
            orderViewModel.ordersObservable.subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                .observe(on: MainScheduler.asyncInstance)
                .subscribe { orders in
                    self.orderList = orders
                    self.orderLisCV.reloadData()
                } onError: { error in
                    print(error.localizedDescription)
                }.disposed(by: disBag)
        }catch{
            print("cant get orders")
        }
       

    }
    
    func getFavoriteProductsFromCoreData(){
        do{
            try  productViewModel?.getAllFavoriteProducts(completion: { response in
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
        wishListCV.reloadData()
    }
    
    @IBAction func gotoSignInScreen(_ sender: Any) {
        let signInVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
        self.navigationController?.pushViewController(signInVC, animated: true)
    }
    @IBAction func gotoSignUpScreen(_ sender: Any) {
        let signUpVC = RegisterViewController(nibName: "RegisterViewController", bundle: nil)
        self.navigationController?.pushViewController(signUpVC, animated: true)
    }
    @IBAction func gotoCartScreen(_ sender: Any) {
        Utilities.utilities.checkUserIsLoggedIn { isLoggedIn in
            if isLoggedIn {
                let cartScreen = ShoppingCartVC(nibName: "ShoppingCartVC", bundle: nil)
                self.navigationController?.pushViewController(cartScreen, animated: true)
            }
            else{
                self.userFounView.isHidden = true
                self.noUserFound.isHidden = false
            }
        }
    }
    @IBAction func gotoSetting(_ sender: Any) {
        
    }
    
    @IBAction func gotoOrdersScreens(_ sender: Any) {
        let OrdersVC = AllOrdersViewController(nibName: "AllOrdersViewController", bundle: nil)
        self.navigationController?.pushViewController(OrdersVC, animated: true)
    }
    @IBAction func gotoFavoriteScreen(_ sender: Any) {
        Utilities.utilities.checkUserIsLoggedIn { isLoggedIn in
            if isLoggedIn {
                let favScreen = FavouriteViewController(nibName: "FavouriteViewController", bundle: nil)
                self.navigationController?.pushViewController(favScreen, animated: true)
            }
            else{
                self.userFounView.isHidden = true
                self.noUserFound.isHidden = false
            }
        }

    }
    
}



