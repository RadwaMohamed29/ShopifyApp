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
    var draftOrderViewModel : DraftOrderViewModel?
    var localDataSource : LocalDataSource?
    var CartProducts : [CartProduct] = []
    var totalPrice=0.0
    var itemList: [LineItem] = []
    var disposeBag = DisposeBag()
    let indicator = NVActivityIndicatorView(frame: .zero, type: .ballRotateChase, color: .label, padding: 0)
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.title = "Cart"
        tableView.register(OrdersTVC.nib(), forCellReuseIdentifier: OrdersTVC.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        draftOrderViewModel = DraftOrderViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
        productViewModel = ProductDetailsViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
        if Utilities.utilities.getUserNote() == "0" {
            self.emptyView.isHidden=false
        }
        else{
            getItemsDraft()
            self.emptyView.isHidden=true
        }
        UpdateTotalPrice()
        
    }
     func getItemsDraft(){
         if Utilities.utilities.getUserNote() != "0" {
             productViewModel?.getItemsDraftOrder(idDraftOrde: Utilities.utilities.getDraftOrder())
             productViewModel?.itemDraftOrderObservable.subscribe(on: ConcurrentDispatchQueueScheduler
                 .init(qos: .background))
             .observe(on: MainScheduler.asyncInstance)
             .subscribe{ result in
                 self.itemList = self.productViewModel!.lineItem
                 self.tableView.reloadData()
                 print("get items success ")
             }.disposed(by: disposeBag)
         }
         else {
             self.emptyView.isHidden=false
         }
        }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    func deleteItemFromCart(index:Int){
        do{
            try self.productViewModel?.removeProductFromCart(productID: "\(CartProducts[index].id ?? "1")", completionHandler: { response in
                switch response{
                case true:
                    print("remove from cart")
                   //self.getCartProductsFromCoreData()
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
    func UpdateTotalPrice(){
//        DispatchQueue.main.asyncAfter(deadline: .now()+1.0)
//        {
//            self.productViewModel?.setTotalPriceFromApi(completion: { result in
//            self.totalPrice = self.productViewModel!.totalPrice
//            print("priceVM\(self.totalPrice )")
//            Utilities.utilities.setTotalPrice(totalPrice: self.totalPrice)
//            print("utilities.getTotalPric\(Utilities.utilities.getTotalPrice())")
//            DispatchQueue.main.async {
//            self.totalLable.text = "\(Double(self.totalPrice))"
//
//             }
//          })
//        }
              //  print("lineItemPriceee\(itemList)")
        DispatchQueue.main.asyncAfter(deadline: .now()+1.0)
        {
            print("countItem\(self.itemList[0].quantity)")
            for item in self.itemList{
                    self.totalPrice += Double(item.quantity) * (Double(item.price) ?? 0.0)
                print("totalPrice\(self.totalPrice)")
            }
            Utilities.utilities.setTotalPrice(totalPrice: self.totalPrice)
            print("utilities.getTotalPric\(Utilities.utilities.getTotalPrice())")
            DispatchQueue.main.async {
                self.totalLable.text = "\(Double(self.totalPrice))"
            }
        }
    }
    func modifyCountOfItem(count:Int){
        let variantID = itemList[0].variantID
        let productID = itemList[0].productID
        let title = itemList[0].title
        let price = itemList[0].price
        let newItem = LineItem(id: 0, variantID: variantID, productID: productID, title: title, vendor: "", quantity:count, price: price)
        let updateDraftOrder = PutOrderRequestTest(draftOrder: ModifyDraftOrderRequestTest(dratOrderId: Int(Utilities.utilities.getDraftOrder()), lineItems: [newItem] ))
        productViewModel?.editDraftOrder(draftOrder: updateDraftOrder, draftID: Utilities.utilities.getDraftOrder(), completion: { result in
            switch result {
            case true:
                print("update order to api ")
            case false:
                print("error to update in api")
            }
        })
        
    }
    func showDeleteAlert(indexPath:IndexPath){
        let alert = UIAlertController(title: "Are you sure?", message: "You will remove this item from the cart", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { [self] UIAlertAction in
            self.deleteItemFromCart(index: indexPath.row)
          //  self.setTotalPrice()
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
        Utilities.utilities.setTotalPrice(totalPrice: totalPrice )
        self.navigationController?.pushViewController(address, animated: true)
    }
    
    
}
extension ShoppingCartVC :UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemList.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrdersTVC.identifier, for: indexPath) as! OrdersTVC
       
            self.showActivityIndicator(indicator: self.indicator, startIndicator: false)
            let item = self.itemList[indexPath.row]
            cell.updateUI(item: item)
            var count = self.itemList[0].quantity
            cell.addCount={
                count+=1
                cell.productCount.text = "\(count)"
                self.modifyCountOfItem(count: count)
//                self.totalPrice = Double(cell.productCount.text!)! * Double(cell.productPrice.text!)!
//                self.totalLable.text = String(self.totalPrice)
            }
                cell.subCount={
                    if (count != 1) {
                        cell.subBtn.isEnabled = true
                        count-=1
                        cell.productCount.text = "\(count)"
                        self.modifyCountOfItem(count: count)
//                        self.totalPrice = Double(cell.productCount.text!)! * Double(cell.productPrice.text!)!
//                        self.totalLable.text = String(self.totalPrice)
                    }
                    else{
                        self.alertWarning(indexPath: indexPath, title: "warning", message: "can't decrease count of item to zero")
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
