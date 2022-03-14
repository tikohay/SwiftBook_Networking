//
//  RequestTableViewController.swift
//  SwiftBook_Networking
//
//  Created by Karakhanyan Tigran on 13.03.2022.
//

import UIKit

class RequestTableViewController: UIViewController {
    
    private var courses: [Course] = []
    private var courseName: String?
    private var courseURL: String?
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        fetchData()
    }
    
    func fetchData() {
//        let jsonUrlString = "https://swiftbook.ru//wp-content/uploads/api/api_course"
        let jsonUrlString = "https://swiftbook.ru//wp-content/uploads/api/api_courses"
//        let jsonUrlString = "https://swiftbook.ru//wp-content/uploads/api/api_website_description"
//        let jsonUrlString = "https://swiftbook.ru//wp-content/uploads/api/api_missing_or_wrong_fields"
        
        NetworkManager.fetchData(url: jsonUrlString) { result in
            switch result {
            case .success(let courses):
                self.courses = courses
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            case .failure(let error):
                print(error)
            }
        }
    }
}

extension RequestTableViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courses.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! UITableViewCell
            
        let course = courses[indexPath.row]
        
        cell.textLabel?.text = "\(String(describing: course.name)) \(course.numberOfLessons)"
        cell.textLabel?.numberOfLines = 0
        
//        DispatchQueue.global().async {
//            guard let imageUrl = URL(string: course.imageUrl!) else { return }
//            guard let imageData = try? Data(contentsOf: imageUrl) else { return }
//            DispatchQueue.main.async {
//                cell.imageView?.image = UIImage(data: imageData)
//            }
//        }
        
        guard let imageUrl = URL(string: course.imageUrl!) else { return cell }
        guard let imageData = try? Data(contentsOf: imageUrl) else { return cell }
        cell.imageView?.image = UIImage(data: imageData)

        return cell
    }
}

// MARK: Table View Delegate

extension RequestTableViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let course = courses[indexPath.row]
        
        courseURL = course.link
        courseName = course.name
        
        performSegue(withIdentifier: "Description", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let webVC = segue.destination as! WebViewController
        webVC.selectedCourse = courseName
        
        if let url = courseURL {
            webVC.courseURL = url
        }
    }
}
