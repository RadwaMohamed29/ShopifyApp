//
//  HandelConnection.swift
//  ShopifyApp
//
//  Created by Menna on 28/05/2022.
//
import Reachability
import Foundation
class HandelConnection{
    static let handelConnection = HandelConnection()
    var reachability: Reachability?
    func checkNetworkConnection(complition: @escaping (Bool)-> Void){
        reachability = try! Reachability()
        guard let reachability = reachability else {return}
        reachability.whenReachable = { reachability in
            if reachability.connection == .wifi {
                print("Reachable via WiFi")
                complition(true)
            } else {
                print("Reachable via Cellular")
                complition(true)
            }
        }
        reachability.whenUnreachable = { _ in
            print("Not reachable")
            complition(false)
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

}
extension UIViewController{
    func showAlertForInterNetConnection(){
        let alert = UIAlertController(title: "network is not connected", message: "please, check your internet connection", preferredStyle: .alert)
        let okBtn = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okBtn)
        self.present(alert, animated: true, completion: nil)
    }
}
