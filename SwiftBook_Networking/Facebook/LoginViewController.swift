//
//  LoginViewController.swift
//  SwiftBook_Networking
//
//  Created by Karakhanyan Tigran on 17.03.2022.
//

import UIKit
import FBSDKLoginKit
import FirebaseAuth

class LoginViewController: UIViewController {
    
    lazy var fbLoginButton: UIButton = {
        let button = FBLoginButton()
        button.frame = CGRect(x: 32, y: 320, width: view.frame.width - 64, height: 50)
        button.delegate = self
        return button
    }()
    
    lazy var customFBLoginButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .blue
        button.setTitle("Login with Facebook", for: .normal)
        button.frame = CGRect(x: 32, y: 360, width: view.frame.width - 64, height: 50)
        button.addTarget(self, action: #selector(handleCustomFBLogin), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
//        if let token = AccessToken.current, !token.isExpired {
//            print(token)
//        }
    }
    
    @objc func handleCustomFBLogin() {
        LoginManager().logIn(permissions: ["email", "public_profile"], from: self) { result, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let result = result else { return }
            
            if result.isCancelled { return }
            else {
                self.signIntoFirebase()
                self.openMainViewController()
            }
        }
    }
    
    private func signIntoFirebase() {
        let accessToken = AccessToken.current
        
        guard let accessTokenString = accessToken?.tokenString else { return }
        
        let credentials = FacebookAuthProvider.credential(withAccessToken: accessTokenString)
    }
    
    private func openMainViewController() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupViews() {
        view.addSubview(fbLoginButton)
        view.addSubview(customFBLoginButton)
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
