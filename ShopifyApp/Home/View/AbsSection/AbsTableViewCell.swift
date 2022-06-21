//
//  AbsTableViewCell.swift
//  ShopifyApp
//
//  Created by Menna on 22/05/2022.
//

import UIKit
import RxSwift
class AbsTableViewCell: UITableViewCell {
    @IBOutlet weak var adsCollectionView: UICollectionView!
    @IBOutlet weak var pageController: UIPageControl!

    static let identifier = "AbsTableViewCell"
    static func Nib()-> UINib{
        return UINib(nibName: "AbsTableViewCell", bundle: nil)
    }
    var arrayOfAds: [String] = ["offer","ads1"]
    var timer: Timer?
    var currentAdsIndex = 0
    var arrDiscountCodes = [String]()
    var homeViewModel: HomeViewModel?
    let disBag = DisposeBag()
    var myDiscount:String = "1173393670402"
    var adds: [Discount_codes] = []

    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        setupTimer()
        homeViewModel = HomeViewModel()
        getAllDiscountFromApi()
    }
    func getAllDiscountFromApi(){
        homeViewModel?.getDiscountCode(priceRule: myDiscount)
        homeViewModel?.allDiscountObservable.subscribe(on: ConcurrentDispatchQueueScheduler.init(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
            .subscribe { coupons in
                self.adds = coupons
                self.adsCollectionView.reloadData()
            } onError: { error in
                print(error)
            }.disposed(by: disBag)
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
    @objc func tap(_ sender: UITapGestureRecognizer) {

           let location = sender.location(in: self.adsCollectionView)
           let indexPath = self.adsCollectionView.indexPathForItem(at: location)
           if let index = indexPath {
               if Utilities.utilities.isCodeUsed(code: adds[0].code) != true {
                   //MARK: swift messages To be changed later
                   Utilities.utilities.setCode(code: adds[0].code)
                   UIPasteboard.general.string = adds[0].code
                   Shared.showMessage(message: "CONGRATULATIONS, YOU'VE WON A 30% OFFER 🥳", error: false
                   )
               }
               else if Utilities.utilities.isCodeUsed(code: adds[0].code) == true{
                   Shared.showMessage(message: "This coupon is used", error: false)
               }
           }
        }
    
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
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tap(_:))))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width, height: 210)
    }
}
