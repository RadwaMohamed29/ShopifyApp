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
class AllProductsViewController: UIViewController {

    var brandName : String?
    var isCommingFromHome :String?
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchProductsCV: UICollectionView!
    var listOfProducts : [Product] = []
    var filtered : [Product] = []
    var productViewModel : ProductDetailsViewModel?
    let disBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Products"
        productViewModel = ProductDetailsViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
        
        let searchProductCell = UINib(nibName: "SearchCollectionViewCell", bundle: nil)
        searchProductsCV.register(searchProductCell, forCellWithReuseIdentifier: "searchCell")
        searchProductsCV.delegate = self
        searchProductsCV.dataSource = self
    
        setubSearchBar()
        if isCommingFromHome == "true" {
            getAllProductsFromApi()
          
        }else{
            
        }
    }
    func getAllProductsFromApi(){
        productViewModel?.getAllProducts()
        productViewModel?.allProductsObservable.subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { products in
                self.listOfProducts = products
                if self.brandName == ""{
                    self.searchProductsCV.reloadData()
                }
                else{
                    switch (self.brandName!){
                case "ADIDAS":
                    self.filterProduct(BrandName: "ADIDAS")
                case "ASICS TIGER":
                    self.filterProduct(BrandName: "ASICS TIGER")
                case "CONVERSE":
                        self.filterProduct(BrandName: "CONVERSE")
                case "DR MARTENS":
                        self.filterProduct(BrandName: "DR MARTENS")
                case "FLEX FIT":
                        self.filterProduct(BrandName: "FLEX FIT")
                case "HERSCHEL":
                        self.filterProduct(BrandName: "HERSCHEL")
                case "NIKE":
                        self.filterProduct(BrandName: "NIKE")
                case "PALLADUIM":
                        self.filterProduct(BrandName: "PALLADUIM")
                case "PUMA":
                        self.filterProduct(BrandName: "PUMA")
                case "SUPRA":
                        self.filterProduct(BrandName: "SUPRA")
                case "TIMBERLAND":
                        self.filterProduct(BrandName: "TIMBERLAND")
                case "VANS":
                        self.filterProduct(BrandName: "VANS")
                default:
                    return
                }
                    
                }
            } onError: { error in
                print(error)
            }.disposed(by: disBag)
    }
    func filterProduct(BrandName: String)  {
        for product in self.listOfProducts {
            if product.vendor == self.brandName!
           {
                self.filtered.append(product)
           }
        }
        self.listOfProducts = self.filtered
        self.searchProductsCV.reloadData()
        
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionViewCell
        
        let url = URL(string: listOfProducts[indexPath.row].image.src)
        let processor = DownsamplingImageProcessor(size: cell.productImage.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 20)
        cell.productImage.kf.indicatorType = .activity
        cell.productImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        cell.productName.text = listOfProducts[indexPath.row].title
        cell.favBtn.tag = indexPath.row
        cell.favBtn.addTarget(self, action: #selector(longPress(recognizer:)), for: .touchUpInside)
        return cell
    }
    
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailsVC = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
        productDetailsVC.productId = listOfProducts[indexPath.row].id
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
    //not finished
    @objc  func showConformDialog(){
        
        
    }
    @objc private func longPress(recognizer: UIButton) {
     
        
        let favouriteAlert = UIAlertController(title: "REMOVE FAVOURITE PRODUCT", message: "Are you sure to remove this product from your favourite list.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Yes", style: .default) { (action) -> Void in
            do{
                try self.productViewModel?.addFavouriteProductToCoreData(product: self.listOfProducts[recognizer.tag], completion: { response in
                    switch response{
                    case true:
                        print("add seuccessfully")
                        recognizer.setImage(UIImage(systemName: "heart.fill"), for : UIControl.State.normal)
                    case false:
                        print("faild to add")
                    }
                    
                })
            }catch let error{
                print(error.localizedDescription)
            }
         
        }
        let cancleAction = UIAlertAction(title: "No", style: .default, handler: nil)
        
        favouriteAlert.addAction(confirmAction)
        favouriteAlert.addAction(cancleAction)
        self.present(favouriteAlert, animated: true, completion: nil)
      }
    
}