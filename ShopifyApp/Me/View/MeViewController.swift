//
//  MeViewController.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 20/05/2022.
//

import UIKit

class MeViewController: UIViewController {

    var favProducts:[FavoriteProducts] = []
    var favouriteProductsCD:[FavouriteProduct] = []
    var productViewModel : ProductDetailsViewModel?
    
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
        productViewModel = ProductDetailsViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
       
    }

    override func viewWillAppear(_ animated: Bool) {
            noUserFound.isHidden = false
        getFavoriteProductsFromCoreData()
        
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
        let cartScreen = ShoppingCartVC(nibName: "ShoppingCartVC", bundle: nil)
        self.navigationController?.pushViewController(cartScreen, animated: true)
    }
    @IBAction func gotoSetting(_ sender: Any) {
        
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



