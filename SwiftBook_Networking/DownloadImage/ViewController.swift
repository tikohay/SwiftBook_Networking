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
    
    @IBOutlet weak var imageView: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchImage()
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
}

