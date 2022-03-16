//
//  ViewController.swift
//  SwiftBook_Networking
//
//  Created by Karakhanyan Tigran on 13.03.2022.
//

import UIKit
import Alamofire

class ViewController: UIViewController {
    private let url =  "https://applelives.com/wp-content/uploads/2016/03/iPhone-SE-11.jpeg"
    private let largeImageUrl = "https://i.imgur.com/3416rvI.jpg"
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        fetchImage()
    }
    
    func fetchImage() {
        NetworkManager.downloadImage(url: url) { result in
            switch result {
            case .success(let image):
                self.imageView.image = image
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func fetchDataWithAlamofire() {
        AF.request(url).responseData { responseData in
            switch responseData.result {
            case .success(let data):
                guard let image = UIImage(data: data) else { return }
                self.imageView.image = image
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func downloadImageWithProgress() {
        AlamofireNetworkRequest.completed = { string in
            self.completedLabel.text = string
        }
        
        AlamofireNetworkRequest.onProgress = { progress in
            self.progressView.progress = Float(progress)
        }
        
        AlamofireNetworkRequest.downloadImageWithProgress(url: largeImageUrl) { image in
            self.imageView.image = image
        }
    }
}

