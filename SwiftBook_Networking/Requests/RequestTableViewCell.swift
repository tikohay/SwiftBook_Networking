//
//  RequestTableViewCell.swift
//  SwiftBook_Networking
//
//  Created by Karakhanyan Tigran on 13.03.2022.
//

import UIKit

class RequestTableViewCell: UITableViewCell {
    
    @IBOutlet weak var courseImage: UIImageView!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var numberOfLessons: UILabel!
    @IBOutlet weak var numberOfTests: UILabel!
    
    
    func configure(name: String, numOfLes: String, numOfTests: String) {
        courseNameLabel.text = name
        numberOfLessons.text = numOfLes
        numberOfTests.text = numOfTests
    }
}

