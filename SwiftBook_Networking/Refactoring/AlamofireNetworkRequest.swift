//
//  AlamofireNetworkRequest.swift
//  SwiftBook_Networking
//
//  Created by Karakhanyan Tigran on 15.03.2022.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {
    
    static func sendRequest(url: String, completion: @escaping ([Course]) ->()) {
        guard let url = URL(string: url) else { return }
        AF.request(url, method: .get).validate().responseJSON { response in
            
            switch response.result {
            case .success(let value):
                guard let courses = Course.getArray(from: value) else { return }
                completion(courses)
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
    
    static func responseData(url: String) {
        AF.request(url).responseData { responseData in
            switch responseData.result {
            case .success(let data):
                guard let string = String(data: data, encoding: .utf8) else { return }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func responseString(url: String) {
        AF.request(url).responseString { responseString in
            switch responseString.result {
            case .success(let string):
                print(string)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func response(url: String) {
        AF.request(url).response { response in
            guard
                let data = response.data,
                let string = String(data: data, encoding: .utf8)
            else { return }
            print(string)
        }
    }
}
