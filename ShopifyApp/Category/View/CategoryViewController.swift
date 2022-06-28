//
//  CategoryViewController.swift
//  ShopifyApp
//
//  Created by Peter Samir on 20/05/2022.
//

import UIKit
import Floaty
import RxSwift

class CategoryViewController: UIViewController {

    var navigationBar:UINavigationBar?
    let disposeBag = DisposeBag()
    var showList:[Product]?
    var dbList:[Product]?
    let refreshController = UIRefreshControl()
    var viewModel:CategoryViewModelProtocol!
    var itemList: [LineItem] = []
    let queue = OperationQueue()
    static var subProduct:Int = 0
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var toolbar: UIToolbar!
    @IBOutlet weak var networkError: UIImageView!
    var productViewModel : ProductDetailsViewModel?
    @IBOutlet weak var noDataImg: UIImageView!
    @IBOutlet weak var labelNoData: UILabel!
    @IBOutlet weak var sale: UIBarButtonItem!
    @IBOutlet weak var kids: UIBarButtonItem!
    @IBOutlet weak var men: UIBarButtonItem!
    @IBOutlet weak var women: UIBarButtonItem!
    @IBOutlet private weak var fabBtn: Floaty!
    @IBOutlet  weak var categoryCollection: UICollectionView!
    var collectionFlowLayout:UICollectionViewFlowLayout!
    @IBOutlet weak var cartOutlet: UIBarButtonItem!
    @IBOutlet weak var favOutlet: UIBarButtonItem!
    var localDataSource = LocalDataSource(appDelegate: UIApplication.shared.delegate as! AppDelegate)
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
//        getCategory(target: .HomeCategoryProducts)
        if let showList = showList {
            if !showList.isEmpty{
                labelNoData.isHidden = true
                noDataImg.isHidden = true
            }
        }
        categoryCollection.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        Utilities.utilities.checkUserIsLoggedIn { isLoggedIn in
            if isLoggedIn{
                if Utilities.utilities.getUserNote() != "0"{
                    self.getItemsDraft()
                }
                self.favOutlet.setBadge(text: String(describing: self.localDataSource.getCountOfProductInFav()))
            }
            else{
            //    self.cartOutlet.setBadge(text: String("0"))
                self.favOutlet.setBadge(text: String("0"))
            }
        }
    }
    
    @IBAction func cartBtn(){
        Utilities.utilities.checkUserIsLoggedIn { isLoggedIn in
            if isLoggedIn {
                let cartScreen = ShoppingCartVC(nibName: "ShoppingCartVC", bundle: nil)
                self.navigationController?.pushViewController(cartScreen, animated: true)
            }
            else{
                let loginScreen = LoginViewController(nibName:"LoginViewController", bundle: nil)
                 self.navigationController?.pushViewController(loginScreen, animated: true)
            }
        }

    }
    
    @IBAction func navigateToFavorite() {
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
    
    @IBAction func searchBtn() {
        
        let productListVC = AllProductsViewController(nibName: "AllProductsViewController", bundle: nil)
        productListVC.isCommingFromHome = "false"
        self.navigationController?.pushViewController(productListVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.spinner.hidesWhenStopped=true
        self.spinner.startAnimating()
        productViewModel = ProductDetailsViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
        showList = []
        viewModel = CategoryViewModel(network: APIClient())
        setupCollectionView()
        fabBtn.buttonImage = UIImage(named: "sort")
        fabBtn.addItem("Shoes", icon: UIImage(named: "fabShoe")) { [weak self] _ in
            let index = self?.getSelectedIndexInToolBar(type: "SHOES")
            if CategoryViewController.subProduct == 0{
                self?.fabActions(type: "SHOES", subProductIndex: 0, target: .HomeWithProductType(id: "SHOES"))
            }else{
                self?.fabActions(type: "Shoes", subProductIndex: 1, target: .ShoesType(id: index!.ID))}
        }
        
        fabBtn.addItem("T_shirts", icon: UIImage(named: "fabTshirt")) {[weak self] _ in
            let index = self?.getSelectedIndexInToolBar(type: "T_shirts")
            if CategoryViewController.subProduct == 0{
                self?.fabActions(type: "T-SHIRTS", subProductIndex: 0, target: .HomeWithProductType(id: "T-SHIRTS"))
            }else{
                self?.fabActions(type: "T-SHIRTS", subProductIndex: 2, target: .TshirtType(id: index!.ID))}
        }
        
        fabBtn.addItem("Accessories", icon: UIImage(named: "fabAcc")) {[weak self] _ in
            let index = self?.getSelectedIndexInToolBar(type: "Accessories")
            if CategoryViewController.subProduct == 0{
                self?.fabActions(type: "Accessories", subProductIndex: 0, target: .HomeWithProductType(id: "Accessories"))
            }else{
                self?.fabActions(type: "Accessories", subProductIndex: 3, target: .AccecoriesType(id: index!.ID))}
        }
        
        categoryCollection.backgroundView = refreshController
        fabBtn.buttonColor = UIColor.black
        fabBtn.plusColor = UIColor.white
        refreshController.tintColor = UIColor.blue
        refreshController.addTarget(self, action: #selector(getData), for: .valueChanged)
        categoryCollection.addSubview(refreshController)
        
        getCategory(target: .HomeCategoryProducts)
        stopSpinnerIfNoNetwork()
        womenBtnAction()
        menBtnAction()
        kidsBtnAction()
        saleBtnAction()
        setubSearchBar()
    }
    
    func setubSearchBar(){
        searchBar.rx.text.orEmpty.throttle(RxTimeInterval.microseconds(500), scheduler: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .subscribe { result in
                self.viewModel?.searchWithWord(word: result)
            } .disposed(by: disposeBag)
    }

    
    func fabActions(type:String, subProductIndex:Int, target:Endpoints) {
        spinner.startAnimating()
        CategoryViewController.subProduct = subProductIndex
        getCategory(target: target)
//        stopSpinnerIfNoNetwork()
        
    }
    
    @objc func getData(){
//        categoryCollection.setContentOffset(CGPoint(x: 0, y: -150), animated: true)
        spinner.startAnimating()
        getCategory(target: .HomeCategoryProducts)
        refreshController.endRefreshing()
        categoryCollection.reloadData()
        unSelectToolbar()
        CategoryViewController.subProduct = 0
        stopSpinnerIfNoNetwork()
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
                    self.cartOutlet.setBadge(text:String( self.itemList.count))
                }
                self.categoryCollection.reloadData()
                print("get items success ")
            }.disposed(by: disposeBag)
        }
       else{
           self.cartOutlet.setBadge(text: String("0"))

       }
       }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCollectionItemSize()
    }
    
    func setupCollectionView(){
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        let nib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        categoryCollection.register(nib, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
    }
    
    func menBtnAction() {
        men.rx.tap.throttle(RxTimeInterval.seconds(2), latest: false, scheduler: MainScheduler.instance).subscribe {[weak self] _ in
            self?.spinner.startAnimating()
            self?.getCategory(target: .MenCategoryProduct)
            self?.checkHilightedBtnInToolbar(index: 2)
            self?.stopSpinnerIfNoNetwork()
            CategoryViewController.subProduct = 2
        }.disposed(by: disposeBag)
    }
    
    func womenBtnAction(){
        women.rx.tap.throttle(RxTimeInterval.seconds(2), latest: false, scheduler: MainScheduler.instance).subscribe {[weak self] _ in
            self?.spinner.startAnimating()
            self?.getCategory(target: .WomenCategoryProduct)
            self?.checkHilightedBtnInToolbar(index: 1)
            CategoryViewController.subProduct = 1
            self?.stopSpinnerIfNoNetwork()
        }.disposed(by: disposeBag)
    }
    
    func saleBtnAction() {
        sale.rx.tap.throttle(RxTimeInterval.seconds(2), latest: false, scheduler: MainScheduler.instance).subscribe {[weak self] _ in
            self?.spinner.startAnimating()
            self?.getCategory(target: .SaleCategoryProduct)
            self?.checkHilightedBtnInToolbar(index: 4)
            self?.stopSpinnerIfNoNetwork()
            CategoryViewController.subProduct = 4
        }.disposed(by: disposeBag)
    }
    
    func kidsBtnAction() {
        kids.rx.tap.throttle(RxTimeInterval.seconds(2), latest: false, scheduler: MainScheduler.instance).subscribe {[weak self] _ in
            self?.spinner.startAnimating()
            self?.getCategory(target: .KidsCategoryProduct)
            self?.checkHilightedBtnInToolbar(index: 3)
            self?.stopSpinnerIfNoNetwork()
            CategoryViewController.subProduct = 3
        }.disposed(by: disposeBag)
    }
    
    func stopSpinnerIfNoNetwork() {
        DispatchQueue.main.asyncAfter(deadline: .now()+5){
            if self.spinner.isAnimating{
                self.spinner.stopAnimating()
                self.spinner.isHidden = true
                self.categoryCollection.reloadData()
            }
        }
        
    }
    
    func checkHilightedBtnInToolbar(index:Int) {
        switch index{
        case 1:
            women.isSelected = true
            men.isSelected = false
            kids.isSelected = false
            sale.isSelected = false
        case 2:
            women.isSelected = false
            men.isSelected = true
            kids.isSelected = false
            sale.isSelected = false
        case 3:
            women.isSelected = false
            men.isSelected = false
            kids.isSelected = true
            sale.isSelected = false
        case 4:
            women.isSelected = false
            men.isSelected = false
            kids.isSelected = false
            sale.isSelected = true
        default:
            women.isSelected = false
            men.isSelected = false
            kids.isSelected = false
            sale.isSelected = false
        }
    }
    
    func getSelectedIndexInToolBar(type:String)-> categoryID {
        if women.isSelected {
            return .WOMEN
        }else if men.isSelected{
            return .MEN
        }else if kids.isSelected{
            return .KIDS
        }else if sale.isSelected{
            return .SALE
        }
        else{
            return .Home(type: type)
        }
    }
    
    func unSelectToolbar() {
        if women.isSelected {
            women.isSelected = false
        }else if men.isSelected{
            men.isSelected = false
        }else if kids.isSelected{
            kids.isSelected = false
        }else if sale.isSelected{
            sale.isSelected = false
        }
    }
}


