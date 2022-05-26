//
//  HomeViewModel.swift
//  ShopifyApp
//
//  Created by Menna on 26/05/2022.
//

import Foundation
protocol DataOfBrands{
    func callFuncTogetBrands(completionHandler:@escaping (Bool) -> Void)
    var getBrands: ((DataOfBrands)->Void)? {get set}
    var brandsData: Brands? {get set}
}
class HomeViewModel: DataOfBrands {
    var getBrands: ((DataOfBrands) -> Void)?

    var brandsData: Brands?{
        didSet{
            getBrands!(self)

        }
    }

    
    let allBrandsProvider: NetworkServiceProtocol = APIClient()

    func callFuncTogetBrands(completionHandler: @escaping (Bool) -> Void) {
        completionHandler(false)
        allBrandsProvider.getBrandsFromAPI { [weak self] result in
            switch result {
            case .success(let allBrands):
                self?.brandsData = allBrands
                print("fen el dataaaa\(allBrands)")
            case.failure(let error):
                print(error.localizedDescription)
            }
            completionHandler(true)


        }
    }
    
}
