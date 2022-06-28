//
//  AddressViewController.swift
//  ShopifyApp
//
//  Created by Peter Samir on 04/06/2022.
//

import UIKit
import RxSwift
import SwiftMessages
import CoreMedia
import CoreMIDI
import NVActivityIndicatorView

class AddressViewController: UIViewController {
    
    private let refreshController = UIRefreshControl()
    var isComingWithOrder = false
    let userDefault = Utilities()
    let indicator = NVActivityIndicatorView(frame: .zero, type: .ballRotateChase, color: .label, padding: 0)
    @IBOutlet weak var networkView: UIView!
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet weak var noAddressView: UIView!
    @IBOutlet weak var map: UIImageView!
    @IBOutlet weak var btnConfirmAddress: UIButton!
    private var isConn:Bool = false
    private let disposeBag = DisposeBag()
    fileprivate var arr : [Address]!
    var itemList : [LineItem] = []
    fileprivate var viewModel:AddressViewModelProtocol!
    @IBOutlet weak var addressTableView: UITableView!
    var addrressID: String = ""
    var adress : Address?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTable()
        viewModel = AddressViewModel(network: APIClient())
        addressTableView.separatorStyle = .none
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "ADD", style: .done, target: self, action: #selector(addAddress))
        arr = []
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(mapTapped))
        map.addGestureRecognizer(gesture)
        refreshController.addTarget(self, action: #selector(pullToRefresh), for: .valueChanged)
        scrollView.addSubview(refreshController)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        checkNetwork()
        if isComingWithOrder {
            btnConfirmAddress.isHidden = false
        }else{
            btnConfirmAddress.isHidden = true
        }
    }
        
    @objc func pullToRefresh(){
        refreshController.beginRefreshing()
        checkNetwork()
        DispatchQueue.main.asyncAfter(deadline: .now()+5) { 
            if self.refreshController.isRefreshing{
                self.refreshController.endRefreshing()
            }
        }
        
    }
    
    @objc func mapTapped(){
        let map = MapViewController(nibName: "MapViewController", bundle: nil)
        self.navigationController?.pushViewController(map, animated: true)
    }
    
    func checkNetwork() {
        viewModel.checkConnection()
        viewModel.networkObservable.subscribe {[weak self] isConn in
            self?.isConn = isConn
            if isConn == false{
                self?.networkView.isHidden = false
            }else{
                self?.networkView.isHidden = true
                let id:String = String((self?.userDefault.getCustomerId())!)
                self?.getAddresses(id: id)
            }
        } onError: { error in
            print("connection error network")
        } onCompleted: {
            print("onComplete network")
        } onDisposed: {
            print("ondispose network")
        }.disposed(by: disposeBag)

    }
    
    @IBAction func btnFromMAp(_ sender: Any) {
        mapTapped()
    }
    
    func getAddresses(id:String) {
        viewModel.getAddressesForCurrentUser(id: id)
        viewModel.addressObservable.subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background)).observe(on: MainScheduler.instance).subscribe { [weak self]result in
            guard let self = self else {return}
            self.arr = result
            if self.arr?.count == 0{
                self.addressTableView.isHidden = true
                self.noAddressView.isHidden = false
            }else{
                self.noAddressView.isHidden = true
                self.addressTableView.isHidden = false
                self.addressTableView.reloadData()
                if self.refreshController.isRefreshing{self.refreshController.endRefreshing()}
            }
        } onError: { error in
            //MARK: show Dialog
            print("\(error)")
        } onCompleted: {
            print("completed")
        } onDisposed: {
            print("disposed")
        }.disposed(by: disposeBag)

    }
    
    @IBAction func btnAddAddress(_ sender: Any) {
        addAddress()
    }
    
    @IBAction func confirmAdress(_ sender: Any) {
        if arr.count > 0{
            let checkoutVC = CheckoutViewController(nibName: "CheckoutViewController", bundle: nil)
            checkoutVC.itemList = itemList
            if adress == nil{
                adress = arr[0]
            }
            checkoutVC.adress = adress
            self.navigationController?.pushViewController(checkoutVC, animated: true)
        }
        else{
            let alert = UIAlertController(title: "Address", message: "please add address to continue", preferredStyle: .alert)
            let cancle = UIAlertAction(title: "Cancle", style: .cancel)
            alert.addAction(cancle)
            self.present(alert, animated: true, completion: nil)
            
        }
       
    }
    
}


extension AddressViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arr.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCellTableViewCell", for: indexPath ) as! AddressCellTableViewCell
        let index = arr[indexPath.row]
        cell.labelAddress.text = "\(index.address2 ?? "") st, \(index.city ?? ""), \(index.country ?? "")"
        cell.backgroundColor = UIColor.white
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.green
        cell.selectedBackgroundView = backgroundView
//                cell.layer.borderWidth = 1
        cell.deleteAddressByBottun = {[weak self] in
            self?.showAlert(indexPath: indexPath)
            }
        cell.editAddressFromBtn = { [weak self] in
            guard let self = self else {return}
            self.editAddress(indexPath: indexPath)
        }
                return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        adress = arr[indexPath.row]
        
    }
    func addChildViewController(addressVC:UIViewController){
        
        view.addSubview(addressVC.view)
        addressVC.didMove(toParent: self)
    }

    func displayVC(content:UIViewController) {
        addChild(content)
        self.view.addSubview(content.view)
        content.didMove(toParent: self)
    }
    
    func showAlert(indexPath: IndexPath){
        if indexPath.row == 0{
            let alert = UIAlertController(title: title, message: "Sorry defualt address can not be deleted!", preferredStyle: .alert)
            let okBtn = UIAlertAction(title: "OK", style: .destructive, handler: nil)
            alert.addAction(okBtn)
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Are you sure?", message: "You will remove this address", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { [self] UIAlertAction in
                deleteAddress(indexPath: indexPath)
       
            }))
            self.present(alert, animated: true, completion: nil)
        }
     
    }
    
    
    func setupTable() {
        addressTableView.delegate = self
        addressTableView.dataSource = self
        let nib = UINib(nibName: "AddressCellTableViewCell", bundle: nil)
        addressTableView.register(nib, forCellReuseIdentifier: "AddressCellTableViewCell")
    }
    
    @objc func addAddress() {
        print("add pressed")
        let post = PostAddressViewController(nibName: "PostAddressViewController", bundle: nil)
        self.navigationController?.pushViewController(post, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func deleteAddress(indexPath: IndexPath){
        if addressTableView.indexPathForSelectedRow == indexPath {
            adress = arr[0]
        }
            self.viewModel.deleteAddress(addressID: String(self.arr[indexPath.row].id!) , customerID: String((self.userDefault.getCustomerId())))
            print(String(self.arr[indexPath.row].id!))
            self.checkNetwork()
            adress = nil
            print("deleting")
      
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { action, _, handler in
            self.showAlert(indexPath: indexPath)
        }
        let edit = UIContextualAction(style: .normal, title: "Edit") { [weak self] action, _, handler in
            guard let self = self else {return}
            self.editAddress(indexPath: indexPath)
        }
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
    
    func editAddress(indexPath:IndexPath) {
        let edit = PostAddressViewController(nibName: "PostAddressViewController", bundle: nil)
        edit.isEdit = true
        edit.phone = arr[indexPath.row].phone
        edit.streetName = arr[indexPath.row].address2
        edit.cityName = arr[indexPath.row].city
        edit.country = arr[indexPath.row].country
        edit.addressID = arr[indexPath.row].id
        navigationController?.pushViewController(edit, animated: true)
    }
}
