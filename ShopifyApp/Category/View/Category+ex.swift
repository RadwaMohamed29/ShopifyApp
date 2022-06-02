//
//  Category+ex.swift
//  ShopifyApp
//
//  Created by Peter Samir on 22/05/2022.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import Kingfisher

struct Items{
    var name:String
}
extension CategoryViewController:UICollectionViewDelegate, UICollectionViewDataSource, SharedProtocol{
    func presentAlert(alert: UIAlertController) {
        self.present(alert, animated: true, completion: nil)
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return showList?.count ?? 0
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        let url = URL(string: showList?[indexPath.row].image.src ?? "")
        cell.imgView.kf.setImage(with: url)
        cell.label.text = showList?[indexPath.row].title
        cell.layer.cornerRadius = 12
        cell.label.shadowColor = UIColor.gray
        cell.topView.layer.cornerRadius =  24
//        cell.btnAddToFav.tag = indexPath.row
//        cell.btnAddToFav.addTarget(self, action: #selector(longPress(recognizer:)), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productDetailsVC = ProductDetailsViewController(nibName: "ProductDetailsViewController", bundle: nil)
        productDetailsVC.productId = "\(showList![indexPath.row].id)"
        self.navigationController?.pushViewController(productDetailsVC, animated: true)
    }
    
    func setNavigationItem() {
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "heart"), style: .plain, target: self, action: #selector(heartTapped))
    }
    
    @objc func heartTapped(){
        
    }
    
    func getCategory(target:Endpoints){
        viewModel.getFilteredProducts(target: target)
        viewModel.categoryObservable.subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background)).observe(on: MainScheduler.instance)
            .subscribe { [weak self]result in
                self?.showList = result
                self?.categoryCollection.reloadData()
                if CategoryViewController.subProduct == 1{
                    self?.checkListSize(productName: "SHOES")
                }else if CategoryViewController.subProduct == 2{
                    self?.checkListSize(productName: "T_shirts")
                }else{
                    self?.checkListSize(productName: "accessories")
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
    
    func checkListSize(productName:String) {
        if let list = showList {
            if list.isEmpty == true{
                showNoDataMessage(ProductName: productName, errorMsgHidden: false)
            }else{
                showNoDataMessage(ProductName: productName, errorMsgHidden: true)
                categoryCollection.reloadData()
            }
        }
    }

    func showNoDataMessage(ProductName:String, errorMsgHidden:Bool) {
        
        labelNoData.isHidden = errorMsgHidden //false showed
        noDataImg.isHidden = errorMsgHidden //false
        noDataImg.image = UIImage(named: ProductName)
        categoryCollection.isHidden = !errorMsgHidden //true
        labelNoData.text = "There's No \(ProductName) in This Category"
    }
    
    func setupCollectionItemSize(){
        if collectionFlowLayout == nil{
            let numberOfItemPerRow:CGFloat = 2
            let lineSpacing:CGFloat = 20
            let itemSpacing:CGFloat = 20
            let width = (categoryCollection.frame.width - (numberOfItemPerRow - 1) * itemSpacing) / numberOfItemPerRow
            let height = width
            collectionFlowLayout = UICollectionViewFlowLayout()
            collectionFlowLayout.itemSize = CGSize(width: width, height: height )
            collectionFlowLayout.sectionInset = UIEdgeInsets.zero
            collectionFlowLayout.scrollDirection = .vertical
            collectionFlowLayout.minimumLineSpacing = lineSpacing
            collectionFlowLayout.minimumInteritemSpacing = itemSpacing
            categoryCollection.setCollectionViewLayout(collectionFlowLayout, animated: true)
        }
    }
    
//    @objc private func longPress(recognizer: UIButton) {
//
//        Shared.setOrRemoveProductToFavoriteList(recognizer: recognizer, delegate: UIApplication.shared.delegate as! AppDelegate , listOfProducts: showList, sharedProtocol: self)
//
//      }
}

