//
//  AllProductsViewController.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 26/05/2022.
//

import UIKit
import Kingfisher
import RxSwift
import RxCocoa
import CoreData

class AllProductsViewController: UIViewController ,SharedProtocol{
    func presentAlert(alert: UIAlertController) {
        self.present(alert, animated: true,completion: nil)
    }
    
    let refreshControl = UIRefreshControl()
    var brandId: Int?
    var isCommingFromHome :String?
    
    @IBOutlet weak var filterBtn: UIButton!
    @IBOutlet weak var networkView: UIView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchProductsCV: UICollectionView!
    var listOfProducts : [Product] = []
    var filtered : [Product] = []
    var productViewModel : ProductDetailsViewModel?
    let disBag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filterBtn.menu = showDropMenu()
        self.title = "Products"
        productViewModel = ProductDetailsViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
        
        let favProductCell = UINib(nibName: "FavouriteCollectionViewCell", bundle: nil)
        searchProductsCV.register(favProductCell, forCellWithReuseIdentifier: "FavouriteproductCell")
        searchProductsCV.delegate = self
        searchProductsCV.dataSource = self
        setubSearchBar()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        searchProductsCV.reloadData()
        refreshControl.tintColor = UIColor.darkGray
        refreshControl.addTarget(self, action:#selector(getProductsWithCheckingConnection), for: .valueChanged)
        searchProductsCV.addSubview(refreshControl)
        networkView.isHidden = true
        getProductsWithCheckingConnection()
        
    }
    
    
    func getAllProductsFromApi(){
        productViewModel?.getAllProducts()
        productViewModel?.allProductsObservable.subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { products in
                self.listOfProducts = products
                self.searchProductsCV.reloadData()
            } onError: { error in
                print(error)
            }.disposed(by: disBag)
    }
    
    
    func getProductOfBrands(cID:Int){
        productViewModel?.getProductOfBrand(id:  "\(cID)")
        productViewModel?.allProductsObservable.subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { products in
                self.listOfProducts = products
                self.searchProductsCV.reloadData()
            } onError: { error in
                print(error)
            }.disposed(by: disBag)
    }
    
    
    func setubSearchBar(){
        searchBar.rx.text.orEmpty.throttle(RxTimeInterval.microseconds(500), scheduler: MainScheduler.asyncInstance)
            .distinctUntilChanged()
            .subscribe { result in
                self.productViewModel?.searchWithWord(word: result)
            } .disposed(by: disBag)
    }
}



extension AllProductsViewController : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return listOfProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FavouriteproductCell", for: indexPath) as! FavouriteCollectionViewCell
        
        let url = URL(string: listOfProducts[indexPath.row].image.src)
        let processor = DownsamplingImageProcessor(size: cell.productImage.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 20)
        cell.productImage.kf.indicatorType = .activity
        cell.productImage.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        cell.productImage.layer.borderWidth = 1
        cell.productImage.layer.borderColor = UIColor.lightGray.cgColor
        cell.productImage.layer.cornerRadius = 20
        cell.ProductName.text = listOfProducts[indexPath.row].title
        cell.priceOfTheProduct.text = Shared.formatePrice(priceStr: listOfProducts[indexPath.row].variant[0].price)  
        productViewModel?.checkFavorite(id: "\(listOfProducts[indexPath.row].id)")
        if productViewModel?.isFav == true {
            cell.favouriteBtn.setImage(UIImage(systemName: "heart.fill"), for : UIControl.State.normal)
        }else{
            cell.favouriteBtn.setImage(UIImage(systemName: "heart"), for : UIControl.State.normal)
        }
        
        
        cell.favouriteBtn.tag = indexPath.row
        cell.favouriteBtn.addTarget(self, action: #selector(longPress(recognizer:)), for: .touchUpInside)
        return cell
    }
    
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailsVC = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
        productDetailsVC.productId = "\(listOfProducts[indexPath.row].id)"
        print("your id is: \(listOfProducts[indexPath.row].id)")
        self.navigationController?.pushViewController(productDetailsVC, animated: true)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width / 2.4
        let availableHieght = view.frame.width/1.7
        return CGSize(width: availableWidth, height: availableHieght)
    }
   
     
       
    @objc private func longPress(recognizer: UIButton) {
        let context :NSManagedObjectContext = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
        let entity  = NSEntityDescription.entity(forEntityName: "FavouriteProduct", in: context)
         productViewModel?.checkFavorite(id: "\(listOfProducts[recognizer.tag].id)")
        var favProduct = FavouriteProduct(entity: entity!, insertInto: context)
        if (Utilities.utilities.isLoggedIn() == false){
            let signinVC = LoginViewController(nibName: "LoginViewController", bundle: nil)
            self.navigationController?.pushViewController(signinVC, animated: true)
        }else{
            if productViewModel?.isFav == false {
                convertToFavouriteModel(favProduct: &favProduct, recognizer: recognizer)
                do{
                    try context.save()
                    
                }catch let error as NSError{
                     print(error)
                }
                recognizer.setImage(UIImage(systemName: "heart.fill"), for : UIControl.State.normal)
            }
            else{
                convertToFavouriteModel(favProduct: &favProduct, recognizer: recognizer)
                Shared.setOrRemoveProductToFavoriteList(recognizer: recognizer, delegate: UIApplication.shared.delegate as! AppDelegate , product: favProduct , sharedProtocol: self)
            }
        }
    
      }
    
    func convertToFavouriteModel( favProduct: inout FavouriteProduct,recognizer:UIButton){
        favProduct.id = "\(listOfProducts[recognizer.tag].id )"
        favProduct.price = listOfProducts[recognizer.tag].variant[0].price
        favProduct.title = listOfProducts[recognizer.tag].title
        favProduct.body_html = listOfProducts[recognizer.tag].bodyHTML
        favProduct.scr = listOfProducts[recognizer.tag].image.src
        favProduct.customer_id = "\(Utilities.utilities.getCustomerId())"
        
    }
    
    @objc func getProductsWithCheckingConnection(){
         HandelConnection.handelConnection.checkNetworkConnection { [weak self] isConnected in
             if isConnected{
                 self?.searchProductsCV.isHidden = false
                 self?.networkView.isHidden = true
                 self?.checkWichListThatWillPresenting()
                 self?.searchProductsCV.reloadData()
             }else{
                 self?.networkView.isHidden = false
                 self?.searchProductsCV.reloadData()
                 self?.showSnackBar()
             }
             DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                 self?.refreshControl.endRefreshing()
             }
            
         }
     }
    func checkWichListThatWillPresenting(){
        if isCommingFromHome == "true" {
            if brandId == 0 {
                getAllProductsFromApi()
            }
            else{
                getProductOfBrands(cID: brandId!)
            }

        }else{

        }
    }
 
    func showDropMenu() -> UIMenu {
        let menu = UIMenu(title: "", children: [
        
            UIAction(title: "low", subtitle: "price(low to high)",image: UIImage(systemName: "arrow.down.square.fill")?.withTintColor(.systemTeal, renderingMode: .alwaysOriginal), handler: { (_) in
                self.productViewModel?.filterbyPrice(order: "low")
            }),
            UIAction(title: "high",subtitle: "price(high to low)", image: UIImage(systemName: "arrow.up.square.fill")?.withTintColor(.systemOrange, renderingMode: .alwaysOriginal), handler: { (_) in
                self.productViewModel?.filterbyPrice(order: "high")
            })
        ])
        return menu
    }
}

