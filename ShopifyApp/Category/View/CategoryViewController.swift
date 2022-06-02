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
//        getCategory(target: .HomeCategoryProducts)
        if let showList = showList {
            if !showList.isEmpty{
                labelNoData.isHidden = true
                noDataImg.isHidden = true
            }
        }
    }
    
    @IBAction func cartBtn(){
        let a = ShoppingCartVC(nibName:"ShoppingCartVC", bundle: nil)
         self.navigationController?.pushViewController(a, animated: true)
    }
    
    @IBAction func navigateToFavorite() {
        let a = FavouriteViewController(nibName:"FavouriteViewController", bundle: nil)
         self.navigationController?.pushViewController(a, animated: true)
    }
    
    @IBAction func searchBtn() {
        let productListVC = AllProductsViewController(nibName: "AllProductsViewController", bundle: nil)
        productListVC.isCommingFromHome = "false"
        self.navigationController?.pushViewController(productListVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        toolbar.topAnchor.constraint(equalTo: self.navigationBar!.topAnchor, constant: 20).isActive = true
        
        productViewModel = ProductDetailsViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
        
        showList = []
        dbList = []
        viewModel = CategoryViewModel(network: APIClient())
        setupCollectionView()
        
        fabBtn.addItem("Shoes", icon: UIImage(named: "fabShoe")) { [weak self] _ in
            let index = self?.getSelectedIndexInToolBar(type: "SHOES")
            CategoryViewController.subProduct = 1
            self?.getCategory(target: .ShoesType(id: index!.ID))
        }
        
        fabBtn.addItem("T_shirts", icon: UIImage(named: "fabTshirt")) {[weak self] _ in
            let index = self?.getSelectedIndexInToolBar(type: "T_shirts")
            CategoryViewController.subProduct = 2
            self?.getCategory(target: .TshirtType(id: index!.ID))
        }
        
        fabBtn.addItem("Accessories", icon: UIImage(named: "fabAcc")) {[weak self] _ in
            let index = self?.getSelectedIndexInToolBar(type: "Accessories")
            CategoryViewController.subProduct = 3
            
            self?.getCategory(target: .AccecoriesType(id: index!.ID))
        }
        categoryCollection.backgroundView = refreshController
        fabBtn.buttonColor = UIColor.black
        fabBtn.plusColor = UIColor.white
        refreshController.tintColor = UIColor.blue
        refreshController.addTarget(self, action: #selector(getData), for: .valueChanged)
        categoryCollection.addSubview(refreshController)
        
        checkNetworkAndGetData(target: .HomeCategoryProducts)
        
        womenBtnAction()
        menBtnAction()
        kidsBtnAction()
        saleBtnAction()
    }
    
    func checkNetworkAndGetData(target:Endpoints) {
        HandelConnection.handelConnection.checkNetworkConnection { [weak self] isconn in
            if isconn{
                self?.getCategory(target: target)
            }else{
                self?.showSnackBar()
            }
        }
    }
  
    
    @objc func getData(){
//        categoryCollection.setContentOffset(CGPoint(x: 0, y: -150), animated: true)
        //MARK: will check network and reload data from api
        getCategory(target: .HomeCategoryProducts)
        refreshController.endRefreshing()
        categoryCollection.reloadData()
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
            self?.getCategory(target: .MenCategoryProduct)
            self?.checkHilightedBtnInToolbar(index: 2)
        }.disposed(by: disposeBag)
    }
    
    func womenBtnAction(){
        women.rx.tap.throttle(RxTimeInterval.seconds(2), latest: false, scheduler: MainScheduler.instance).subscribe {[weak self] _ in
            self?.getCategory(target: .WomenCategoryProduct)
            self?.checkHilightedBtnInToolbar(index: 1)
        }.disposed(by: disposeBag)
    }
    
    func saleBtnAction() {
        sale.rx.tap.throttle(RxTimeInterval.seconds(2), latest: false, scheduler: MainScheduler.instance).subscribe {[weak self] _ in
            self?.getCategory(target: .SaleCategoryProduct)
            self?.checkHilightedBtnInToolbar(index: 4)
        }.disposed(by: disposeBag)
    }
    
    func kidsBtnAction() {
        kids.rx.tap.throttle(RxTimeInterval.seconds(2), latest: false, scheduler: MainScheduler.instance).subscribe {[weak self] _ in
            self?.getCategory(target: .KidsCategoryProduct)
            self?.checkHilightedBtnInToolbar(index: 3)
        }.disposed(by: disposeBag)
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
