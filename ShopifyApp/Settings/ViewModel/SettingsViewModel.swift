//
//  SettingsViewModel.swift
//  ShopifyApp
//
//  Created by Radwa on 08/06/2022.
//

import Foundation

protocol SettingsViewModelType{
    func getCurrency(key:String)->String
    func setCurrency(key:String, value: String)
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
        return currency!
    }
    
    func setCurrency(key: String, value: String) {
        userDefualts.setCurrency(Key: key, value: value)
        currency = value
    }
}