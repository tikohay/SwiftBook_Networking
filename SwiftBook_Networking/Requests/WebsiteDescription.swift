//
//  WebsiteDescription.swift
//  SwiftBook_Networking
//
//  Created by Karakhanyan Tigran on 13.03.2022.
//

import Foundation

struct WebsiteDescription: Decodable {
    let websiteDescription: String?
    let websiteName: String?
    let courses: [Course]
}
