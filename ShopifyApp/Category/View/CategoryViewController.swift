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
    var showList:[ProductElement]?
    var dbList:[Product]?
    let refreshController = UIRefreshControl()
    var viewModel:CategoryViewModelProtocol!
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
            self?.fabActions(type: "Shoes", subProductIndex: 1, target: .ShoesType(id: index!.ID))
        }
        
        fabBtn.addItem("T_shirts", icon: UIImage(named: "fabTshirt")) {[weak self] _ in
            let index = self?.getSelectedIndexInToolBar(type: "T_shirts")
            self?.fabActions(type: "T_shirts", subProductIndex: 2, target: .TshirtType(id: index!.ID))
        }
        
        fabBtn.addItem("Accessories", icon: UIImage(named: "fabAcc")) {[weak self] _ in
            let index = self?.getSelectedIndexInToolBar(type: "Accessories")
            self?.fabActions(type: "Accessories", subProductIndex: 3, target: .AccecoriesType(id: index!.ID))
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
        stopSpinnerIfNoNetwork()
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
        }.disposed(by: disposeBag)
    }
    
    func womenBtnAction(){
        women.rx.tap.throttle(RxTimeInterval.seconds(2), latest: false, scheduler: MainScheduler.instance).subscribe {[weak self] _ in
            self?.spinner.startAnimating()
            self?.getCategory(target: .WomenCategoryProduct)
            self?.checkHilightedBtnInToolbar(index: 1)
            self?.stopSpinnerIfNoNetwork()
        }.disposed(by: disposeBag)
    }
    
    func saleBtnAction() {
        sale.rx.tap.throttle(RxTimeInterval.seconds(2), latest: false, scheduler: MainScheduler.instance).subscribe {[weak self] _ in
            self?.spinner.startAnimating()
            self?.getCategory(target: .SaleCategoryProduct)
            self?.checkHilightedBtnInToolbar(index: 4)
            self?.stopSpinnerIfNoNetwork()
        }.disposed(by: disposeBag)
    }
    
    func kidsBtnAction() {
        kids.rx.tap.throttle(RxTimeInterval.seconds(2), latest: false, scheduler: MainScheduler.instance).subscribe {[weak self] _ in
            self?.spinner.startAnimating()
            self?.getCategory(target: .KidsCategoryProduct)
            self?.checkHilightedBtnInToolbar(index: 3)
            self?.stopSpinnerIfNoNetwork()
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
}



//    func addNavController() {
//        let width = self.view.frame.width
//        navigationBar = UINavigationBar(frame: CGRect(x: 0, y: 30, width: width, height: 10));       self.view.addSubview(navigationBar!)
//        let searchBtn = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(self.cartBtn))
//        navigationItem.title = ""
//        let favoriteBtn = UIBarButtonItem(image: UIImage(systemName: "heart"), style: .done, target: self, action: #selector(selectorX))
//        let cartBtn = UIBarButtonItem(image: UIImage(systemName: "cart"), style: .done, target: self, action: #selector(cartBtn))
//        navigationItem.leftBarButtonItem = searchBtn
//        navigationItem.rightBarButtonItems = [favoriteBtn, cartBtn]
//        navigationBar?.setItems([navigationItem], animated: false)
//    }
