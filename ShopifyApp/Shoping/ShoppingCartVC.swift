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
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cart"
        tableView.register(OrdersTVC.nib(), forCellReuseIdentifier: OrdersTVC.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        productViewModel = ProductDetailsViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
        getCartProductsFromCoreData()
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
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
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
        cell.updateSavedCount = {[weak self](count , available,size) in
            if available {
              //  self?.updateCount(productID: Int(self?.CartProducts[indexPath.row].id ?? 1) , count: count)
                self?.getCartProductsFromCoreData()
            }
            else{
                self?.showInfoAlert()
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
