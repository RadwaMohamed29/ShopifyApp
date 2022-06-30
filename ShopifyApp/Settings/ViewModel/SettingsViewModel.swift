//
//  SettingsViewModel.swift
//  ShopifyApp
//
//  Created by Radwa on 08/06/2022.
//

import Foundation
import UIKit
protocol SettingsViewModelType{
    func getCurrency(key:String)->String
    func setCurrency(key:String, value: String)
    func openWebsite(url:String)
    var currency: String? {get set }
    var bindSettingViewModel : (()->()){get set}
    
}
class SettingsViewModel:NSObject, SettingsViewModelType{
    var userDefualts =  Utilities()
    var bindSettingViewModel: (() -> ()) = {}
    
    var currency: String?{
        didSet{
            self.bindSettingViewModel()
        }
    }
    
    func getCurrency(key: String) -> String {
        self.currency = userDefualts.getCurrency(key: key)
        if currency == "" {
            currency = "USD"
        }
        return currency!
    }
    
    func setCurrency(key: String, value: String) {
        userDefualts.setCurrency(Key: key, value: value)
        currency = value
    }
    func openWebsite(url:String){
        let app = UIApplication.shared
        if app.canOpenURL(URL(string: url)!){
            app.open(URL(string: url)!)
        }else {
            app.open(URL(string: "https://\(url)")!)
        }
    }
}
