//
//  ImageProperties.swift
//  SwiftBook_Networking
//
//  Created by Karakhanyan Tigran on 14.03.2022.
//

import UIKit

struct ImageProperties {
    let key: String
    let data: Data
    
    init?(withImage image: UIImage, forKey key: String) {
        self.key = key
        guard let data = image.pngData() else { return nil }
        self.data = data
    }
}
