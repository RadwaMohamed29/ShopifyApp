//
//  NetworkService.swift
//  ShopifyApp
//
//  Created by Peter Samir on 25/05/2022.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol{

    func getCustomer(id:String,completion:@escaping (Result<Customer,ErrorType>) -> Void)
    func getCustomerOrders(id: String,completion: @escaping (Result<Orders, ErrorType>) -> Void)
    func getBrandsFromAPI(completion: @escaping(Result<Brands,ErrorType>) -> Void)
    func productDetailsProvider(id:String ,completion :@escaping (Result<Products,ErrorType>)->Void)
    func getAllProduct(completion : @escaping (Result<AllProducts,ErrorType>)->Void)
    func productOfBrandsProvider(id:String ,completion :@escaping (Result<AllProducts,ErrorType>)->Void)
    func getFilteredCategory(target:Endpoints, completion: @escaping(Result<AllProducts, ErrorType>)->())
    func registerCustomerProtocol(newCustomer: Customer,completion: @escaping(Data?, URLResponse?, Error?)->())
    func getAllCustomers(completion: @escaping (Result<AllCustomers,ErrorType>)->Void)
    func getCustomerAddresses(id:String, completion:@escaping (Result<CustomerAddress, ErrorType>)->())
    func getDiscountCode(priceRule: String, completion: @escaping (Result<DiscountCode, ErrorType>) -> Void)
    func postAddressToCustomer(id:String, address:NewAddress, completion: @escaping(Data?, URLResponse?, Error?)->())
    func deleteAddress(customerID: String, addressID: String, address:NewAddress, completion: @escaping(Data?, URLResponse?, Error?)->())
    func updateAddress(customerID: String, addressID: String, address:Address, completion: @escaping(Data?, URLResponse?, Error?)->())
    func postDraftOrder(draftOrder: DraftOrdersRequest, completion: @escaping(Data?, URLResponse?, Error?)->())
    func modifyDraftOrder(draftOrderId:Int,putOrder:PutOrderRequestTest,completion: @escaping(Data?, URLResponse?, Error?)->())
    func editeCustomer(id:Int,editeCustomer:EditCustomer,completion: @escaping(Data?, URLResponse?, Error?)->())
    func getItemsDraftOrder(idDraftOrde:Int,completion:@escaping (Result<DraftOrderResponseTest, ErrorType>)->())
    func postOrder(order:OrderObject, completion: @escaping(Data?, URLResponse?, Error?)->())
    func updateCustomerNote(id: String, customer: Customer, completion: @escaping (Data?, URLResponse?, Error?)->())
    func getProductImage(id: String , completion: @escaping ( Result<ImagesProduct, ErrorType>)->())
    func deleteDraftOrder(idDraftOrder:Int, draftOrder:DraftOrderResponseTest , completion: @escaping(Data?, URLResponse?, Error?)->())

}
