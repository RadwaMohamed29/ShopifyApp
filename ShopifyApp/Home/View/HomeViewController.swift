//
//  HomeViewController.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 20/05/2022.
//

import UIKit
import RxSwift
class HomeViewController: UIViewController,brandIdProtocol {
    @IBOutlet weak var noImageView: UIView!
    @IBOutlet weak var favBtn: UIBarButtonItem!
    @IBOutlet weak var cartBtn: UIBarButtonItem!
    @IBOutlet weak var homeTV: UITableView!
    var productViewModel : ProductDetailsViewModel?
    var items:[LineItem] = []
    var disposeBag = DisposeBag()
    var localDataSource = LocalDataSource(appDelegate: UIApplication.shared.delegate as! AppDelegate)
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        productViewModel = ProductDetailsViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
        BrandTableViewCell.setHome(deleget: self)
        setupTableView()
        getItemsDraft()

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        refreshControl.tintColor = UIColor.darkGray
        refreshControl.addTarget(self, action:#selector(checkConnection), for: .valueChanged)
        homeTV.addSubview(refreshControl)
        Utilities.utilities.checkUserIsLoggedIn { isLoggedIn in
            if isLoggedIn{
                self.cartBtn.setBadge(text: String(describing:self.items.count))
                self.favBtn.setBadge(text: String(describing: self.localDataSource.getCountOfProductInFav()))
            }
            else{
                self.cartBtn.setBadge(text: String("0"))
                self.favBtn.setBadge(text: String("0"))
            }
        }
        checkConnection()

    }
    func setupTableView(){
        homeTV.register(AbsTableViewCell.Nib(), forCellReuseIdentifier: AbsTableViewCell.identifier)
        homeTV.register(BrandTableViewCell.Nib(), forCellReuseIdentifier: BrandTableViewCell.identifier)
        homeTV.delegate = self
        homeTV.dataSource = self
    }
    @IBAction func search(_ sender: Any) {
        goToAllProduct(isCommingFromBrand: "true", brnadId: 0 )

    }

    @IBAction func fav(_ sender: Any) {
        Utilities.utilities.checkUserIsLoggedIn { isLoggedIn in
            if isLoggedIn {
                let favScreen = FavouriteViewController(nibName: "FavouriteViewController", bundle: nil)
                self.navigationController?.pushViewController(favScreen, animated: true)
            }
            else{
                let loginScreen = LoginViewController(nibName:"LoginViewController", bundle: nil)
                 self.navigationController?.pushViewController(loginScreen, animated: true)
            }
        }
    }
    @IBAction func cart(_ sender: Any) {
        Utilities.utilities.checkUserIsLoggedIn { isLoggedIn in
            if isLoggedIn {
                let cartScreen = ShoppingCartVC(nibName:"ShoppingCartVC", bundle: nil)
                cartScreen.itemList = self.items
                 self.navigationController?.pushViewController(cartScreen, animated: true)
            }
            else {
                let a = LoginViewController(nibName:"LoginViewController", bundle: nil)
                 self.navigationController?.pushViewController(a, animated: true)
            }
        }
    }
   
}
extension HomeViewController{
    func transBrandName(brandId: Int) {
        let productListVC = AllProductsViewController(nibName: "AllProductsViewController", bundle: nil)
        productListVC.brandId = brandId
        productListVC.isCommingFromHome = "true"
        self.navigationController?.pushViewController(productListVC, animated: true)
    }
    func goToAllProduct(isCommingFromBrand: String,brnadId: Int){
    let productListVC = AllProductsViewController(nibName: "AllProductsViewController", bundle: nil)
    productListVC.brandId = brnadId
    productListVC.isCommingFromHome = isCommingFromBrand
    self.navigationController?.pushViewController(productListVC, animated: true)
     }
   @objc func checkConnection(){
        HandelConnection.handelConnection.checkNetworkConnection { isConnected in
            if isConnected{
                self.homeTV.isHidden = false
                self.noImageView.isHidden = true
                self.homeTV.reloadData()
            }else{
                self.homeTV.isHidden = true
                self.noImageView.isHidden = false
              //  self.showAlertForInterNetConnection()
                self.showSnackBar()
            }
        }
    }
    func getItemsDraft(){
        productViewModel?.getItemsDraftOrder(idDraftOrde: Utilities.utilities.getDraftOrder())
        productViewModel?.itemDraftOrderObservable.subscribe(on: ConcurrentDispatchQueueScheduler
            .init(qos: .background))
        .observe(on: MainScheduler.asyncInstance)
        .subscribe{ result in
            self.items = self.productViewModel!.lineItem
           print("self.itemList\( self.items)")
            print("get items success ")
        }.disposed(by: disposeBag)
    }
}
extension HomeViewController :UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        switch section{
        case 0:
            rows = 1
        default:
            rows = 1
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let adsCell = tableView.dequeueReusableCell(withIdentifier: AbsTableViewCell.identifier, for: indexPath)
            return adsCell
        default:
        let brandCell = tableView.dequeueReusableCell(withIdentifier: BrandTableViewCell.identifier, for: indexPath) as! BrandTableViewCell
                    return brandCell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = 0.0
        switch indexPath.section{
        case 0:
            height = 210
        default:
            height = view.frame.height * 1.5
        }
        return height
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        switch section{
        case 0:
            title = ""
        default:
            title = ""
        }
        return title
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Verdana", size: 18)
        header.textLabel?.textAlignment = NSTextAlignment.center
        header.textLabel?.textColor = UIColor.label
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        homeTV.deselectRow(at: indexPath, animated: false)
    }
    
}
