//
//  ProductDetailsViewController.swift
//  ShopifyApp
//
//  Created by Radwa on 22/05/2022.
//

import UIKit

class ProductDetailsViewController: UIViewController{

    
    @IBOutlet weak var sizeTableView: UITableView!{
        didSet{
            sizeTableView.dataSource = self
            sizeTableView.delegate = self
            productCollectionView.register(UINib(nibName: "SizeTableViewCell", bundle: nil), forCellWithReuseIdentifier: "SizeTableViewCell")
            
        }
    }
    
    @IBOutlet weak var productCollectionView: UICollectionView!{
        didSet{
            productCollectionView.dataSource = self
            productCollectionView.delegate = self
            productCollectionView.register(UINib(nibName: "ProductImagesCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ProductImagesCollectionViewCell")
        }
    }
    let images = [UIImage(named: "p2"),UIImage(named: "p2"),UIImage(named: "p2")]
    let sizes = ["2x2","5x8","9x"]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupImageCollection()
        // Do any additional setup after loading the view.
    }

     func setupImageCollection(){
       
    }


}

extension ProductDetailsViewController: UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate {
    
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let productImagesCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ProductImagesCollectionViewCell", for: indexPath) as! ProductImagesCollectionViewCell
        productImagesCell.productImage.image = images[indexPath.row]
        return productImagesCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: productCollectionView.frame.width, height: productCollectionView.frame.height)
    }
}

extension ProductDetailsViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sizes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let sizesCell = sizeTableView.dequeueReusableCell(withIdentifier: "SizeTableViewCell", for: indexPath) as! SizeTableViewCell
        sizesCell.sixe.text = sizes[indexPath.row]
        return sizesCell
    }
    
    
}
