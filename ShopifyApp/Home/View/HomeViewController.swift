//
//  HomeViewController.swift
//  ShopifyApp
//
//  Created by AbdElrahman sayed on 20/05/2022.
//

import UIKit

class HomeViewController: UIViewController,brandIdProtocol {
    
    func transBrandName(brandId: Int) {
        let productListVC = AllProductsViewController(nibName: "AllProductsViewController", bundle: nil)
        productListVC.brandId = brandId
        productListVC.isCommingFromHome = "true"
        print("iddddddddd\(brandId)")
   //     goToAllProduct(isCommingFromBrand: "true", brnadId: brandId)
        self.navigationController?.pushViewController(productListVC, animated: true)
    }
    

    @IBOutlet weak var homeTV: UITableView!
 
    override func viewDidLoad() {
        
        super.viewDidLoad()
        BrandTableViewCell.setHome(deleget: self)
        setupTableView()
        
        // Do any additional setup after loading the view.
    }

    func setupTableView(){
        homeTV.register(AbsTableViewCell.Nib(), forCellReuseIdentifier: AbsTableViewCell.identifier)
        homeTV.register(BrandTableViewCell.Nib(), forCellReuseIdentifier: BrandTableViewCell.identifier)
        homeTV.delegate = self
        homeTV.dataSource = self
    }
    @IBAction func search(_ sender: Any) {
        
       // goToAllProduct(isCommingFromBrand: "true", brandId: nil)
        goToAllProduct(isCommingFromBrand: "true", brnadId: 0 )

    }

    @IBAction func fav(_ sender: Any) {
    }
    @IBAction func cart(_ sender: Any) {
        let a = ShoppingCartVC(nibName:"ShoppingCartVC", bundle: nil)
         self.navigationController?.pushViewController(a, animated: true)
        
    }
   
}
extension HomeViewController{
    func goToAllProduct(isCommingFromBrand: String,brnadId: Int){
    let productListVC = AllProductsViewController(nibName: "AllProductsViewController", bundle: nil)
    productListVC.brandId = brnadId
    productListVC.isCommingFromHome = isCommingFromBrand
    self.navigationController?.pushViewController(productListVC, animated: true)
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
            title = "ADS"
        default:
            title = "BRANDS"
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
