//
//  LoginViewController.swift
//  SwiftBook_Networking
//
//  Created by Karakhanyan Tigran on 17.03.2022.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    lazy var fbLoginButton: UIButton = {
        let button = FBLoginButton()
        button.frame = CGRect(x: 32, y: 320, width: view.frame.width - 64, height: 50)
        button.delegate = self
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
//        if let token = AccessToken.current, !token.isExpired {
//            print(token)
//        }
    }
    
    private func setupViews() {
        view.addSubview(fbLoginButton)
    }
}

extension LoginViewController: LoginButtonDelegate {
    
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        if error != nil {
            print(error)
            return
        }
        
        print("Successfully logged in with facebook")
    }
    
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("did log out of facebook")
    }
}
