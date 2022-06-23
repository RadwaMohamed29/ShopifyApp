//
//  ShoppingCartVC.swift
//  ShopifyApp
//
//  Created by Menna on 24/05/2022.
//

import UIKit
import Kingfisher
import RxSwift
import Lottie
import NVActivityIndicatorView
class ShoppingCartVC: UIViewController {
    @IBOutlet weak var totalLable: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    var productViewModel : ProductDetailsViewModel?
    var localDataSource : LocalDataSource?
    var CartProducts : [CartProduct] = []
    var totalPrice:Double?
    var itemList: [LineItem] = []
    var disposeBag = DisposeBag()
    let indicator = NVActivityIndicatorView(frame: .zero, type: .ballRotateChase, color: .label, padding: 0)
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Cart"
        tableView.register(OrdersTVC.nib(), forCellReuseIdentifier: OrdersTVC.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        productViewModel = ProductDetailsViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
        getItemsDraft()
        setTotalPrice()
    }
     func getItemsDraft(){
            productViewModel?.getItemsDraftOrder(idDraftOrde: Utilities.utilities.getDraftOrder())
            productViewModel?.itemDraftOrderObservable.subscribe(on: ConcurrentDispatchQueueScheduler
                .init(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
            .subscribe{ result in
                self.itemList = self.productViewModel!.lineItem
                self.tableView.reloadData()
               print("self.itemList\( self.itemList)")
                print("get items success ")
            }.disposed(by: disposeBag)
        }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        checkCartIsEmpty()
    }
    func checkCartIsEmpty(){
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0)
        {
            if self.itemList.isEmpty {
                self.emptyView.isHidden=false
            }
            else{
                self.emptyView.isHidden=true
            }
        }
    
    }
    func getCartProductsFromCoreData(){
        do{
            try  productViewModel?.getAllProductsInCart(completion: { response in
                //MARK: LSA M5LST4
                switch response{
                case true:
                    print("data retrived successfuly")
                case false:
                    print("data cant't retrieved")
                }
            })
            
        }
        catch let error{
            print(error.localizedDescription)
        }
        CartProducts = (productViewModel?.productsInCart)!
        tableView.reloadData()
        
    }
    
    func deleteItemFromCart(index:Int){
        do{
            try self.productViewModel?.removeProductFromCart(productID: "\(CartProducts[index].id ?? "1")", completionHandler: { response in
                switch response{
                case true:
                    print("remove from cart")
                    self.getCartProductsFromCoreData()
                    self.tableView.reloadData()
                    if self.CartProducts.count == 0 {
                        self.emptyView.isHidden=false
                    }
                case false:
                    print("error in remove")
                }
            })
        }
        catch let error{
            print(error.localizedDescription)
        }
    }
    func setTotalPrice(){
        do{
            try productViewModel?.updatePrice(completion: { totalPrice in
                guard let totalPrice = totalPrice else { return }
                self.totalPrice = totalPrice
                Utilities.utilities.setTotalPrice(totalPrice:self.totalPrice ?? 0)
                self.totalLable.text = Shared.formatePrice(priceStr: String(totalPrice))
                print(totalPrice)
                })
        }catch let error{
            print(error.localizedDescription)
        }
    }
   @objc func updateCount(productID : Int , count : Int) {
        do{
            try  productViewModel?.updateCount(productID: productID, count: count, completionHandler: { response in
                //MARK: LSA M5LST4
                switch response{
                case true:
                    print("data updated successfuly")
                case false:
                    print("data cant't update")
                }
            })
        }
        catch let error{
            print(error.localizedDescription)
        }
    }
    
    func showDeleteAlert(indexPath:IndexPath){
        let alert = UIAlertController(title: "Are you sure?", message: "You will remove this item from the cart", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { [self] UIAlertAction in
            self.deleteItemFromCart(index: indexPath.row)
            self.setTotalPrice()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func alertWarning(indexPath:IndexPath,title:String,message:String){
        let alert = UIAlertController(title:title , message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
        self.present(alert, animated: true, completion: nil)
    }

    @IBAction func goToAddress(_ sender: Any) {
        let address = AddressViewController(nibName: "AddressViewController", bundle: nil)
        address.cartProducts = CartProducts
        address.isComingWithOrder = true
        Utilities.utilities.setTotalPrice(totalPrice: totalPrice ?? 0)
        self.navigationController?.pushViewController(address, animated: true)
    }
    
    
}
extension ShoppingCartVC :UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("counnnnnt\(itemList.count)")
        return itemList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrdersTVC.identifier, for: indexPath) as! OrdersTVC
        DispatchQueue.main.asyncAfter(deadline: .now()+1.15)
        {
            self.showActivityIndicator(indicator: self.indicator, startIndicator: false)
            let item = self.itemList[indexPath.row]
            cell.updateUI(item: item)
        }
     
        return cell
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let detalisVC = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
        detalisVC.productId = String(itemList[indexPath.row].productID)
        self.navigationController?.pushViewController(detalisVC, animated: true)
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showDeleteAlert(indexPath: indexPath)
            
        }
    }
    
    
}