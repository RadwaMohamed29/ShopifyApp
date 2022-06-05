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

class AddressViewController: UIViewController {

    @IBOutlet weak var noAddressView: UIView!
    private var isConn:Bool = false
    private let disposeBag = DisposeBag()
    fileprivate var arr : [Address]!
    fileprivate var viewModel:AddressViewModelProtocol!
    @IBOutlet weak var addressTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        viewModel = AddressViewModel(network: APIClient())
        addressTableView.separatorStyle = .none
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addAddress))
        arr = []
        checkNetwork()
        //6463260754149
        getAddresses(id: "6463355584741")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
        
    func checkNetwork() {
        viewModel.checkConnection()
        viewModel.networkObservable.subscribe {[weak self] isConn in
            self?.isConn = isConn
            if isConn == false{
                self?.showSnackBar()
            }else{
                self?.getAddresses(id: "6463355584741")
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
    
}


extension AddressViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AddressCellTableViewCell", for: indexPath ) as! AddressCellTableViewCell
        let index = arr[indexPath.row]
        cell.labelAddress.text = "\(index.country ?? ""), \(index.city ?? ""), \(index.address1 ?? "")"
        cell.backgroundColor = UIColor.white
                cell.layer.borderColor = UIColor.black.cgColor
                cell.layer.borderWidth = 1
                cell.layer.cornerRadius = 8
                cell.clipsToBounds = true
                return cell
    }
    
    
    
    func setupTable() {
        addressTableView.delegate = self
        addressTableView.dataSource = self
        let nib = UINib(nibName: "AddressCellTableViewCell", bundle: nil)
        addressTableView.register(nib, forCellReuseIdentifier: "AddressCellTableViewCell")
    }
    
    @objc func addAddress() {
        print("add pressed")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let height = self.view.frame.size.height
        return 100
    }
}
