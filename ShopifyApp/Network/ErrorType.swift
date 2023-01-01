//
//  ErrorType.swift
//  ShopifyApp
//
//  Created by Peter Samir on 01/01/2023.
//

import Foundation


enum ErrorType:Error {
    
    case InternalError
    case ServerError
    case parsingError
    case urlBadFormmated
}
