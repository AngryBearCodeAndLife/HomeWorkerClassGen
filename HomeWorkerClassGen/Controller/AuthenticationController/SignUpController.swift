//
//  SignInController.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 11/6/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit

class SignUpController: UIViewController {
    
    //Use this to hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    var slantedBackground = SlantedView()
    let signUpLabel = UILabel()
    
    let nameField = UITextField()
    let passwordField = UITextField()
    let passwordVField = UITextField()
    let emailField = UITextField()
    
    let profileImage = UIButton()
    let informationButton = UILabel()
    
    let submitButton = RoundedButtons()
    
    let signInButton = UIButton()
    
    var fieldArray: [UITextField] = []
    
    var imagePicker: UIImagePickerController!
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        
        self.view.backgroundColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        
        placePieces()
    }
    
    @objc private func signUpAction() {
        
        var isFull = true
        
        for textField in fieldArray {
            if textField.text == "" {
                isFull = false
                textField.shake(count: 3, for: 0.2, withTranslation: 10)
                
            }
        }
        
        if isFull && passwordVField.text != passwordField.text {
            
            //Tell the user that their passwords dont match
            passwordVField.shake(count: 3, for: 0.2, withTranslation: 10)
            passwordField.shake(count: 3, for: 0.2, withTranslation: 10)
            
        } else if isFull && passwordVField.text == passwordField.text {
            
            //Sign in
            
            AuthActions.createNewUser(name: nameField.text!, email: emailField.text!, password: passwordField.text!, profileImage: profileImage.currentImage!) { success in
                if success == true {
                    self.present(WorkView(), animated: true, completion: nil)
                } else {
                    print("We had trouble signing you up!")
                }
            }
            
        } 
        
    }
    
    private func placePieces() {
        
        slantedBackground.backgroundColor = UIColor.white
        slantedBackground.slantHeight = 100
        slantedBackground.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 440)
        self.view.addSubview(slantedBackground)
        
        signUpLabel.text = "Sign Up"
        signUpLabel.font = UIFont.boldSystemFont(ofSize: 48)
        signUpLabel.textColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        signUpLabel.textAlignment = .center
        signUpLabel.frame = CGRect(x: 0, y: 6, width: self.view.frame.width, height: 55)
        slantedBackground.addSubview(signUpLabel)
        
        nameField.frame = CGRect(x: 12, y: 100, width: 230, height: 45)
        nameField.placeholder = "Real Name"
        nameField.textColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        nameField.textAlignment = .center
        nameField.layer.cornerRadius = 10
        nameField.layer.borderWidth = 1
        slantedBackground.addSubview(nameField)
        
        passwordField.frame = CGRect(x: 12, y: 151, width: 230, height: 45)
        passwordField.placeholder = "Password"
        passwordField.textColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        passwordField.textAlignment = .center
        passwordField.layer.cornerRadius = 10
        passwordField.layer.borderWidth = 1
        slantedBackground.addSubview(passwordField)
        
        passwordVField.frame = CGRect(x: 12, y: 202, width: 230, height: 45)
        passwordVField.placeholder = "Password Verification"
        passwordVField.textColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        passwordVField.textAlignment = .center
        passwordVField.layer.cornerRadius = 10
        passwordVField.layer.borderWidth = 1
        slantedBackground.addSubview(passwordVField)
        
        emailField.frame = CGRect(x: 12, y: 253, width: 230, height: 45)
        emailField.placeholder = "Email"
        emailField.textColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        emailField.textAlignment = .center
        emailField.layer.cornerRadius = 10
        emailField.layer.borderWidth = 1
        emailField.keyboardType = .emailAddress
        slantedBackground.addSubview(emailField)
        
        profileImage.frame = CGRect(x: self.view.frame.width - 106, y: 100, width: 100, height: 100)
        profileImage.backgroundColor = UIColor.darkGray
        profileImage.layer.cornerRadius = 50
        profileImage.layer.masksToBounds = true
        slantedBackground.addSubview(profileImage)
        profileImage.addTarget(self, action: #selector(chooseProfilePicture), for: .touchUpInside)
        
        informationButton.text = "i"
        informationButton.textAlignment = .center
        informationButton.font = UIFont.systemFont(ofSize: 38)
        informationButton.textColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        informationButton.layer.cornerRadius = 25
        informationButton.layer.borderColor = UIColor.retrieveMainColor(withAlpha: 1.0).cgColor
        informationButton.layer.borderWidth = 2
        informationButton.frame = CGRect(x: self.view.frame.width - 81, y: 220, width: 50, height: 50)
        slantedBackground.addSubview(informationButton)
        
        submitButton.borderRadius = 10
        submitButton.lineWidth = 3
        submitButton.borderColor = UIColor.white
        submitButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 48)
        submitButton.setTitle("Sign Up!", for: .normal)
        submitButton.setTitleColor(UIColor.white, for: .normal)
        submitButton.frame = CGRect(x: 75, y: slantedBackground.frame.height + 12, width: self.view.frame.width - 150, height: 70)
        submitButton.addTarget(self, action: #selector(signUpAction), for: .touchUpInside)
        self.view.addSubview(submitButton)
        
        signInButton.setTitle("Have An Account? Sign In", for: .normal)
        signInButton.setTitleColor(UIColor.white.withAlphaComponent(0.8), for: .normal)
        signInButton.titleLabel?.textAlignment = .center
        signInButton.titleLabel?.font = UIFont.systemFont(ofSize: 24)
        signInButton.frame = CGRect(x: 0, y: self.view.frame.height - 40, width: self.view.frame.width, height: 30)
        signInButton.addTarget(self, action: #selector(showSignInPage), for: .touchUpInside)
        self.view.addSubview(signInButton)
        
        fieldArray = [nameField, emailField, passwordField, passwordVField]
        
    }
    
    @objc private func showSignInPage() {
        
        self.present(SignInController(), animated: true, completion: nil)
        
    }
    
    @objc func chooseProfilePicture() {
        
        print("Is running!!!!!!!")
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        
        sourceFigure()
    }
    
    func sourceFigure() {
        
        //THIS IS GOING TO NEED TO CHANGE TO SOMETHING MUCH MORE CUSTOM AND BETTER LOOKING
        
        let choice = UIAlertController(title: "Profile Picture Source", message: "Choose the source", preferredStyle: .actionSheet)
        choice.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.imagePicker.sourceType = .camera
            choice.dismiss(animated: true, completion: nil)
            self.showPicker()
        }))
        choice.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.imagePicker.sourceType = .photoLibrary
            choice.dismiss(animated: true, completion: nil)
            self.showPicker()
        }))
        self.present(choice, animated: true, completion: nil)
    }
    
    func showPicker() {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
}


extension SignUpController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
        
            self.profileImage.setImage(pickedImage, for: .normal)
        
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
