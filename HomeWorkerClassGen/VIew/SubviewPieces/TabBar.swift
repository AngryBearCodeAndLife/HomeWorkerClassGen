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
    var profileImage = UIButton()
    
    public var width: CGFloat!
    public var optionSet: [String] = []
    
    var parentView: UIViewController!
    public var backView: UIViewController!
    
    var optionLabels: [UILabel] = []
    
    var isShowingOptions = false
    
    var canShowNewOptions = true
    
    public var parentIsAssignmentView: Bool! = false
    
    init(frame: CGRect, leftItem: Bool) {
        super.init(frame: frame)
        
        backView = WorkView()
        
        self.backgroundColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        
        setupLeftItem(leftItem)
        setupNewItem()
        setupProfileImage()
        
    }
    
    public func retrieveOptionFrames() -> [CGRect] {
        
        var frames: [CGRect] = []
        
        for label in optionLabels {
            frames.append(label.frame)
        }
        
        return frames
    }
    
    func setupProfileImage() {
        
        DataStorage.User.ProfileImage.fetch { picture in
            self.profileImage.setImage(picture, for: .normal)
            self.profileImage.backgroundColor = UIColor.darkGray
            self.profileImage.frame = CGRect(x: self.frame.width - 80, y: 5, width: 70, height: 70)
            self.profileImage.layer.masksToBounds = true
            self.profileImage.layer.cornerRadius = 35
            
            self.profileImage.addTarget(self, action: #selector(self.showProfilePage), for: .touchUpInside)
            
            self.addSubview(self.profileImage)
        }
    }
    
    @objc private func showProfilePage() {
        parentView.present(SettingsPage(), animated: true, completion: nil)
    }
    
    func setupNewItem() {
        newItemButton.backgroundColor = UIColor.white
        let colorString = "New" + UIColor.retrieveMainColorName() + "Bar"
        newItemButton.setImage(UIImage(named: colorString), for: .normal)
        newItemButton.frame = CGRect(x: self.frame.width/2 - 35, y: 5, width: 70, height: 70)
        newItemButton.layer.cornerRadius = 35
        newItemButton.addTarget(self, action: #selector(showNewWorkOptions), for: .touchUpInside)
        self.addSubview(newItemButton)
    }
    
    func setupLeftItem(_ communication: Bool) {
        
        leftItem.backgroundColor = UIColor.white
        if communication {
            let colorString = "Com" + UIColor.retrieveMainColorName() + "Bar"
            leftItem.setImage(UIImage(named: colorString), for: .normal)
        } else {
            let colorString = "Back" + UIColor.retrieveMainColorName() + "Bar"
            leftItem.setImage(UIImage(named: colorString), for: .normal)
            leftItem.addTarget(self, action: #selector(showWorkPage), for: .touchUpInside)
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
    
    @objc private func showWorkPage() {
        self.parentView.present(backView, animated: true, completion: nil)
    }
    
    public func optionFunction(_ location: CGPoint) {
        
        //Now that you can no longer oevrride what is already going on, it is safe to do whatever we wanted to do.
        
        for label in optionLabels {
            if label.frame.contains(location) {
                //An option was tapped. Let's figure out which one it was.
                print("Option was tapped")
                if label.text == "New Assignment" {
                    print("We are going to create a new assignment")
                    createAssignment()
                } else if label.text == "New Class" {
                    print("We are going to create a new class")
                    createClass()
                } else if label.text == "New Picture" {
                    //This one and the next one can only be called is the parent view was assignment view, as that is the only place where these will be used. So, we can assume that the view is assignment view, make the functions there, and just call a parentView.function()
                    let thisParentView = parentView as! AssignmentView
                    thisParentView.newPicture()
                } else if label.text == "New Note" {
                    let thisParentView = parentView as! AssignmentView
                    thisParentView.newNote()
                } else if label.text == "Add Drawing To Picture" {
                    let thisParentView = parentView as! AssignmentImageView
                    thisParentView.addDrawing()
                }
            }
         }
        
        hideOptions()
        
    }
    
    private func createAssignment() {
        let newObjectView = NewAssignmentViewController()
        newObjectView.modalPresentationStyle = .overCurrentContext
        parentView.present(newObjectView, animated: true, completion: nil)
    }
    
    private func createClass() {
        let newClassView = NewClassViewController()
        newClassView.modalPresentationStyle = .overCurrentContext
        parentView.present(newClassView, animated: true, completion: nil)
    }
    
    public func hideOptions() {
        
        for label in optionLabels {
            UIView.animate(withDuration: 0.6, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: [], animations: {
                
                label.frame = self.newItemButton.frame
                label.layer.cornerRadius = 35
                label.alpha = 0.0
                
                if self.optionSet[0] != "Add Drawing To Picture" {
                    self.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 80)
                }
                
            }) { _ in
                label.removeFromSuperview()
            }
        }
    
        //After all of this is done, and they arr no longer visible, set the options to false.
        isShowingOptions = false
        
    }
    
    @objc private func showNewWorkOptions() {
        
        if isShowingOptions == false {
            optionLabels.removeAll()
            
            var newFrame = CGRect(x: self.frame.width / 2 - CGFloat(0.5) * width, y: 90, width: width, height: 50)
            
            for option in optionSet {
                //Create a label which has a frame equal to the new view frame
                
                let newLabel = UILabel()
                newLabel.text = option
                newLabel.textColor = UIColor.retrieveMainColor(withAlpha: 1.0)
                newLabel.font = UIFont.systemFont(ofSize: 22)
                newLabel.textAlignment = .center
                newLabel.backgroundColor = UIColor.white.withAlphaComponent(0)
                newLabel.layer.borderWidth = 3
                newLabel.layer.borderColor = UIColor.retrieveMainColor(withAlpha: 1.0).cgColor
                newLabel.frame = newItemButton.frame
                newLabel.layer.cornerRadius = 35
                optionLabels.append(newLabel)
            }
            
            let newHeight: CGFloat = CGFloat(90 + (60 * optionSet.count))
            
            for label in optionLabels {
                self.addSubview(label)
                
                //Animate to the correct frame
                UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1.0, options: [], animations: {
                    self.frame = CGRect(x: self.frame.origin.x, y: self.frame.origin.y, width: self.frame.width, height: newHeight)
                    label.frame = newFrame
                    label.layer.cornerRadius = 15
                    //                label.backgroundColor = UIColor.white
                    //
                    label.textColor = UIColor.white
                    label.layer.borderColor = UIColor.white.cgColor
                    label.backgroundColor = UIColor.retrieveMainColor(withAlpha: 1.0)
                }, completion: nil)
                isShowingOptions = true
                newFrame = CGRect(x: newFrame.origin.x, y: newFrame.origin.y + 60, width: width, height: 50)
            }
        }
    }
}
