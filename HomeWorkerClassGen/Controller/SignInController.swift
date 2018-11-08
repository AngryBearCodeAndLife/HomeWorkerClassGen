//
//  SignInController.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 11/7/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import FirebaseAuth

class SignInController: UIViewController {
    
    //Use this to hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var slantedBackground = SlantedView()
    let signInLabel = UILabel()
    
    let emailField = UITextField()
    let passwordField = UITextField()
    
    let submitButton = RoundedButtons()
    
    let signUpButton = UIButton()
    
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        
        self.view.backgroundColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        
        placePieces()
        
    }
    
    @objc private func signInAction() {
        
        if emailField.text == "" && passwordField.text == "" {
            
            emailField.shake(count: 3, for: 0.2, withTranslation: 10)
            passwordField.shake(count: 3, for: 0.2, withTranslation: 10)
            
        } else if passwordField.text == "" {
            
            passwordField.shake(count: 3, for: 0.2, withTranslation: 10)
            
        } else if emailField.text == "" {
            
            emailField.shake(count: 3, for: 0.2, withTranslation: 10)
            
        } else {
            
            Auth.auth().signIn(withEmail: emailField.text!, password: passwordField.text!, completion: { (user, error) in
                if error == nil && user?.user.uid != nil {
                    //User is signed in
                    AuthActions.setUser()
                    
                    LocalActions.AutoLoggin.enable(email: self.emailField.text!, password: self.passwordField.text!, completion: { _ in
                        print("Atologin was enabled after signing the in")
                    })
                    
                    self.present(WorkView(), animated: true, completion: nil)
                    
//                    self.goToView(destination: "tabBarController")
                } else {
                    //User could not be signed in, go to the sign in view
//                    self.goToView(destination: "signInView")
                    //Need to do something here to show the user that they could be signed in
                    print("couldnt be signed in")
                }
            })
        }
        
    }
    
    private func placePieces() {
        
        slantedBackground.backgroundColor = UIColor.white
        slantedBackground.slantHeight = 100
        slantedBackground.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 320)
        self.view.addSubview(slantedBackground)
        
        signInLabel.text = "Sign In"
        signInLabel.font = UIFont.boldSystemFont(ofSize: 48)
        signInLabel.textColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        signInLabel.textAlignment = .center
        signInLabel.frame = CGRect(x: 0, y: 6, width: self.view.frame.width, height: 55)
        slantedBackground.addSubview(signInLabel)
        
        emailField.frame = CGRect(x: 12, y: 100, width: self.view.frame.width - 24, height: 45)
        emailField.placeholder = "Email"
        emailField.textColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        emailField.textAlignment = .center
        emailField.layer.cornerRadius = 10
        emailField.layer.borderWidth = 1
        slantedBackground.addSubview(emailField)
        
        passwordField.frame = CGRect(x: 12, y: 151, width: self.view.frame.width - 24, height: 45)
        passwordField.placeholder = "Password"
        passwordField.textColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        passwordField.textAlignment = .center
        passwordField.layer.cornerRadius = 10
        passwordField.layer.borderWidth = 1
        slantedBackground.addSubview(passwordField)
        
        submitButton.borderRadius = 10
        submitButton.lineWidth = 3
        submitButton.borderColor = UIColor.white
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 48)
        submitButton.setTitle("Sign In!", for: .normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.frame = CGRect(x: 75, y: slantedBackground.frame.height + 12, width: self.view.frame.width - 150, height: 70)
        submitButton.addTarget(self, action: #selector(signInAction), for: .touchUpInside)
        self.view.addSubview(submitButton)
        
        signUpButton.setTitle("Need An Account? Sign Up", for: .normal)
        signUpButton.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .normal)
        signUpButton.titleLabel?.textAlignment = .center
        signUpButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        signUpButton.frame = CGRect(x: 0, y: self.view.frame.height - 40, width: self.view.frame.width, height: 30)
        signUpButton.addTarget(self, action: #selector(showSignUpPage), for: .touchUpInside)
        self.view.addSubview(signUpButton)
    }
    
    @objc private func showSignUpPage() {
        
        self.present(SignUpController(), animated: true, completion: nil)
        
    }
    
}
