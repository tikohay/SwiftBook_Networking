//
//  MainCollectionViewController.swift
//  SwiftBook_Networking
//
//  Created by Karakhanyan Tigran on 14.03.2022.
//

import UIKit

private let reuseIdentifier = "Cell"

class MainCollectionViewController: UICollectionViewController {
    
    enum Actions: String, CaseIterable {
        case downloadImage = "Download Image"
        case get = "GET"
        case post = "POST"
        case ourCourses = "OurCources"
        case uploadImage = "Upload Image"
        case downloadFile = "Download File"
    }
    
    let actions = Actions.allCases
    
    private let url = "https://jsonplaceholder.typicode.com/posts"
    
//    let actions = ["Download Image", "GET", "POST", "Our Courses", "Upload Image"]

    // MARK: UICollectionViewDataSource

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
            print(action.rawValue)
        }
    }
}
