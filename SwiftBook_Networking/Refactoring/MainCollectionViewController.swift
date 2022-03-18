//
//  MainCollectionViewController.swift
//  SwiftBook_Networking
//
//  Created by Karakhanyan Tigran on 14.03.2022.
//

import UIKit
import UserNotifications
import FBSDKLoginKit

class MainCollectionViewController: UICollectionViewController {
    
    enum Actions: String, CaseIterable {
        case downloadImage = "Download Image"
        case get = "GET"
        case post = "POST"
        case ourCourses = "OurCources"
        case uploadImage = "Upload Image"
        case downloadFile = "Download File"
        case ourCoursesAlamofire = "Our courses alamofire"
        case responseData = "ResponseData"
        case responseString = "ResponseString"
        case response = "Response"
        case downloadLargeImage = "DownloadLargeImage"
        case postAlamofire = "POST with Alamofire"
        case putRequest = "Put Request with alamofire"
        case uploadImageAlamofire = "Upload image (Alamofire)"
    }
    
    private let reuseIdentifier = "Cell"
    let actions = Actions.allCases
    private var alert: UIAlertController!
    private let dataProvider = DataProvider()
    private var filePath: String?
    
    private let url = "https://jsonplaceholder.typicode.com/posts"
    private let swiftbookApi = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
    private let uploadImage = "https://api.imgur.com/3/image"
    
//    let actions = ["Download Image", "GET", "POST", "Our Courses", "Upload Image"]

    // MARK: UICollectionViewDataSource
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registreForNotification()
        checkLoggedIn()
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        guard let completion = appDelegate?.testCompletion else { return }
        completion("hello")
        
        dataProvider.fileLocation = { location in
            print("Download finished: \(location.absoluteString)")
            self.filePath = location.absoluteString
            self.alert.dismiss(animated: false, completion: nil)
            self.postNotification()
        }
    }
    
    private func showAlert() {
        alert = UIAlertController(title: "Downloading", message: "0%", preferredStyle: .alert)
        let height = NSLayoutConstraint(item: alert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 170)
        alert.view.addConstraint(height)
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive) { action in
            self.dataProvider.stopDownload()
        }
        alert.addAction(cancelAction)
        
        present(alert, animated: true) {
            let size = CGSize(width: 40, height: 40)
            let point = CGPoint(x: self.alert.view.frame.width / 2 - size.width / 2, y: self.alert.view.frame.height / 2 - size.height / 2)
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(origin: point, size: size))
            activityIndicator.color = .gray
            activityIndicator.startAnimating()
            
            let progressView = UIProgressView(frame: CGRect(x: 0, y: self.alert.view.frame.height - 44, width: self.alert.view.frame.width, height: 2))
            progressView.tintColor = .blue
            
            self.dataProvider.onProgress = { progress in
                progressView.progress = Float(progress)
                self.alert.message = String(Int(progress * 100)) + "%"
            }
            
            self.alert.view.addSubview(activityIndicator)
            self.alert.view.addSubview(progressView)
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return actions.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CollectionViewCell
    
        cell.label.text = actions[indexPath.row].rawValue
    
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let action = actions[indexPath.row]
        switch action {
        case .downloadImage:
            performSegue(withIdentifier: "showImage", sender: self)
        case .get:
            NetworkManager.getRequest(url: url)
        case .post:
            NetworkManager.postRequest(url: url)
        case .ourCourses:
            performSegue(withIdentifier: "OurCources", sender: self)
        case .uploadImage:
            print("Upload Image")
        case .downloadFile:
            showAlert()
            dataProvider.startDownload()
        case .ourCoursesAlamofire:
            performSegue(withIdentifier: "OurCoursesWithAlamifire", sender: self)
        case .responseData:
//            performSegue(withIdentifier: "ResponseData", sender: self)
            AlamofireNetworkRequest.responseData(url: url)
        case .responseString:
            AlamofireNetworkRequest.responseString(url: swiftbookApi)
        case .response:
            AlamofireNetworkRequest.response(url: swiftbookApi)
        case .downloadLargeImage:
            performSegue(withIdentifier: "largeImage", sender: self)
        case .postAlamofire:
            performSegue(withIdentifier: "PostRequest", sender: self)
        case .putRequest:
            performSegue(withIdentifier: "PutRequest", sender: self)
        case .uploadImageAlamofire:
            AlamofireNetworkRequest.uploadImage(url: uploadImage)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let coursesVC = segue.destination as? RequestTableViewController
        let imageVC = segue.destination as? ViewController
        
        switch segue.identifier {
        case "OurCources":
            coursesVC?.fetchData()
        case "OurCoursesWithAlamifire":
            coursesVC?.fetchDataWithAlamofire()
        case "showImage":
            imageVC?.fetchImage()
        case "ResponseData":
            imageVC?.fetchImage()
        case "largeImage":
            imageVC?.downloadImageWithProgress()
        case "PostRequest":
            coursesVC?.postRequest()
        case "PutRequest":
            coursesVC?.putRequest()
        default:
            break
        }
    }
}

extension MainCollectionViewController {
    private func registreForNotification() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { _, _ in
            
        }
    }
    
    private func postNotification() {
        let content = UNMutableNotificationContent()
        content.title = "Download complete"
        content.body = "Your background transfer has completed. File path: \(filePath!)"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3, repeats: false)
        let request = UNNotificationRequest(identifier: "TransferComplete", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
}

extension MainCollectionViewController {
    private func checkLoggedIn() {
//        if let token = AccessToken.current, !token.isExpired {
//            print(token)
//        } else {
//            DispatchQueue.main.async {
//                let storyBoard = UIStoryboard(name: "Main", bundle: nil)
//                let loginViewController = storyBoard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//                self.present(loginViewController, animated: true, completion: nil)
//                return
//            }
//        }
    }
}
