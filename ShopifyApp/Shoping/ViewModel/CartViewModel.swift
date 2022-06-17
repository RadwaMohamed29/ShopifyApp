//
//  CartViewModel.swift
//  ShopifyApp
//
//  Created by Menna on 17/06/2022.
//

import Foundation
protocol CartShoppingProtocol{
    func postOrder(draftOrder: DraftOrders, completion: @escaping(Bool)->())
}
class CartViewModel: CartShoppingProtocol{
    let network = APIClient()
    let userDefult = Utilities()
    func postOrder(draftOrder: DraftOrders, completion: @escaping (Bool) -> ()) {
        network.postDraftOrder(draftOrder: draftOrder) {[weak self] data, response, error in
            if error != nil {
                completion(false)
                print(error!)
            }else{
                if let data = data{
                    let json = try! JSONSerialization.jsonObject(with: data, options:.allowFragments) as! Dictionary<String, Any>
                    let draftOrder = json["draftOrder"] as? Dictionary <String,Any>
                    let draftId = draftOrder?["draft_order_id"] as? Int ?? 0
                    
                    if draftId != 0{
                        self?.userDefult.setDraftOrder(id: draftId)
                        print("post success")
                        completion(true)
                        
                    }
                    else{
                        print("can't post")
                    }
                }
            }}
    }
    
    
}
