//
//  ProductDetailsViewController.swift
//  ShopifyApp
//
//  Created by Radwa on 22/05/2022.
//

import UIKit
import RxSwift
import RxCocoa
import CoreMedia

class ProductDetailsViewController: UIViewController,SharedProtocol{
    func presentAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var favBtn: UIButton!
    var productId : Int?
    @IBOutlet weak var productOPtion: UILabel!
    @IBOutlet weak var productRate: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var collectionContainerView: UIView!
    @IBOutlet weak var imageControl: UIPageControl!
    @IBOutlet weak var productDescription: UITextView!{
        didSet{
            productDescription.isEditable = false
        }
    }
    @IBOutlet weak var sizeTableView: UITableView!{
        didSet{
            sizeTableView.dataSource = self
            sizeTableView.delegate = self
            sizeTableView.register(UINib(nibName: String(describing: SizeTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: SizeTableViewCell.self))
            
        }
    }
    
    @IBOutlet weak var productCollectionView: UICollectionView!{
        didSet{
            productCollectionView.dataSource = self
            productCollectionView.delegate = self
            productCollectionView.register(UINib(nibName: "ProductImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductImagesCollectionViewCell")
        }
    }
    var disposeBag = DisposeBag()
    var images: [Images] = []
    var optionsValue:[String] = []
    var product : Product?
    var uiImageView = UIImageView()
    var productViewModel: ProductDetailsViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productViewModel = ProductDetailsViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
        setUpScreen()
        setUpFavButton()
        uiImageView.applyshadowWithCorner(containerView: collectionContainerView, cornerRadious: 0.0)
    }
    
    func setUpScreen(){
        productViewModel?.getProduct(id: "\(productId ?? 0)")
        productViewModel?.productObservable.subscribe(on: ConcurrentDispatchQueueScheduler
                        .init(qos: .background))
                        .observe(on: MainScheduler.asyncInstance)
                        .subscribe{ [weak self] result in
                guard let self = self else {return}
                            self.product = result.element
                self.productTitle.text = result.element?.title
                self.productDescription.text = result.element?.bodyHTML
                self.images = result.element?.images ?? []
                self.optionsValue = result.element?.options[0].values ?? []
                self.productPrice.text = "$\(String(describing: result.element?.variant[0].price ?? ""))"
                
                self.productCollectionView.reloadData()
                self.sizeTableView.reloadData()
                         
            }.disposed(by: disposeBag)
    }
    
    
    func setUpFavButton(){
        productViewModel?.checkFavorite(id: "\(productId ?? 0)")
       if productViewModel?.isFav == true {
          favBtn.setImage(UIImage(systemName: "heart.fill"), for : UIControl.State.normal)
       }else{
          favBtn.setImage(UIImage(systemName: "heart"), for : UIControl.State.normal)
       }
      // cell.favBtn.tag = indexPath.row
      favBtn.addTarget(self, action: #selector(longPress(recognizer:)), for: .touchUpInside)
    }
    
    
    
 @objc private func longPress(recognizer: UIButton) {
  
     Shared.setOrRemoveProductToFavoriteList(recognizer: recognizer, delegate: UIApplication.shared.delegate as! AppDelegate , listOfProducts: product!, sharedProtocol: self)
    
   }
    
    
    @IBAction func addToCartBtn(_ sender: Any) {
        productViewModel?.checkProductInCart(id: "\(productId ?? 0)")
        guard let inCart = productViewModel?.isProductInCart else{return}
        
        if(inCart){
            let alert = UIAlertController(title: "Already in cart!", message: "if you need to increase the amount of product , you can from your bag ", preferredStyle: .alert)
                    let okBtn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(okBtn)
                    self.present(alert, animated: true, completion: nil)
            
            print("alert \(inCart)")
        }else{
            do{
                try productViewModel?.addProductToCoreDataCart(product: product!, itemCount: 1, completion: { result in
                    switch result{
                    case true:
                        print("add to cart \(inCart)")
                       
                    case false :
                        print("faild to add to cart")
                    }
                })

            }catch let error{
                print(error.localizedDescription)
            }
        }
      
    }
    
}

extension ProductDetailsViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let productImagesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImagesCollectionViewCell", for: indexPath) as! ProductImagesCollectionViewCell
        let url = URL(string: self.images[indexPath.row].src)
        productImagesCell.productImage.kf.setImage(with: url)
        self.imageControl.numberOfPages = images.count
        return productImagesCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: productCollectionView.frame.width, height: productCollectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        imageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}

extension ProductDetailsViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return optionsValue.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sizesCell = sizeTableView.dequeueReusableCell(withIdentifier: "SizeTableViewCell", for: indexPath) as! SizeTableViewCell
        sizesCell.sixe.text = optionsValue[indexPath.row]
        return sizesCell
    }
    
    
    
}
