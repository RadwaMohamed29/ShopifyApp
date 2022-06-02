//
//  HomeViewController.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 20/05/2022.
//

import UIKit
class HomeViewController: UIViewController,brandIdProtocol {
    @IBOutlet weak var noImageView: UIView!

    @IBOutlet weak var cartBtn: UIButton!
    @IBOutlet weak var homeTV: UITableView!
    let refreshControl = UIRefreshControl()
    let badgeSize: CGFloat = 18
    let badgeTag = 5
    var badgeCount = UILabel()
    var bagProduct : CartProduct?
    override func viewDidLoad() {
        super.viewDidLoad()
        BrandTableViewCell.setHome(deleget: self)
        setupTableView()

        //showBadge(withCount: 5)
    }
    override func viewWillAppear(_ animated: Bool) {
        refreshControl.tintColor = UIColor.darkGray
        refreshControl.addTarget(self, action:#selector(checkConnection), for: .valueChanged)
        homeTV.addSubview(refreshControl)
        checkConnection()
    
    }
    func setupTableView(){
        homeTV.register(AbsTableViewCell.Nib(), forCellReuseIdentifier: AbsTableViewCell.identifier)
        homeTV.register(BrandTableViewCell.Nib(), forCellReuseIdentifier: BrandTableViewCell.identifier)
        homeTV.delegate = self
        homeTV.dataSource = self
    }
    @IBAction func search(_ sender: Any) {
        goToAllProduct(isCommingFromBrand: "true", brnadId: 0 )

    }

    @IBAction func fav(_ sender: Any) {
        let a = FavouriteViewController(nibName:"FavouriteViewController", bundle: nil)
         self.navigationController?.pushViewController(a, animated: true)
        
    }
    @IBAction func cart(_ sender: Any) {
        let a = ShoppingCartVC(nibName:"ShoppingCartVC", bundle: nil)
         self.navigationController?.pushViewController(a, animated: true)
       // cartBtn.badgeColor
        
    }
   
}
extension HomeViewController{
    func transBrandName(brandId: Int) {
        let productListVC = AllProductsViewController(nibName: "AllProductsViewController", bundle: nil)
        productListVC.brandId = brandId
        productListVC.isCommingFromHome = "true"
        self.navigationController?.pushViewController(productListVC, animated: true)
    }
    func goToAllProduct(isCommingFromBrand: String,brnadId: Int){
    let productListVC = AllProductsViewController(nibName: "AllProductsViewController", bundle: nil)
    productListVC.brandId = brnadId
    productListVC.isCommingFromHome = isCommingFromBrand
    self.navigationController?.pushViewController(productListVC, animated: true)
     }
   @objc func checkConnection(){
        HandelConnection.handelConnection.checkNetworkConnection { isConnected in
            if isConnected{
                self.homeTV.isHidden = false
                self.noImageView.isHidden = true
                self.homeTV.reloadData()
            }else{
                self.homeTV.isHidden = true
                self.noImageView.isHidden = false
              //  self.showAlertForInterNetConnection()
                self.showSnackBar()
            }
        }
    }
    func badgeLable(withCount count: Int)->UILabel{
        badgeCount = UILabel(frame: CGRect(x: 0, y: 0, width: badgeSize, height: badgeSize))
        badgeCount.tag = badgeTag
        badgeCount.layer.cornerRadius = badgeCount.bounds.size.height/2
        badgeCount.layer.masksToBounds = true
        badgeCount.textColor = .red
        badgeCount.font = badgeCount.font.withSize(12)
        badgeCount.textAlignment = .center
        badgeCount.backgroundColor = .white
        badgeCount.text = String(count)
        return badgeCount
    }
    func showBadge(withCount count:Int){
        let badge = badgeLable(withCount: count)
        cartBtn.addSubview(badge)
        NSLayoutConstraint.activate([
            badge.leftAnchor.constraint(equalTo: cartBtn.leftAnchor, constant: 14),
            badge.topAnchor.constraint(equalTo: cartBtn.topAnchor, constant: -5),
            badge.widthAnchor.constraint(equalToConstant: badgeSize),
            badge.heightAnchor.constraint(equalToConstant: badgeSize),
            
        ])
        
    }
}
extension HomeViewController :UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var rows = 0
        switch section{
        case 0:
            rows = 1
        default:
            rows = 1
        }
        return rows
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let adsCell = tableView.dequeueReusableCell(withIdentifier: AbsTableViewCell.identifier, for: indexPath)
            return adsCell
        default:
        let brandCell = tableView.dequeueReusableCell(withIdentifier: BrandTableViewCell.identifier, for: indexPath) as! BrandTableViewCell
                    return brandCell
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height = 0.0
        switch indexPath.section{
        case 0:
            height = 210
        default:
            height = view.frame.height * 1.5
        }
        return height
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var title = ""
        switch section{
        case 0:
            title = ""
        default:
            title = ""
        }
        return title
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header: UITableViewHeaderFooterView = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: "Verdana", size: 18)
        header.textLabel?.textAlignment = NSTextAlignment.center
        header.textLabel?.textColor = UIColor.label
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        homeTV.deselectRow(at: indexPath, animated: false)
    }
    
}
