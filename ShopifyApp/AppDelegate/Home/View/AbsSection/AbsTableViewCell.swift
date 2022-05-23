//
//  AbsTableViewCell.swift
//  ShopifyApp
//
//  Created by Menna on 22/05/2022.
//

import UIKit

class AbsTableViewCell: UITableViewCell {
    @IBOutlet weak var adsCollectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!
    static let identifier = "AbsTableViewCell"
    static func Nib()-> UINib{
        return UINib(nibName: "AbsTableViewCell", bundle: nil)
    }
    var arrayOfAds: [String] = ["ads1", "ads2", "ads3", "ads4","abs5"]
    var timer: Timer?
    var currentAdsIndex = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        setupTimer()
        // Initialization code
    }
    func setupCollectionView(){
        adsCollectionView.register(AbsCollectionViewCell.Nib(), forCellWithReuseIdentifier: AbsCollectionViewCell.identifier)
        adsCollectionView.delegate = self
        adsCollectionView.dataSource = self
    }
    func setupTimer(){
        pageController.numberOfPages = arrayOfAds.count
        timer = Timer.scheduledTimer(timeInterval: 2.5, target: self, selector: #selector(moveToIndexAds), userInfo: nil, repeats: true)
    }
    
    @objc func moveToIndexAds(){
        if currentAdsIndex < arrayOfAds.count - 1 {
            currentAdsIndex += 1
        }else{
            currentAdsIndex = 0
        }
        
        adsCollectionView.scrollToItem(at: IndexPath(row: currentAdsIndex, section: 0), at: .centeredHorizontally, animated: true)
        pageController.currentPage = currentAdsIndex
    }
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
    
}
extension AbsTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrayOfAds.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AbsCollectionViewCell.identifier, for: indexPath) as! AbsCollectionViewCell
        cell.adsImageView.image = UIImage(named: arrayOfAds[indexPath.row])
        cell.adsImageView.layer.borderWidth = 0.5
        cell.adsImageView.layer.borderColor = UIColor.gray.cgColor
        cell.adsImageView.layer.cornerRadius = 25
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 210)
    }
    
}
