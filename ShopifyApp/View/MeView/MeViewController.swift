//
//  MeViewController.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 20/05/2022.
//

import UIKit
import RxSwift

class MeViewController: UIViewController {

    @IBOutlet weak var settingsIcon: UIBarButtonItem!
    var favProducts:[FavoriteProducts] = []
    var orderList : [Order] = []
    var favouriteProductsCD:[FavouriteProduct] = []
    var productViewModel : ProductDetailsViewModel?
    var disBag = DisposeBag()
    var itemList: [LineItem] = []
    var orderViewModel : OrderViewModelProtocol = OrderViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
    var isLoggedIn = false
    var meViewModel = MeViewModel()
    var localDataSource = LocalDataSource(appDelegate: UIApplication.shared.delegate as! AppDelegate)
    @IBOutlet weak var cart: UIBarButtonItem!
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
        settingsIcon.tintColor = UIColor(red: 0.031, green: 0.498, blue: 0.537, alpha: 1.5)
       
    }
    override func viewDidAppear(_ animated: Bool) {
        Utilities.utilities.checkUserIsLoggedIn { isLoggedIn in
            if isLoggedIn{
            self.getItemsDraft()
        }
            else{
                self.cart.setBadge(text: String("0"))

            }
        }
      //  self.cart.setBadge(text:String( self.localDataSource.getCountOfProductInCart()))

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        Utilities.utilities.checkUserIsLoggedIn { isLoggedIn in
            if isLoggedIn {
                self.noUserFound.isHidden = true
                self.userFounView.isHidden = false
                self.userName.text = "\(Utilities.utilities.getCustomerName())"
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
            try orderViewModel.getAllOrdersForSpecificCustomer(id: "\(Utilities.utilities.getCustomerId())")
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
    func getItemsDraft(){
        if Utilities.utilities.getUserNote() != "0" {
            productViewModel?.getItemsDraftOrder(idDraftOrde: Utilities.utilities.getDraftOrder())
            productViewModel?.itemDraftOrderObservable.subscribe(on: ConcurrentDispatchQueueScheduler
                .init(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
            .subscribe{ result in
                self.itemList = result.element?.lineItems ?? []
                DispatchQueue.main.async{
                    self.cart.setBadge(text:String( self.itemList.count))
                }
             //   self.orderList.reloadData()
                print("get items success ")
            }.disposed(by: disBag)
        }
        else{
            self.cart.setBadge(text: String("0"))

        }
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
                let cartScreen = ShoppingCartVC(nibName: "ShoppingCartVC", bundle: nil)
                self.navigationController?.pushViewController(cartScreen, animated: true)
    }
    @IBAction func gotoSetting(_ sender: Any) {
        let settingsScreen = SettingsVC(nibName: "SettingsVC", bundle: nil)
        self.navigationController?.pushViewController(settingsScreen, animated: true)
        
    }
    
    @IBAction func gotoOrdersScreens(_ sender: Any) {
        let OrdersVC = AllOrdersViewController(nibName: "AllOrdersViewController", bundle: nil)
        self.navigationController?.pushViewController(OrdersVC, animated: true)
    }
    @IBAction func gotoFavoriteScreen(_ sender: Any) {
                let favScreen = FavouriteViewController(nibName: "FavouriteViewController", bundle: nil)
                self.navigationController?.pushViewController(favScreen, animated: true)
        }
    
}



