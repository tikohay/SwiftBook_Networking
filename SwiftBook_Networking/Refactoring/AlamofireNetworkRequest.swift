//
//  AlamofireNetworkRequest.swift
//  SwiftBook_Networking
//
//  Created by Karakhanyan Tigran on 15.03.2022.
//

import Foundation
import Alamofire

class AlamofireNetworkRequest {
    
    static var onProgress: ((Double) -> Void)?
    static var completed: ((String) -> Void)?
    
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
    
    static func downloadImageWithProgress(url: String, completion: @escaping (UIImage) -> Void) {
        guard let url = URL(string: url) else { return }
        
//        AF.request(url, method: .get).responseData { response in
//            print(response.response?.statusCode)
//        }
        
        AF.request(url, method: .get).validate().downloadProgress { progress in
            print("totalUnitCount:\n", progress.totalUnitCount)
            print("completedUnitCount:\n", progress.completedUnitCount)
            print("fractionCompleted:\n", progress.fractionCompleted)
            print("localizedDescrption:\n", progress.localizedDescription)
            print("----------------------")
            
            self.onProgress?(progress.fractionCompleted)
            self.completed?(progress.localizedDescription)
        }.response { response in
            guard
                let data = response.data,
                let image = UIImage(data: data)
            else { return }
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
        
//        AF.download(url).validate().downloadProgress { progress in
//            print("hello")
////            print("totalUnitCount:\n", progress.totalUnitCount)
////            print("completedUnitCount:\n", progress.completedUnitCount)
////            print("fractionCompleted:\n", progress.fractionCompleted)
////            print("localizedDescrption:\n", progress.localizedDescription)
////            print("----------------------")
//        }
    }
    
    static func postRequest(url: String, completion: @escaping ([Course]) -> Void) {
        guard let url = URL(string: url) else { return }
        
        let userData: [String: Any] = [
            "name": "Hello",
            "link": "https://swiftbook.ru/conteonts/our-first-applicatioins/",
            "imageUrl": "https://swiftbook.ru/conteonts/our-first-applicatioins/",
            "number_of_lessons": 18 as Int,
            "number_of_tests": 10 as Int
        ]
        
        AF.request(url, method: .post, parameters: userData).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("statusCode ", statusCode)
            print(responseJSON)
            switch responseJSON.result {
            case .success(let value):
                print(value)
                
                guard
                    let jsonObject = value as? [String: Any],
                    let course = Course(json: jsonObject)
                else { return }
                
                var courses: [Course] = []
                courses.append(course)
                completion(courses)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func putRequest(url: String, completion: @escaping ([Course]) -> Void) {
        guard let url = URL(string: url) else { return }
        
        let userData: [String: Any] = [
            "name": "Network request with alamofire",
            "link": "https://swiftbook.ru/conteonts/our-first-applicatioins/",
            "imageUrl": "https://swiftbook.ru/conteonts/our-first-applicatioins/",
            "number_of_lessons": 18,
            "number_of_tests": 10
        ]
        
        AF.request(url, method: .put, parameters: userData).responseJSON { responseJSON in
            guard let statusCode = responseJSON.response?.statusCode else { return }
            print("statusCode ", statusCode)
            print(responseJSON)
            switch responseJSON.result {
            case .success(let value):
                print(value)
                
                guard
                    let jsonObject = value as? [String: Any],
                    let course = Course(json: jsonObject)
                else { return }
                
                var courses: [Course] = []
                courses.append(course)
                completion(courses)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    static func uploadImage(url: String) {
//        guard let url = URL(string: url) else { return }
//        
//        let image = UIImage(named: "Notification")!
//        let data = image.pngData()
//        
//        let httpHeaders = ["Authorization": "Client-ID 1bd22b9ce396a4c"]
//        
//        AF.upload(multipartFormData: { multiPartFormData in
//            multiPartFormData.append(data!, withName: "image")
//        }, to: url, headers: httpHeaders) { encodingCompletion in
//            switch encodingCompletion {
//                
//            }
//        }
    }
}
