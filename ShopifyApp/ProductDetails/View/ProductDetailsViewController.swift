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
import CoreData
class ProductDetailsViewController: UIViewController,SharedProtocol{
    func presentAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var reviewCollectionView: UICollectionView!{
        didSet{
            reviewCollectionView.dataSource = self
            reviewCollectionView.delegate = self
            reviewCollectionView.register(UINib(nibName: "ReviewsCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ReviewsCollectionViewCell")
            
        }
    }
    @IBOutlet weak var reviewsView: UIView!
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var favBtn: UIButton!
    var productId : String?
    @IBOutlet weak var productOPtion: UILabel!
    @IBOutlet weak var productRate: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productTitle: UILabel!
    @IBOutlet weak var collectionContainerView: UIView!
    @IBOutlet weak var imageControl: UIPageControl!
    let userDefualt = Utilities()
    var itemList: [LineItem] = []
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
    let refreshControl = UIRefreshControl()
    var reviewerImage = ["image2","image1","image2","image1"]
    var reviwerName = ["Radwa Mohamed","Peter Samir","Menna Elsayed","Abdelrhman Sayed"]
    var reviewerComment = ["Great! Very nice product! Comfortable in bonus! <3 Thank you to the seller!"
                           ,"Came quite quickly, look great, soft to the touch, a decent such aroma of China is attached"
                           ,"Arrived perfect product great quality I recommend arrived with 05 before"
                           ,"For what I paid are perfect. The product has come a long time before so sincerely thank you seller"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        productViewModel = ProductDetailsViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
        setUpScreen()
        setUpFavButton()
        uiImageView.applyshadowWithCorner(containerView: collectionContainerView, cornerRadious: 0.0)
        uiImageView.applyshadowWithCorner(containerView: reviewsView, cornerRadious: 0.0)
//        updateCustomer()
//        getItemsDraft()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillAppear(animated)
        refreshControl.tintColor = UIColor.darkGray
        refreshControl.addTarget(self, action:#selector(checkConnection), for: .valueChanged)
        viewContainer.addSubview(refreshControl)
        checkConnection()
    }
    
    @objc func checkConnection(){
        HandelConnection.handelConnection.checkNetworkConnection { isConnected in
            if isConnected{
                self.setUpScreen()
            }else{
                
                self.showSnackBar()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.refreshControl.endRefreshing()
            }
        }
    }
    func getItemsDraft(){
        productViewModel?.getItemsDraftOrder(idDraftOrde: userDefualt.getDraftOrder())
        print("itemlistview\(itemList)")
        productViewModel?.itemDraftOrderObservable.subscribe(on: ConcurrentDispatchQueueScheduler
            .init(qos: .background))
        .observe(on: MainScheduler.asyncInstance)
        .subscribe{ result in
            self.itemList = self.productViewModel!.lineItem
           print("self.itemList\( self.itemList)")
            print("get items success")
        }.disposed(by: disposeBag)
    }
    
    func setUpScreen(){
        productViewModel?.getProduct(id: "\(productId ?? "0")")
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
                self.productPrice.text = Shared.formatePrice(priceStr: result.element?.variant[0].price)
                
                self.productCollectionView.reloadData()
                self.sizeTableView.reloadData()
                
            }.disposed(by: disposeBag)
    }
    
    
    func setUpFavButton(){
        productViewModel?.checkFavorite(id: "\(productId ?? "0")")
        if productViewModel?.isFav == true {
            favBtn.setImage(UIImage(systemName: "heart.fill"), for : UIControl.State.normal)
        }else{
            favBtn.setImage(UIImage(systemName: "heart"), for : UIControl.State.normal)
        }
        favBtn.addTarget(self, action: #selector(longPress(recognizer:)), for: .touchUpInside)
    }
    
    
    
    @objc private func longPress(recognizer: UIButton) {
        
        Utilities.utilities.checkUserIsLoggedIn{ [self] isLoggedIn in
            if isLoggedIn {
                let context :NSManagedObjectContext = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
                let entity  = NSEntityDescription.entity(forEntityName: "FavouriteProduct", in: context)
                productViewModel?.checkFavorite(id: productId!)
                var favProduct = FavouriteProduct(entity: entity!, insertInto: context)
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
            }else{
                let cartAlert = UIAlertController(title: title, message: "Please logIn to add your product in favorite", preferredStyle: .alert)
                let loginAction = UIAlertAction(title: "Login", style: .default) { (action) -> Void in
                    let loginScreen = LoginViewController(nibName:"LoginViewController", bundle: nil)
                    self.navigationController?.pushViewController(loginScreen, animated: true)
                    
                }
                let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                cartAlert.addAction(loginAction)
                cartAlert.addAction(cancleAction)
                
                self.presentAlert(alert: cartAlert)
                
            }
            
        }
        
        
    }
    
    func convertToFavouriteModel( favProduct: inout FavouriteProduct,recognizer:UIButton){
        favProduct.id = "\(product?.id ?? 0)"
        favProduct.price = product?.variant[0].price
        favProduct.title = product?.title
        favProduct.body_html = product?.bodyHTML
        favProduct.scr = product?.image.src
        favProduct.customer_id = "\(Utilities.utilities.getCustomerId())"
        
        
    }
    func updateCustomer(){
        if userDefualt.isLoggedIn(){
            if userDefualt.getDraftOrder() != 0{
                let editCustomer = EditCustomerRequest(id: userDefualt.getCustomerId(), email: userDefualt.getCustomerEmail(), firstName: userDefualt.getCustomerName(), password: "\(userDefualt.getUserPassword())", note: "\(userDefualt.getDraftOrder())")
                userDefualt.setUserNote(note: editCustomer.note)
                print("iddddddddd\(userDefualt.getDraftOrder())")
                print("passwordnooooote\(userDefualt.getUserNote())")
                productViewModel?.editCustomer(customer: EditCustomer(customer: editCustomer), customerID: userDefualt.getCustomerId(), completion: { result in
                    switch result{
                    case true:
                        print("note added\(editCustomer.note)")
                    case false:
                        print("note can't add")
                    }
                    
                })
            }
        }
    }

    func postDraftOrder(){
        let quantity = 1
        let variantID = (product?.variant[0].id)!
        let productID = (product?.id)!
        let title = (product?.title)!
        let vendor = (product?.vendor)!
        let price = (product?.variant[0].price)!
        let newItemDraft = LineItemDraftTest(quantity: quantity, variantID: variantID, productID: productID, title: title, vendor: vendor, price: price)
        productViewModel?.postDraftOrder(lineItems: newItemDraft, customerID: Utilities.utilities.getCustomerId() ,completion: { result in
            switch result {
            case true:
                print("add to api ")
            case false:
                print("error to add in api")
            }
            
        })
    }
    func editDraftOrder(){
        let quantity = 1
        let variantID = (product?.variant[0].id)!
        let productID = (product?.id)!
        let title = (product?.title)!
        if userDefualt.isLoggedIn(){
            if userDefualt.getUserNote() != ""{
                itemList = productViewModel!.lineItem
                
                let newItem = LineItem(id: 0, variantID: variantID, productID: productID, title: title, variantTitle: "", vendor: "", quantity: quantity)
                itemList.append(newItem)
                print("itemlist\(itemList.count)")
                let updateDraftOrder = PutOrderRequestTest(draftOrder: ModifyDraftOrderRequestTest(dratOrderId: Int(userDefualt.getDraftOrder()), lineItems: itemList ))
                productViewModel?.editDraftOrder(draftOrder: updateDraftOrder, draftID: userDefualt.getDraftOrder(), completion: { result in
                    switch result {
                    case true:
                        print("update order to api ")
                    case false:
                        print("error to update in api")
                    }
                })
            }
        }
    }
    @IBAction func addToCartBtn(_ sender: Any) {
        Utilities.utilities.checkUserIsLoggedIn {[self] isLoggedIn in
            if isLoggedIn {
                productViewModel?.checkProductInCart(id: "\(productId ?? "")")
                guard let inCart = productViewModel?.isProductInCart else{return}
                
                if(inCart){
                    let alert = UIAlertController(title: "Already In Bag!", message: "if you need to increase the amount of product , you can from your cart ", preferredStyle: .alert)
                    let navigateToCart = UIAlertAction(title: "Cart", style: .default){ (action) -> Void in
                        let cart = ShoppingCartVC(nibName: "ShoppingCartVC", bundle: nil)
                        self.navigationController?.pushViewController(cart, animated: true)
                        
                    }
                    let okBtn = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                    alert.addAction(navigateToCart)
                    alert.addAction(okBtn)
                    self.present(alert, animated: true, completion: nil)
                    
                    print("alert \(inCart)")
                }else{
//                    if userDefualt.getUserNote() != ""{
//                        self.editDraftOrder()
//                    }else{
//                        self.postDraftOrder()
//                    }
                    do{
                        try productViewModel?.addProductToCoreDataCart(id: "\(productId!)",title:(product?.title)!,image:(product?.image.src)!,price:(product?.variant[0].price)!, itemCount: 1, quantity:(product?.variant[0].inventoryQuantity)!, completion: { result in
                            switch result{
                            case true:
                                Shared.showMessage(message: "Added To Cart Successfully!", error: false)
                                print("add to cart \(inCart)")
                                
                            case false :
                                print("faild to add to cart")
                            }
                        })
                        
                    }catch let error{
                        print(error.localizedDescription)
                    }
                }
            }else{
                let cartAlert = UIAlertController(title: title, message: "Please logIn to add your product in cart", preferredStyle: .alert)
                let loginAction = UIAlertAction(title: "Login", style: .default) { (action) -> Void in
                    let loginScreen = LoginViewController(nibName:"LoginViewController", bundle: nil)
                    self.navigationController?.pushViewController(loginScreen, animated: true)
                    
                }
                let cancleAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
                
                
                cartAlert.addAction(loginAction)
                cartAlert.addAction(cancleAction)
                
                self.present(cartAlert, animated: true, completion: nil)
            }
            
        }
        
    }
    
}

extension ProductDetailsViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == reviewCollectionView{
            return 4
        }else{
            return images.count
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == reviewCollectionView{
            let reviewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ReviewsCollectionViewCell", for: indexPath) as! ReviewsCollectionViewCell
            reviewCell.customerImage.image = UIImage(named: self.reviewerImage[indexPath.row])
            reviewCell.customerName.text = self.reviwerName[indexPath.row]
            reviewCell.customerReview.text = self.reviewerComment[indexPath.row]
            return reviewCell
        }else{
            let productImagesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImagesCollectionViewCell", for: indexPath) as! ProductImagesCollectionViewCell
            
            let url = URL(string: self.images[indexPath.row].src)
            productImagesCell.productImage.kf.setImage(with: url)
            self.imageControl.numberOfPages = images.count
            
            return productImagesCell
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == productCollectionView{
            return CGSize(width: productCollectionView.frame.width, height: productCollectionView.frame.height)
        }else{
            return CGSize(width: reviewCollectionView.frame.width, height: reviewCollectionView.frame.height)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
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
