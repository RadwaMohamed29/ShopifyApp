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

    let disposeBag = DisposeBag()
    var categoryList:[ProductElement]?
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
        
        categoryList = []
        viewModel = CategoryViewModel(network: APIClient())
        setupCollectionView()
        fabBtn.addItem("Shoes", icon: UIImage(named: "1")) { _ in
            print("floaty 1 pressed")
        }
        fabBtn.addItem("T_shirts", icon: UIImage(named: "jersey")) { _ in
            print("floaty 1 pressed")
        }
        fabBtn.buttonColor = UIColor.black
        fabBtn.plusColor = UIColor.white
        refreshController.tintColor = UIColor.blue
        refreshController.addTarget(self, action: #selector(getData), for: .valueChanged)
        categoryCollection.addSubview(refreshController)
        
        getCategory(target: .HomeCategoryProducts)
        toolbarButtonPressedWithThrottling()
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
    
    
    func toolbarButtonPressedWithThrottling(){
        women.rx.tap.throttle(RxTimeInterval.seconds(5), latest: false, scheduler: MainScheduler.instance).subscribe {[weak self] _ in
            self?.getCategory(target: .WomenCategoryProduct)
            self?.checkHilightedBtnInToolbar(index: 0)
        }.disposed(by: disposeBag)

        men.rx.tap.throttle(RxTimeInterval.seconds(1), latest: false, scheduler: MainScheduler.instance).subscribe {[weak self] _ in
            self?.getCategory(target: .MenCategoryProduct)
            self?.checkHilightedBtnInToolbar(index: 1)
        }.disposed(by: disposeBag)

        kids.rx.tap.throttle(RxTimeInterval.seconds(5), latest: false, scheduler: MainScheduler.instance).subscribe {[weak self] _ in
            self?.getCategory(target: .KidsCategoryProduct)
            self?.checkHilightedBtnInToolbar(index: 2)
        }.disposed(by: disposeBag)

        sale.rx.tap.throttle(RxTimeInterval.seconds(5), latest: false, scheduler: MainScheduler.instance).subscribe {[weak self] _ in
            self?.getCategory(target: .SaleCategoryProduct)
            self?.checkHilightedBtnInToolbar(index: 3)
        }.disposed(by: disposeBag)


    }
    
 
    func checkHilightedBtnInToolbar(index:Int) {
        switch index{
        case 0:
            women.isSelected = true
            men.isSelected = false
            kids.isSelected = false
            sale.isSelected = false
        case 1:
            women.isSelected = false
            men.isSelected = true
            kids.isSelected = false
            sale.isSelected = false
        case 2:
            women.isSelected = false
            men.isSelected = false
            kids.isSelected = true
            sale.isSelected = false
        case 3:
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
    
}


//
//func toolbarButtonPressedWithThrottling(){
//    women.rx.tap.throttle(RxTimeInterval.seconds(1), latest: false, scheduler: MainScheduler.instance).subscribe {[weak self] _ in
//        self?.getCategory(target: .WomenCategoryProduct)
//        self?.checkHilightedBtnInToolbar(index: 0)
//    }.disposed(by: disposeBag)
//
//    men.rx.tap.throttle(RxTimeInterval.seconds(1), latest: false, scheduler: MainScheduler.instance).subscribe {[weak self] _ in
//        self?.getCategory(target: .MenCategoryProduct)
//        self?.checkHilightedBtnInToolbar(index: 1)
//    }.disposed(by: disposeBag)
//
//    kids.rx.tap.throttle(RxTimeInterval.seconds(5), latest: false, scheduler: MainScheduler.instance).subscribe {[weak self] _ in
//        self?.getCategory(target: .KidsCategoryProduct)
//        self?.checkHilightedBtnInToolbar(index: 2)
//    }.disposed(by: disposeBag)
//
//    sale.rx.tap.throttle(RxTimeInterval.seconds(5), latest: false, scheduler: MainScheduler.instance).subscribe {[weak self] _ in
//        self?.getCategory(target: .SaleCategoryProduct)
//        self?.checkHilightedBtnInToolbar(index: 3)
//    }.disposed(by: disposeBag)
//
//
//}
