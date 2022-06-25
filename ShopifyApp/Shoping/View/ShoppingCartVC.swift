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
    var itemList: [LineItem] = []
    var disposeBag = DisposeBag()
    let userDefualt = Utilities()
    let indicator = NVActivityIndicatorView(frame: .zero, type: .ballRotateChase, color: .label, padding: 0)
    var totalPrice=0.0
    var flag:Bool = true
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cart"
        tableView.register(OrdersTVC.nib(), forCellReuseIdentifier: OrdersTVC.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        productViewModel = ProductDetailsViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
        
        if Utilities.utilities.getUserNote() == "0" {
            getCartProductsFromCoreData()
        }
        else{
            getCartProductsFromCoreData()
            getItemsDraft()
            UpdateTotalPrice()
            self.emptyView.isHidden=true
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        checkConnection()
  //      checkCartIsEmpty()
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
    override func viewWillDisappear(_ animated: Bool) {
        modifyCountOfItem()
        
    }
    func checkConnection(){
        HandelConnection.handelConnection.checkNetworkConnection { [self] isConnected in
            if isConnected{
                self.flag = true
            }
            else{
                self.flag = false
                self.getCartProductsFromCoreData()
                self.alertWarning(indexPath:[], title: "information", message: "this is last update")
                self.setTotalPrice()
            }
        }
    }

    func showDeleteAlert(indexPath:IndexPath){
        let alert = UIAlertController(title: "Are you sure?", message: "You will remove this item from the cart", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { [self] UIAlertAction in
                self.deleteItemFromCart(indexPath: indexPath)
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
        address.itemList = itemList
        address.isComingWithOrder = true
        Utilities.utilities.setTotalPrice(totalPrice: totalPrice )
        self.navigationController?.pushViewController(address, animated: true)
    }
    
    
}
extension ShoppingCartVC :UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flag == true{
            return itemList.count
        }
        else {
            return CartProducts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: OrdersTVC.identifier, for: indexPath) as! OrdersTVC
        cell.deleteFromBagProducts = {
            self.showDeleteAlert(indexPath: indexPath)
        }
        if flag == true{    let item = self.itemList[indexPath.row]
            cell.updateUI(item: item)
            var count = self.itemList[indexPath.row].quantity
            let id = self.itemList[indexPath.row].productID

         cell.addCount={ [self] in
                count+=1
                cell.productCount.text = "\(count)"
                self.itemList[indexPath.row].quantity = count
            self.totalPrice += Double(itemList[indexPath.row].price)!
            self.totalLable.text = String(self.totalPrice)
           self.updateCount(productID: id, count: count)
             
                    }
                cell.subCount={
                    if (count != 1) {
                        cell.subBtn.isEnabled = true
                        count-=1
                        cell.productCount.text = "\(count)"
                        self.itemList[indexPath.row].quantity = count
                        self.totalPrice -= Double(self.itemList[indexPath.row].price)!
                        self.totalLable.text = String(self.totalPrice)
                        self.updateCount(productID: id, count: count)

                    }
                   
                }
            
        }
        else {
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
extension ShoppingCartVC{
  
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

   func updateCustomerNote(){
           if userDefualt.isLoggedIn(){
                   let editCustomer = EditCustomerRequest(id: userDefualt.getCustomerId(), email: userDefualt.getCustomerEmail(), firstName: userDefualt.getCustomerName(), password: "\(userDefualt.getUserPassword())", note: "0")
                   userDefualt.setUserNote(note: editCustomer.note)
                   print("iddddddddd\(userDefualt.getDraftOrder())")
                   print("passwordnooooote\(userDefualt.getUserNote())")
                   productViewModel?.editCustomer(customer: EditCustomer(customer: editCustomer), customerID: userDefualt.getCustomerId(), completion: { result in
                       switch result{
                       case true:
                           print("note Deleted\(editCustomer.note)")
                       case false:
                           print("note can't Deleted")
                       }
                       
                   })
       }
       
   }
    func deleteItemFromCart(indexPath:IndexPath){
       ///product details check product in cart a'3mleha 3la api
       print("draftId\(userDefualt.getDraftOrder())")
       if itemList.count == 1{
           productViewModel?.deleteDraftOrder(draftOrderID: userDefualt.getDraftOrder())
           self.emptyView.isHidden=false
           Utilities.utilities.setDraftOrder(id: 0)
           updateCustomerNote()
       }else{
           if userDefualt.isLoggedIn(){
               if userDefualt.getUserNote() != "0"{
                   itemList.remove(at: indexPath.row)
                   tableView.deleteRows(at: [indexPath], with: .fade)
                   tableView.reloadData()
                  
                   let updateDraftOrder = PutOrderRequestTest(draftOrder: ModifyDraftOrderRequestTest(dratOrderId: Int(userDefualt.getDraftOrder()), lineItems: itemList ))
                   productViewModel?.editDraftOrder(draftOrder: updateDraftOrder, draftID: userDefualt.getDraftOrder(), completion: { result in
                       switch result{
                       case true:
                           print("update order to api ")
                           self.UpdateTotalPrice()
           
                       case false:
                           print("error to update in api")
                       }
                       
                   })

                  // self.UpdateTotalPrice()
               }
           }
       }
   }

   
   func UpdateTotalPrice(){
       DispatchQueue.main.asyncAfter(deadline: .now()+1.0)
       { [self] in
         totalPrice = 0.0
           for item in itemList {
               totalPrice += Double(item.quantity)*(Double(item.price) ?? 0.0)
               totalLable.text = String(totalPrice)
       }
      }
   }
   func modifyCountOfItem(){
       let updateDraftOrder = PutOrderRequestTest(draftOrder: ModifyDraftOrderRequestTest(dratOrderId: Int(Utilities.utilities.getDraftOrder()), lineItems: itemList ))
       productViewModel?.editDraftOrder(draftOrder: updateDraftOrder, draftID: Utilities.utilities.getDraftOrder(), completion: { result in
           switch result {
           case true:
               print("update order to api ")
           case false:
               print("error to update in api")
           }
       })
       
   }
}
extension ShoppingCartVC{
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
        func deleteItemFromCoreData(index:IndexPath){
            do{
                try self.productViewModel?.removeProductFromCart(productID: "\(CartProducts[index.row].id ?? "1")", completionHandler: { response in
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
}
