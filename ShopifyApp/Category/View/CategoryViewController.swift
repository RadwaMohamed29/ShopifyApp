//
//  CategoryViewController.swift
//  ShopifyApp
//
//  Created by Peter Samir on 20/05/2022.
//

import UIKit
import Floaty
class CategoryViewController: UIViewController {

    var list = [Items(name: "1"), Items(name: "1"), Items(name: "2"),
              Items(name: "2"), Items(name: "1"), Items(name: "2"), Items(name: "1")]    
  
    
    @IBOutlet private weak var fabBtn: Floaty!
    @IBOutlet  weak var categoryCollection: UICollectionView!
    var collectionFlowLayout:UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        fabBtn.addItem("Shoes", icon: UIImage(named: "1")) { _ in
            print("floaty 1 pressed")
        }
        fabBtn.addItem("T_shirts", icon: UIImage(named: "jersey")) { _ in
            print("floaty 1 pressed")
        }
        fabBtn.buttonColor = UIColor.black
        fabBtn.plusColor = UIColor.white
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupCollectionItemSize()
    }
    
    func setupCollectionView(){
        categoryCollection.delegate = self
        categoryCollection.dataSource = self
        let nib = UINib(nibName: "CategoryCollectionViewCell", bundle: nil)
        categoryCollection.register(nib, forCellWithReuseIdentifier: "CategoryCollectionViewCell")
    }
    
 
}
