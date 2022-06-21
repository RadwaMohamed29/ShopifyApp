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
class ShoppingCartVC: UIViewController {
    @IBOutlet weak var totalLable: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var emptyView: UIView!
    var productViewModel : ProductDetailsViewModel?
    var localDataSource : LocalDataSource?
    var disBag = DisposeBag()
    var CartProducts : [CartProduct] = []
    var totalPrice:Double?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cart"
        tableView.register(OrdersTVC.nib(), forCellReuseIdentifier: OrdersTVC.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        productViewModel = ProductDetailsViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
        getCartProductsFromCoreData()
        setTotalPrice()
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        checkCartIsEmpty()
    }
    func checkCartIsEmpty(){
        if CartProducts.isEmpty {
            emptyView.isHidden=false
        }
        else{
            emptyView.isHidden=true
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
        return CartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrdersTVC.identifier, for: indexPath) as! OrdersTVC
        let url = URL(string: CartProducts[indexPath.row].image!)
        let processor = DownsamplingImageProcessor(size: cell.productImage.bounds.size)
        cell.productTitle.text=CartProducts[indexPath.row].title
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
        cell.productCount.text = " \(CartProducts[indexPath.row].count)"
        cell.productPrice.text = Shared.formatePrice(priceStr: CartProducts[indexPath.row].price!) 
        cell.deleteFromBagProducts = {[weak self] in
        self?.showDeleteAlert(indexPath: indexPath)
        }
        let id = self.CartProducts[indexPath.row].id!
        var count = Int(self.CartProducts[indexPath.row].count)
        cell.addCount={
            if count == self.CartProducts[indexPath.row].quantity{
              self.alertWarning(indexPath: indexPath, title: "information", message: "this quantity not available")
            }else{
                count+=1
                cell.productCount.text = "\(count)"
                self.updateCount(productID: Int(id)!, count: Int(count))
                self.setTotalPrice()
                cell.subBtn.isEnabled = true
                
            }
              
            
        }
        cell.subCount={
            if (count != 1) {
                cell.subBtn.isEnabled = true
                count-=1
                cell.productCount.text = "\(count)"
                self.updateCount(productID: Int(id)!, count: Int(count))
                self.setTotalPrice()
            }
            else{
                self.alertWarning(indexPath: indexPath, title: "warning", message: "You can't decrease count of item to zero if you want remove it you can it from trash icon")
            }
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
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            showDeleteAlert(indexPath: indexPath)
            
        }
    }
    
    
}
