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
extension CategoryViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    
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
        //        cell.label.text = imagesList[indexPath.row]
        cell.layer.cornerRadius = 12
        cell.label.shadowColor = UIColor.gray
        cell.topView.layer.cornerRadius =  24
        return cell
    }
    
    func getCategory(target:Endpoints){
        viewModel.getFilteredProducts(target: target)
        viewModel.categoryObservable.subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background)).observe(on: MainScheduler.instance)
            .subscribe { [weak self]result in
                self?.showList = result
                self?.categoryCollection.reloadData()
            } onError: { error in
                //MARK: show Dialog
                print("\(error)")
            } onCompleted: {
                print("completed")
            } onDisposed: {
                print("disposed")
            }.disposed(by: disposeBag)
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
}

