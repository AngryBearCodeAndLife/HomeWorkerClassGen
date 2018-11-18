//
//  SettingsPage.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 9/30/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit

class SettingsPage: UIViewController {
    
    //Use this to hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    let profilePictureView = UIImageView()
    
    let slantedViewBack = SlantedView()
    let nameLabel = UILabel()
    let doneButton = RoundedButtons()
    
    let changePasswordButton = RoundedButtons()
    let changeUsernameButton = RoundedButtons()
    let changeEmailButton = RoundedButtons()
    let signOutButton = RoundedButtons()
    
    func moveView() {
        
        DataStorage.User.Name.fetch { (success, name) in
            if success {
                self.nameLabel.text = name
            }
        }
        
        slantedViewBack.backgroundColor = UIColor.white
        slantedViewBack.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 128)
        nameLabel.textColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        nameLabel.font = UIFont.systemFont(ofSize: 38)
        nameLabel.frame = CGRect(x: 0, y: 40, width: self.view.frame.width, height: 45)
        nameLabel.textAlignment = .center
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 19)
        doneButton.titleLabel?.textColor = UIColor.white
        doneButton.borderColor = UIColor.white
        doneButton.borderRadius = 10
        doneButton.lineWidth = 2
        doneButton.frame = CGRect(x: (self.view.frame.width * 0.75) - 50, y: 100, width: 100, height: 35)
        doneButton.addTarget(self, action: #selector(showMainPage), for: .touchUpInside)
        self.view.addSubview(slantedViewBack)
        self.view.addSubview(nameLabel)
        self.view.addSubview(doneButton)
        
        self.view.backgroundColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        
        DataStorage.User.ProfileImage.fetch { profile in
            self.profilePictureView.image = profile
        }
        
        profilePictureView.backgroundColor = UIColor.gray
        profilePictureView.frame = CGRect(x: self.view.frame.width * 0.5 - (self.view.frame.width * 0.3), y: slantedViewBack.frame.height + 20, width: self.view.frame.width * 0.6, height: self.view.frame.width * 0.6)
        profilePictureView.layer.cornerRadius = profilePictureView.frame.width / 2
        profilePictureView.layer.masksToBounds = true
        
        self.view.addSubview(profilePictureView)
        
        //Change password button
        changePasswordButton.setTitle("Change Password", for: .normal)
        changePasswordButton.titleLabel?.textColor = UIColor.white
        changePasswordButton.borderColor = UIColor.white
        changePasswordButton.borderRadius = 10
        changePasswordButton.lineWidth = 2
        changePasswordButton.frame = CGRect(x: (self.view.frame.width/2) - 107.5, y: (self.profilePictureView.frame.origin.y + self.profilePictureView.frame.height) + 72, width: 215, height: 32)
        changePasswordButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(changePasswordButton)
        
        //Change username button
        changeUsernameButton.setTitle("Change Username", for: .normal)
        changeUsernameButton.titleLabel?.textColor = UIColor.white
        changeUsernameButton.borderColor = UIColor.white
        changeUsernameButton.borderRadius = 10
        changeUsernameButton.lineWidth = 2
        changeUsernameButton.frame = CGRect(x: (self.view.frame.width/2) - 107.5, y: (self.profilePictureView.frame.origin.y + self.profilePictureView.frame.height) + 110, width: 215, height: 32)
        changeUsernameButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(changeUsernameButton)
        
        //Change email button
        
        changeEmailButton.setTitle("Change Email", for: .normal)
        changeEmailButton.titleLabel?.textColor = UIColor.white
        changeEmailButton.borderColor = UIColor.white
        changeEmailButton.borderRadius = 10
        changeEmailButton.lineWidth = 2
        changeEmailButton.frame = CGRect(x: (self.view.frame.width/2) - 107.5, y: (self.profilePictureView.frame.origin.y + self.profilePictureView.frame.height) + 148, width: 215, height: 32)
        changeEmailButton.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(changeEmailButton)
        
        signOutButton.setTitle("SIGN OUT", for: .normal)
        signOutButton.setTitleColor(UIColor.red, for: .normal)
        signOutButton.borderColor = UIColor.red
        signOutButton.borderRadius = 10
        signOutButton.lineWidth = 2
        signOutButton.frame = CGRect(x: (self.view.frame.width/2) - 107.5, y: (self.changeEmailButton.frame.origin.y + self.changeEmailButton.frame.height) + 6, width: 215, height: 50)
        signOutButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 30)
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
        self.view.addSubview(signOutButton)
        
        //Color buttons
        let colors = UIColor.mainColorArray
        
        let topSpace = doneButton.frame.origin.y + doneButton.frame.height
        let safeZoneBottomSpace = self.view.safeAreaInsets.bottom
        
        let remainingY = self.view.frame.height - (safeZoneBottomSpace + 50 + topSpace)
        
        let spacePerColor = remainingY / CGFloat(colors.count)
        
        var currentColor: CGFloat = 0
        
        Colors.allCases.forEach { color in
            
            let updateColorTap = ColorTap(target: self, action: #selector(setNewMainColor(sender:)))
            updateColorTap.color = color
            
            let newColorView = ColorView(frame: CGRect(x: 15, y: (topSpace + (spacePerColor * currentColor)), width: 42, height: 42), color: color, selected: false)
            print(newColorView.frame)
            
            self.view.addSubview(newColorView)
            
            newColorView.addGestureRecognizer(updateColorTap)
            
            currentColor += 1
            print(currentColor)
            
        }
    }
    
    @objc private func signOut() {
        
        AuthActions.signOut()
        self.present(SignInController(), animated: true, completion: nil)
    }
    
    //107.5 less then the middle
    
    //The next button is going to be 40 px below the circle
    
    @objc private func setNewMainColor(sender: ColorTap) {
        //Going to send the thing to change the color in the uicolor databse
        UIColor.setMainColor(sender.color)
        //Going to change the colors that you can see here
        UIView.animate(withDuration: 1) {
            self.nameLabel.textColor = UIColor.retrieveMainColor(withAlpha: 1.0)
            self.view.backgroundColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        }
        //Going to show that the color is selected by adding a checkmark
        
    }
    
    @objc private func showMainPage() {
        self.present(WorkView(), animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        
        moveView()
        
    }
    
}
