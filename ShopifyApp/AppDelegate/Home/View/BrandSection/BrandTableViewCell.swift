//
//  BrandTableViewCell.swift
//  ShopifyApp
//
//  Created by Menna on 23/05/2022.
//

import UIKit

class BrandTableViewCell: UITableViewCell {

    @IBOutlet weak var brandCollectionView: UICollectionView!
    static let identifier = "BrandTableViewCell"
    static func Nib()-> UINib{
        return UINib(nibName: "BrandTableViewCell", bundle: nil)
    }
    var arrayOfBrands: [UIImage] = []
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
      
        // Initialization code
    }
    func setupCollectionView(){
        brandCollectionView.register(BrandsCollectionViewCell.Nib(), forCellWithReuseIdentifier: BrandsCollectionViewCell.identifier)
        brandCollectionView.delegate = self
        brandCollectionView.dataSource = self
    }
    
}
extension BrandTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandsCollectionViewCell.identifier, for: indexPath) as! BrandsCollectionViewCell
        cell.brandLabel.text = "H&M"
        cell.brandImageView.layer.borderColor = UIColor.gray.cgColor
        cell.brandImageView.layer.borderWidth = 0.5
        cell.brandImageView.layer.cornerRadius = 25
        cell.viewBrandImage.layer.cornerRadius = 25
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width * 0.43, height: self.frame.width * 0.45)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 14
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.1
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
    }
}
