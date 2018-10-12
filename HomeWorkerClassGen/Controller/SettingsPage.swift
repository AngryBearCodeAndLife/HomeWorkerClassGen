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
    
    @IBOutlet weak var slantedViewBack: SlantedView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var doneButton: RoundedButtons!
    
    let profilePictureView = UIImageView()
    
    func moveView() {
        slantedViewBack.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 128)
        nameLabel.frame = CGRect(x: 0, y: 40, width: self.view.frame.width, height: 45)
        nameLabel.textAlignment = .center
        doneButton.frame = CGRect(x: (self.view.frame.width * 0.75) - 50, y: 100, width: 100, height: 35)
    }
    
    override func viewDidLoad() {
        sleep(3)
        
        moveView()
        
        //Show the color options
        //let colorCount = UIColor.mainColorOptionCount
        let colors = UIColor.mainColorArray
        
        let topSpace = doneButton.frame.origin.y + doneButton.frame.height
        let safeZoneBottomSpace = self.view.safeAreaInsets.bottom
        
        let remainingY = self.view.frame.height - (safeZoneBottomSpace + 50 + topSpace)
        
        let spacePerColor = remainingY / CGFloat(colors.count)
        
        var currentColor: CGFloat = 0
        
        for color in colors {
            
            //Create the color view
            let newColorView = UIView(frame: CGRect(x: 15, y: (topSpace + (spacePerColor * currentColor)), width: 42, height: 42))
            
            newColorView.backgroundColor = color
            newColorView.layer.borderColor = UIColor.white.cgColor
            newColorView.layer.borderWidth = 3
            newColorView.layer.cornerRadius = 21
            
            self.view.addSubview(newColorView)
            
            currentColor += 1
            
        }
        
        //Setup the imageview
        
        profilePictureView.backgroundColor = UIColor.gray
        profilePictureView.frame = CGRect(x: self.view.frame.width * 0.5 - (self.view.frame.width * 0.3), y: slantedViewBack.frame.height + 20, width: self.view.frame.width * 0.6, height: self.view.frame.width * 0.6)
        profilePictureView.layer.cornerRadius = profilePictureView.frame.width / 2
        
        self.view.addSubview(profilePictureView)
        
    }
    
}
