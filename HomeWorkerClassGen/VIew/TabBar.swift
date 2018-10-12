//
//  TabBar.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 9/27/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit

class TabBar: UIView {
    
    //The three subviews of the top bar. They are going to be buttons so that we can get the aniation, and we don't need to mutate them too much at all
    
    var leftItem = UIButton()
    var newItemButton = UIButton()
    var profileImage = UIImageView()
    
    public var width: CGFloat!
    public var optionSet: [String] = []
    
    override init(frame: CGRect, leftItem: Bool) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        
        setupLeftItem(leftItem)
        setupNewItem()
        setupProfileImage()
        
    }
    
    func setupProfileImage() {
        profileImage.image = UIImage(named: "first")
        profileImage.frame = CGRect(x: self.frame.width - 80, y: 5, width: 70, height: 70)
        profileImage.layer.masksToBounds = true
        profileImage.layer.cornerRadius = 35
        self.addSubview(profileImage)
    }
    
    func setupNewItem() {
        newItemButton.backgroundColor = UIColor.white
        newItemButton.setImage(UIImage(named: "newItem"), for: .normal)
        newItemButton.frame = CGRect(x: self.frame.width/2 - 35, y: 5, width: 70, height: 70)
        newItemButton.layer.cornerRadius = 35
        newItemButton.addTarget(self, action: #selector(showNewWorkOptions), for: .touchUpInside)
        self.addSubview(newItemButton)
    }
    
    func setupLeftItem(_ communication: Bool) {
        
        leftItem.backgroundColor = UIColor.white
        if communication {
            leftItem.setImage(UIImage(named: "communicationImage"), for: .normal)
        } else {
            leftItem.setImage(UIImage(named: "backImage"), for: .normal)
        }
        leftItem.frame = CGRect(x: 10, y: 5, width: 70, height: 70)
        leftItem.layer.cornerRadius = 35
        self.addSubview(leftItem)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func updateBackgroundColor() {
        self.backgroundColor = UIColor.retrieveMainColor(withAlpha: 1.0)
    }
    
    @objc private func showCommunicationPage() {
        //Show the communication page, this function should somehow get the view controller that is sending it, so that we can return it, and we should have the view controller that is going to be presented in place of the actual communication page
    }
    
    @objc private func showNewWorkOptions() {
        var optionLabels: [UILabel] = []
        var newFrame = CGRect(x: self.frame.width / 2 - CGFloat(0.5) * width, y: 90, width: width, height: 50)
        
        for option in optionSet {
            //Create a label which has a frame equal to the new view frame
            
            let newLabel = UILabel()
            newLabel.text = option
            newLabel.textColor = UIColor.retrieveMainColor(withAlpha: 1.0)
            newLabel.backgroundColor = UIColor.white.withAlphaComponent(0)
            newLabel.layer.borderWidth = 3
            newLabel.layer.borderColor = UIColor.retrieveMainColor(withAlpha: 1.0).cgColor
            newLabel.frame = newItemButton.frame
            newLabel.layer.cornerRadius = 35
            optionLabels.append(newLabel)
        }
        
        for label in optionLabels {
            self.addSubview(label)
            //Animate to the correct frame
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: [], animations: {
                label.frame = newFrame
                label.layer.cornerRadius = 15
            }, completion: nil)
            newFrame = CGRect(x: newFrame.origin.x, y: newFrame.origin.y + 60, width: width, height: 50)
        }
    }
}
