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

    let userDefault = Utilities()
    let indicator = NVActivityIndicatorView(frame: .zero, type: .ballRotateChase, color: .label, padding: 0)
    @IBOutlet weak var noAddressView: UIView!
    private var isConn:Bool = false
    private let disposeBag = DisposeBag()
    fileprivate var arr : [Address]!
    var cartProducts : [CartProduct] = []
    fileprivate var viewModel:AddressViewModelProtocol!
    @IBOutlet weak var addressTableView: UITableView!
    var addrressID: String = ""
    var adress : Address?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        viewModel = AddressViewModel(network: APIClient())
        addressTableView.separatorStyle = .none
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAddress))
        arr = []
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        checkNetwork()
    }
        
    func checkNetwork() {
        viewModel.checkConnection()
        viewModel.networkObservable.subscribe {[weak self] isConn in
            self?.isConn = isConn
            if isConn == false{
                self?.showSnackBar()
            }else{
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
    
    func getAddresses(id:String) {
        viewModel.getAddressesForCurrentUser(id: id)
        viewModel.addressObservable.subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background)).observe(on: MainScheduler.instance).subscribe { [weak self]result in
            self?.arr = result
            if self?.arr?.count == 0{
                self?.addressTableView.isHidden = true
                self?.noAddressView.isHidden = false
            }else{
                self?.noAddressView.isHidden = true
                self?.addressTableView.isHidden = false
                self?.addressTableView.reloadData()
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
    override func addChild(_ childController: UIViewController) {
        
    }
    
    @IBAction func confirmAdress(_ sender: Any) {
        let checkoutVC = CheckoutViewController(nibName: "CheckoutViewController", bundle: nil)
        checkoutVC.cartProducts = cartProducts
        checkoutVC.adress = adress
        self.navigationController?.pushViewController(checkoutVC, animated: true)
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
                cell.layer.borderWidth = 1
        cell.deleteAddressByBottun = {[weak self] in
            self?.showAlert(indexPath: indexPath)
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
            let okBtn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okBtn)
            self.present(alert, animated: true, completion: nil)
        }else{
            let alert = UIAlertController(title: "Are you sure?", message: "You will remove this address", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .destructive, handler: { [self] UIAlertAction in
                deleteAddress(indexPath: indexPath)
       
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
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
            self.viewModel.deleteAddress(addressID: String(self.arr[indexPath.row].id!) , customerID: String((self.userDefault.getCustomerId())))
            print(String(self.arr[indexPath.row].id!))
            self.checkNetwork()
            print("deleting")
      
        
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let delete = UIContextualAction(style: .destructive, title: "Delete") { action, _, handler in
            self.showAlert(indexPath: indexPath)
        }
        let edit = UIContextualAction(style: .normal, title: "Edit") { [weak self] action, _, handler in
            let edit = PostAddressViewController(nibName: "PostAddressViewController", bundle: nil)
            edit.isEdit = true
            edit.phone = self?.arr[indexPath.row].phone
            edit.streetName = self?.arr[indexPath.row].address2
            edit.cityName = self?.arr[indexPath.row].city
            edit.country = self?.arr[indexPath.row].country
            edit.addressID = self?.arr[indexPath.row].id
            self?.navigationController?.pushViewController(edit, animated: true)
        }
        return UISwipeActionsConfiguration(actions: [delete, edit])
    }
}
