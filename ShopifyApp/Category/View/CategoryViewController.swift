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

    static var categoryID:Int = 0
    
    let disposeBag = DisposeBag()
    var showList:[ProductElement]?
    let refreshController = UIRefreshControl()
    var viewModel:CategoryViewModelProtocol!
    
    @IBOutlet weak var sale: UIBarButtonItem!
    @IBOutlet weak var kids: UIBarButtonItem!
    @IBOutlet weak var men: UIBarButtonItem!
    @IBOutlet weak var women: UIBarButtonItem!
    @IBOutlet private weak var fabBtn: Floaty!
    @IBOutlet  weak var categoryCollection: UICollectionView!
    var collectionFlowLayout:UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showList = []
        viewModel = CategoryViewModel(network: APIClient())
        setupCollectionView()
        fabBtn.addItem("Shoes", icon: UIImage(named: "heart")) { [weak self] _ in
            let index = self?.getSelectedIndexInToolBar()
            self?.getCategory(target: .ShoesType(id: index!.ID))
            self?.categoryCollection.reloadData()
        }
        fabBtn.addItem("T_shirts", icon: UIImage(named: "star")) {[weak self] _ in
            let index = self?.getSelectedIndexInToolBar()
            self?.getCategory(target: .TshirtType(id: index!.ID))
            self?.categoryCollection.reloadData()
        }
        fabBtn.addItem("Accecories", icon: UIImage(named: "heart")) {[weak self] _ in
            let index = self?.getSelectedIndexInToolBar()
            self?.getCategory(target: .AccecoriesType(id: index!.ID))
            self?.categoryCollection.reloadData()
        }
        fabBtn.buttonColor = UIColor.black
        fabBtn.plusColor = UIColor.white
        refreshController.tintColor = UIColor.blue
        refreshController.addTarget(self, action: #selector(getData), for: .valueChanged)
        categoryCollection.addSubview(refreshController)
        getCategory(target: .HomeCategoryProducts)
        womenBtnAction()
        menBtnAction()
        kidsBtnAction()
        saleBtnAction()
    }
    
    @objc func getData(){
        //MARK: will check network and reload data from api
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
            self?.categoryCollection.reloadData()
            CategoryViewController.categoryID = 2
        }.disposed(by: disposeBag)
    }
    
    func womenBtnAction(){
        women.rx.tap.throttle(RxTimeInterval.seconds(2), latest: false, scheduler: MainScheduler.instance).subscribe {[weak self] _ in
            self?.getCategory(target: .WomenCategoryProduct)
            self?.checkHilightedBtnInToolbar(index: 1)
            self?.categoryCollection.reloadData()
            CategoryViewController.categoryID = 1
        }.disposed(by: disposeBag)
    }
    
    func saleBtnAction() {
        sale.rx.tap.throttle(RxTimeInterval.seconds(2), latest: false, scheduler: MainScheduler.instance).subscribe {[weak self] _ in
            self?.getCategory(target: .SaleCategoryProduct)
            self?.checkHilightedBtnInToolbar(index: 4)
            self?.categoryCollection.reloadData()
            CategoryViewController.categoryID = 4
        }.disposed(by: disposeBag)
    }
    
    func kidsBtnAction() {
        kids.rx.tap.throttle(RxTimeInterval.seconds(2), latest: false, scheduler: MainScheduler.instance).subscribe {[weak self] _ in
            self?.getCategory(target: .KidsCategoryProduct)
            self?.checkHilightedBtnInToolbar(index: 3)
            self?.categoryCollection.reloadData()
            CategoryViewController.categoryID = 3
        }.disposed(by: disposeBag)
    }
    
    //MARK: remove this method if u get the selected index in toolbar
//    func filterByProduct(product:ProductType) {
//        switch product {
//        case .Tshirts:
//            if CategoryViewController.categoryID == 1{
//                viewModel.getFilteredProducts(target: .WomenCategoryProduct, productTupe: .Tshirts)
//            }
//        case .Accecories:
//            viewModel.getFilteredProducts(target: .WomenCategoryProduct, productTupe: .Accecories)
//        case .Shoes:
//            viewModel.getFilteredProducts(target: .WomenCategoryProduct, productTupe: .Shoes)
//        case .NON:
//            viewModel.getFilteredProducts(target: .WomenCategoryProduct, productTupe: .NON)
//        }
//    }
 
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
    
    func getSelectedIndexInToolBar()->categoryID{
        if women.isSelected {
            return .WOMEN
        }else if men.isSelected{
            return .MEN
        }else if kids.isSelected{
            return .KIDS
        }else if sale.isSelected{
            return .SALE
        }
        return .Home
    }
    
    
}
