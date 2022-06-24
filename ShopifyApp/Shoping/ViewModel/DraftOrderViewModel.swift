//
//  DraftOrderViewModel.swift
//  ShopifyApp
//
//  Created by Menna on 24/06/2022.
//

import Foundation

class DraftOrderViewModel{
    var isProductInCart: Bool?
    private var listOfProduct : [Product] = []
    var network = APIClient()
    var localDataSource :LocalDataSource
    let userDefult = Utilities()
    var lineItem = Array<LineItem>()
    var productsInCart: [CartProduct]?

    var bindDraftOrderLineItems: (() -> ()) = {}
    var bindImageURLToView: (() -> ()) = {}
    var bindDraftViewModelErrorToView: (() -> ()) = {}
    var lineItems: [LineItem]? {
            didSet {
                self.bindDraftOrderLineItems()
            }
        }
    var imageURL: String? {
        didSet {
            self.bindImageURLToView()
        }
    }
    var showError: String? {
        didSet {
            self.bindDraftViewModelErrorToView()
        }
    }
    init(appDelegate :AppDelegate){
        localDataSource = LocalDataSource(appDelegate: appDelegate)
    }
        func getDraftOrderLineItems(id: Int){
            network.getItemsDraftOrder(idDraftOrde: id) { result in
                switch result{
                case .success(let response):
                    let lineItem = response.draftOrder
                    self.lineItems=lineItem.lineItems
                    print("itemmmmmmmmmmmms\(self.lineItem)")
                case .failure(let error):
                    let message = error.localizedDescription
                    self.showError = message
                }
            }
        }
    func getProductImage(id: String) {
        network.getProductImage(id: id) {result in
            switch result{
            case .success(let response):
                let image = response.images[0].src
                self.imageURL = image
            case .failure(let error):
                let message = error.localizedDescription
                self.showError = message
            }
        }
    }
    
}

