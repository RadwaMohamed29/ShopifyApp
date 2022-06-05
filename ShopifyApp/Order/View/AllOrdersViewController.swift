//
//  AllOrdersViewController.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 04/06/2022.
//

import UIKit
import RxSwift

class AllOrdersViewController: UIViewController {

    var listOfOrders : [Order] = []
    let disBag = DisposeBag()
    @IBOutlet weak var orderCV: UICollectionView!
    var orderViewModel : OrderViewModelProtocol = OrderViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        let orderCell  = UINib(nibName: "OrderCollectionViewCell", bundle: nil)
        orderCV.register(orderCell, forCellWithReuseIdentifier: "orderCell")
        orderCV.dataSource = self
        orderCV.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = "Orders"
        getAllOrders()
    }
    func getAllOrders(){
        do{
            try orderViewModel.getAllOrdersForSpecificCustomer(id: "6432303218917")
            orderViewModel.ordersObservable.subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
                .observe(on: MainScheduler.asyncInstance)
                .subscribe { orders in
                    self.listOfOrders = orders
                    self.orderCV.reloadData()
                } onError: { error in
                    print(error.localizedDescription)
                }.disposed(by: disBag)
        }catch{
            print("cant get orders")
        }
       

    }

}
extension AllOrdersViewController : UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        listOfOrders.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "orderCell", for: indexPath) as! OrderCollectionViewCell
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.cornerRadius = 20
        cell.layer.shadowColor = UIColor.black.cgColor
        cell.date.text = listOfOrders[indexPath.row].createdAt
        cell.price.text = listOfOrders[indexPath.row].totalPrice
        cell.countOfItems.text = "\(listOfOrders[indexPath.row].lineItems.count)"
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width / 1.2
        let availableHieght = view.frame.width/2
        return CGSize(width: availableWidth, height: availableHieght)
    }

    
    
}
