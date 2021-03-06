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
    var orderViewModel : OrderViewModelProtocol = OrderViewModel(appDelegate: (UIApplication.shared.delegate as? AppDelegate)!)
    override func viewDidLoad() {
        super.viewDidLoad()
        let orderCell  = UINib(nibName: "OrderCollectionViewCell", bundle: nil)
        orderCV.register(orderCell, forCellWithReuseIdentifier: "orderCell")
        orderCV.dataSource = self
        orderCV.delegate = self
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        super.viewWillAppear(animated)
        self.title = "Orders"
        getAllOrders()
    }
    func getAllOrders(){
        do{
            try orderViewModel.getAllOrdersForSpecificCustomer(id: "\(Utilities.utilities.getCustomerId())")
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
        cell.layer.borderColor = UIColor(red: 0.031, green: 0.498, blue: 0.537, alpha: 1).cgColor
        cell.layer.cornerRadius = 20
        cell.date.text = convertDateFormate(date: listOfOrders[indexPath.row].createdAt)
        cell.price.text = Shared.formatePrice(priceStr: listOfOrders[indexPath.row].tags)
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

    func convertDateFormate(date:String)->String{
       let updatedDate = date.split(separator: "T", maxSplits: 3, omittingEmptySubsequences: true)
        let dated = updatedDate[0]
        let time = updatedDate[1].split(separator: "+", maxSplits: 1, omittingEmptySubsequences: true)[0]
        return "\(dated)        \(time)"
    }
    
}
