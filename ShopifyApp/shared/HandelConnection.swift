//
//  HandelConnection.swift
//  ShopifyApp
//
//  Created by Menna on 28/05/2022.
//
import Reachability
import Foundation
//import LPSnackbar
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
    func showSnackBar(){
      //  LPSnackbar.showSnack(title: "network is not connected")
//        let snack = LPSnackbar(title: "network is not connected", buttonTitle: "dismiss")
//        // Customize the snack
//        snack.bottomSpacing = (tabBarController?.tabBar.frame.minX ?? 0)
//        snack.view.titleLabel.font = UIFont.systemFont(ofSize: 20)
//
//        // Show a snack to allow user to undo deletion
//        snack.show(animated: true) { (undone) in
//            if undone {
//                snack.dismiss()
//            } else {
//                snack.show()
//            }
//        }
    }

}
