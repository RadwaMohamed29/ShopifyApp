//
//  AllProductsViewController.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 26/05/2022.
//

import UIKit
import Kingfisher
class AllProductsViewController: UIViewController {

    @IBOutlet weak var searchBar: UIToolbar!
    @IBOutlet weak var searchProductsCV: UICollectionView!
    var listOfProducts : [String] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Products"
        let searchProductCell = UINib(nibName: "SearchCollectionViewCell", bundle: nil)
        searchProductsCV.register(searchProductCell, forCellWithReuseIdentifier: "searchCell")
        searchProductsCV.delegate = self
        searchProductsCV.dataSource = self
    }



}

extension AllProductsViewController : UICollectionViewDelegate ,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        20
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "searchCell", for: indexPath) as! SearchCollectionViewCell
        
        let url = URL(string: "https://cdn.shopify.com/s/files/1/0643/6637/9237/products/85cc58608bf138a50036bcfe86a3a362.jpg?v=1652442194")
        let processor = DownsamplingImageProcessor(size: cell.productImage.bounds.size)
                     |> RoundCornerImageProcessor(cornerRadius: 20)
        cell.productImage.kf.indicatorType = .activity
        cell.productImage.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
        
        cell.favBtn.tag = indexPath.row
        cell.favBtn.addTarget(self, action: #selector(showConformDialog), for: .touchUpInside)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.frame.width / 2.4
        let availableHieght = view.frame.width/1.7
        return CGSize(width: availableWidth, height: availableHieght)
    }
    //not finished
    @objc  func showConformDialog(){
        let favouriteAlert = UIAlertController(title: "REMOVE FAVOURITE PRODUCT", message: "Are you sure to remove this product from your favourite list.", preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "Yes", style: .default, handler: nil)
        let cancleAction = UIAlertAction(title: "No", style: .default, handler: nil)
        
        favouriteAlert.addAction(confirmAction)
        favouriteAlert.addAction(cancleAction)
        self.present(favouriteAlert, animated: true, completion: nil)
        
    }
    
}
