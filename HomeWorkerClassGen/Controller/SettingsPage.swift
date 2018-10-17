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
    
    func moveView() {
        slantedViewBack.backgroundColor = UIColor.white
        slantedViewBack.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 128)
        nameLabel.text = "Name"
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
        self.view.addSubview(slantedViewBack)
        self.view.addSubview(nameLabel)
        self.view.addSubview(doneButton)
        
        self.view.backgroundColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        
    }
    
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
    
    override func viewDidLoad() {
        
       
        
        moveView()
        
        //Show the color options
        //let colorCount = UIColor.mainColorOptionCount
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
            
            self.view.addSubview(newColorView)
            
            newColorView.addGestureRecognizer(updateColorTap)
            
            currentColor += 1
            
        }
        
        //Setup the imageview
        
        profilePictureView.backgroundColor = UIColor.gray
        profilePictureView.frame = CGRect(x: self.view.frame.width * 0.5 - (self.view.frame.width * 0.3), y: slantedViewBack.frame.height + 20, width: self.view.frame.width * 0.6, height: self.view.frame.width * 0.6)
        profilePictureView.layer.cornerRadius = profilePictureView.frame.width / 2
        
        self.view.addSubview(profilePictureView)
        
    }
    
}
