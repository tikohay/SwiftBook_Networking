//
//  UserProfileViewController.swift
//  SwiftBook_Networking
//
//  Created by Karakhanyan Tigran on 17.03.2022.
//

import UIKit
import FBSDKLoginKit
import GoogleSignIn
import FirebaseAuth
import FirebaseDatabase

class UserProfileViewController: UIViewController {
    
    private var provider: String?
    private var currentUser: UserProfile?
    
    lazy var logoutButton: UIButton = {
        let button = UIButton()
        button.frame = CGRect(x: view.frame.midX, y: view.frame.midY, width: 200, height: 50)
        button.backgroundColor = .systemMint
        button.setTitle("Log out", for: .normal)
        button.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(logoutButton)
    }
    
    @objc private func signOut() {
        if let providerData = Auth.auth().currentUser?.providerData {
            for userInfo in providerData {
                switch userInfo.providerID {
                case "facebook.com":
                    print("user did log ot of facebook")
                case "google.com":
                    GIDSignIn.sharedInstance.signOut()
                    print("user did log out of google")
                default:
                    break
                }
            }
        }
    }
}
