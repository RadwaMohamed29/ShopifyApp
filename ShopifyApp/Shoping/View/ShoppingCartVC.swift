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
    var quantityOfProducts : [Product] = []
    let refreshControl = UIRefreshControl()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Cart"
        tableView.register(OrdersTVC.nib(), forCellReuseIdentifier: OrdersTVC.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        productViewModel = ProductDetailsViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
        setCartView()
    }
   @objc func setCartView(){
        if Utilities.utilities.getUserNote() == "0" && flag == false {
            getCartProductsFromCoreData()
        }
        else{
            getCartProductsFromCoreData()
            getItemsDraft()
            UpdateTotalPrice()
        }
        getAllProductsFromApi()
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        checkConnection()
        refreshControl.tintColor = UIColor.darkGray
        refreshControl.addTarget(self, action:#selector(setCartView), for: .valueChanged)
        tableView.addSubview(refreshControl)
    }
    func checkCartIsEmpty(){
        if itemList.isEmpty || CartProducts.isEmpty {
                self.emptyView.isHidden=false
            }
            else{
                self.emptyView.isHidden=true
            }
    }
    override func viewWillDisappear(_ animated: Bool) {
        if !itemList.isEmpty{
            modifyCountOfItem()
        }
    }
     func checkConnection(){
        HandelConnection.handelConnection.checkNetworkConnection { [self] isConnected in
            if isConnected{
                self.flag = true
            }
            else{
                self.flag = false
                self.getCartProductsFromCoreData()
                if emptyView.isHidden == true{
                    self.alertWarning(indexPath:[], title: "information", message: "this is last update")

                }
                
                self.setTotalPrice()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl.endRefreshing()
        }
        
    }

    func showDeleteAlert(indexPath:IndexPath){
        let alert = UIAlertController(title: "Are you sure?", message: "You will remove this item from the cart", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { [self] UIAlertAction in
            if flag == true{
                        self.deleteItemFromCart(indexPath: indexPath)
                        self.deleteItemFromCoreData(index: indexPath)
                    }
            else{
                self.alertWarning(indexPath: indexPath, title: "information", message: "check your connection to detete the item")
            }
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
        if !itemList.isEmpty || !CartProducts.isEmpty{
            let address = AddressViewController(nibName: "AddressViewController", bundle: nil)
            address.itemList = itemList
            address.isComingWithOrder = true
            Utilities.utilities.setTotalPrice(totalPrice: totalPrice )
            self.navigationController?.pushViewController(address, animated: true)
            
        }
    }
}
extension ShoppingCartVC{
    @objc func getItemsDraft(){
        if Utilities.utilities.getUserNote() != "0" {
            productViewModel?.getItemsDraftOrder(idDraftOrde: Utilities.utilities.getDraftOrder())
            productViewModel?.itemDraftOrderObservable.subscribe(on: ConcurrentDispatchQueueScheduler
                .init(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
            .subscribe{ result in
                self.itemList = result.element?.lineItems ?? []
                self.UpdateTotalPrice()
                self.emptyView.isHidden=true
                self.tableView.reloadData()
                print("get items success ")
            }.disposed(by: disposeBag)
        }
        else {
            self.emptyView.isHidden=false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.refreshControl.endRefreshing()
            print("get items success ")

        }
       }
 
    

   func updateCustomerNote(){
           if userDefualt.isLoggedIn(){
                   let editCustomer = EditCustomerRequest(id: userDefualt.getCustomerId(), email: userDefualt.getCustomerEmail(), firstName: userDefualt.getCustomerName(), password: "\(userDefualt.getUserPassword())", note: "0")
                   userDefualt.setUserNote(note: editCustomer.note)
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
               }
           }
       }
   }

   
   func UpdateTotalPrice(){
         totalPrice = 0.0
           for item in itemList {
               if !itemList.isEmpty{
                   totalPrice += Double(item.quantity)*(Double(item.price) ?? 0.0)
                   DispatchQueue.main.async {
                       self.totalLable.text = Shared.formatePrice(priceStr: String(self.totalPrice))

                   }
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
    
    func getAllProductsFromApi(){
        productViewModel?.getAllProducts()
        productViewModel?.allProductsObservable.subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { products in
                self.quantityOfProducts = products
                self.tableView.reloadData()
            } onError: { error in
                print(error)
            }.disposed(by: disposeBag)
    }
}
extension ShoppingCartVC{
    func getCartProductsFromCoreData(){
            do{
                try  productViewModel?.getAllProductsInCart(completion: { response in
                    //MARK: LSA M5LST4
                    switch response{
                    case true:
                        self.emptyView.isHidden=true
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
