//
//  AlamofireNetworkRequest.swift
//  SwiftBook_Networking
//
//  Created by Karakhanyan Tigran on 15.03.2022.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {
    
    static func sendRequest(url: String) {
        guard let url = URL(string: url) else { return }
        
        AF.request(url, method: .get).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                guard let arrayOfItems = value as? Array<[String: Any]> else { return }
                print(arrayOfItems)
            case .failure(let error):
                print(error)
            }
//            guard let statusCode = response.response?.statusCode else { return }
//
//            print("Status code: ", statusCode)
//
//            if (200 ..< 300).contains(statusCode) {
//                let value = response.value
//                print("value: ", value ?? "nil")
//            } else {
//                let error = response.error
//                print(error ?? "error")
//            }
//        }
        }
    }
}
