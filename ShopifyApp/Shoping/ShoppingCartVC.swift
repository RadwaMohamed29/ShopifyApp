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
    var CartProducts : [CartModel] = []
    var totalPrice:Double = 0
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
    func setTotalPrice(){
        do{
            try productViewModel?.updatePrice(completion: { totalPrice in
                guard let totalPrice = totalPrice else { return }
                Utilities.utilities.setTotalPrice(totalPrice:totalPrice)
                self.totalLable.text = String(totalPrice) + " $"
                })
        }catch let error{
            print(error.localizedDescription)
        }
    }
//    func updateTotalPrice(price:Double){
//        do{
//            try  productViewModel?.calcTotalPrice(price:price, completionHandler: { response in
//                switch response{
//                case true:
//                    self.CartProducts = (self.productViewModel?.productsInCart)!
//                    let bagProducts = self.CartProducts
//                    for item in bagProducts{
//                    let count = Double(item.count ?? 0)
//                    let price = Double(item.price ?? "0.0")
//                        self.totalPrice += price! * count
//                    }
//                    print("\(self.totalPrice)")
//                      DispatchQueue.main.async {
//                     self.totalLable.text = "\(self.totalPrice) $"
//                    }
//                    print("data updated successfuly")
//                case false:
//                    print("data cant't update")
//                }
//            })
//        }
//        catch let error{
//            print(error.localizedDescription)
//        }
//
//    }

    func updateCount(productID : Int , count : Int) {
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
        cell.productCount.text = " \(CartProducts[indexPath.row].count ?? 2)"
        cell.productPrice.text = "$ \(CartProducts[indexPath.row].price ?? "10")"
        cell.deleteFromBagProducts = {[weak self] in
            self?.showDeleteAlert(indexPath: indexPath)
        }
        cell.addItemQuantity = {[weak self] (count) in
         let id = self?.CartProducts[indexPath.row].id
         self?.updateCount(productID: Int(id!)!, count: count)
         self?.setTotalPrice()
        }
        cell.subItemQuantity = {[weak self] (count) in
            let id = self?.CartProducts[indexPath.row].id
            self?.updateCount(productID: Int(id!)!, count: count)
            self?.setTotalPrice()
     
        }
//        cell.updateSavedCount = {[weak self] (count) in
//
//                let id = self?.CartProducts[indexPath.row].id
//                let price = self?.CartProducts[indexPath.row].price
//                self?.updateCount(productID: Int(id!)!, count: count)
//              self?.updateTotalPrice(price: Double(price ?? "10")!)
//            self?.setTotalPrice()
//
//        }
//        cell.addItemQuantity = {
//            do{
//                let id = self.CartProducts[indexPath.row].id
//                try self.productViewModel?.getCount(productId: Int64(id!)!) { selectedItem in
//                    if selectedItem != nil {
//
//                  //      selectedItem?.count!+=1
//                    }
//                //    self.productViewModel?.localDataSource.saveProductToCoreData(newProduct: <#T##Product#>)
//                   //self.orderViewModel.saveProductToCart()
//                }
//                self.tableView.reloadData()
//                self.setTotalPrice()
//            }catch let error{
//                print(error.localizedDescription)
//            }
//        }
//
//        cell.subItemQuantity = {
//            do{
//            if self.CartProducts[indexPath.row].count! > 1 {
//                let id = self.CartProducts[indexPath.row].id
//               try self.productViewModel?.getCount(productId: Int64(id!)!) { selectedOrder in
//                    if selectedOrder != nil {
//                     //   selectedOrder?.count!-=1
//                    }
//                    //self.orderViewModel.saveProductToCart()
//                }
//            }
//            self.tableView.reloadData()
//            self.setTotalPrice()
//        }catch let error{
//            print(error.localizedDescription)
//        }
//        }
        
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
    func showDeleteAlert(indexPath:IndexPath){
        let alert = UIAlertController(title: "Are you sure?", message: "You will remove this item from the cart", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { [self] UIAlertAction in
            self.deleteItemFromCart(index: indexPath.row)
            self.setTotalPrice()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func showInfoAlert(){
        let alert = UIAlertController(title: "error", message: "Sorry , this product isn't available with this amount", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive))
        self.present(alert, animated: true, completion: nil)
    }

    
}
