//
//  Category+ex.swift
//  ShopifyApp
//
//  Created by Peter Samir on 22/05/2022.
//

import Foundation
import UIKit

struct Items{
    var name:String
}



extension CategoryViewController:UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCollectionViewCell", for: indexPath) as! CategoryCollectionViewCell
        cell.imgView.image = UIImage(named: list[indexPath.row].name)
        cell.label.text = "2500 $"
        cell.layer.cornerRadius = 12
        
        cell.label.shadowColor = UIColor.gray
        cell.topView.layer.cornerRadius =  24
        return cell
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

