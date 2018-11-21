//
//  AssignmentImageView.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 11/21/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit

class AssignmentImageView: UIViewController {
    
    //Use this to hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    public var thisWork: HomeWork!
    public var thisImage: String!
    
    var imageView = UIImageView()
    var topBar: TabBar!
    
    var isShowingBar = true
    var canShowBar = true
    
    var doneButton: UIButton!
    var cancelButton: UIButton!
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor.black
        
        imageView.frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height - 80)
        imageView.contentMode = .scaleAspectFit
        imageView.image = DataStorage.WorkImages.Local.fetch(thisImage)
        self.view.addSubview(imageView)
        
        topBar = TabBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80), leftItem: false)
        topBar.parentView = self
        topBar.optionSet = ["Add Drawing To Picture"]
        topBar.width = 250
        let backView = AssignmentView()
        backView.thisWork = thisWork
        topBar.backView = backView
        self.view.addSubview(topBar)
    }
    
    public func addDrawing() {
        print("This is my new drawing")
        
        UIView.animate(withDuration: 0.3, animations: {
            self.topBar.frame = CGRect(x: 0, y: -80, width: self.view.frame.width, height: 80)
            self.imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        }) { _ in
            self.isShowingBar = false
            self.setupDrawing()
        }
    }
    
    func setupDrawing() {
        
        canShowBar = false
        
        doneButton = UIButton(frame: CGRect(x: 10, y: 10, width: 80, height: 30))
        doneButton.setTitle("Done", for: .normal)
        doneButton.titleLabel?.textAlignment = .left
        doneButton.setTitleColor(UIColor.retrieveMainColor(withAlpha: 1.0), for: .normal)
        doneButton.addTarget(self, action: #selector(doneDrawing), for: .touchUpInside)
        self.view.addSubview(doneButton)
        
        cancelButton = UIButton(frame: CGRect(x: self.view.frame.width - 90, y: 10, width: 80, height: 30))
        cancelButton.setTitle("Cancel", for: .normal)
        cancelButton.titleLabel?.textAlignment = .right
        cancelButton.setTitleColor(UIColor.warningColor, for: .normal)
        cancelButton.addTarget(self, action: #selector(cancelDrawing), for: .touchUpInside)
        self.view.addSubview(cancelButton)
    }
    
    @objc func doneDrawing() {
        //Eventually going to need to save the drawing to the image, and then override every instance that we have of it, and then show the tab bar, so they can stay and view, or go back to assignment
        
        //Only do this once we are able to save the image
        UIView.animate(withDuration: 0.3, animations: {
            self.topBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80)
            self.imageView.frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height - 80)
            self.doneButton.alpha = 0.0
            self.cancelButton.alpha = 0.0
        }) { _ in
            self.isShowingBar = true
            self.doneButton.removeFromSuperview()
            self.cancelButton.removeFromSuperview()
        }
        
        canShowBar = true
        
    }
    
    @objc func cancelDrawing() {
        //Need to get rid of the drawing, and not save it
        //Also, should ask if they are sure that they want to cancel
        UIView.animate(withDuration: 0.3, animations: {
            self.topBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80)
            self.imageView.frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height - 80)
            self.doneButton.alpha = 0.0
            self.cancelButton.alpha = 0.0
        }) { _ in
            self.isShowingBar = true
            self.doneButton.removeFromSuperview()
            self.cancelButton.removeFromSuperview()
        }
        
        canShowBar = true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if isShowingBar {
            
            if topBar.isShowingOptions {
                for touch in touches {
                    let loc = touch.location(in: topBar)
                    topBar.optionFunction(loc)
                }
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.topBar.frame = CGRect(x: 0, y: -80, width: self.view.frame.width, height: 80)
                    self.imageView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
                }) { _ in
                    self.isShowingBar = false
                }
            }
            
            //Need to hide it
        } else {
            //Need to show it
            
            if canShowBar {
                UIView.animate(withDuration: 0.3, animations: {
                    self.topBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80)
                    self.imageView.frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height - 80)
                }) { _ in
                    self.isShowingBar = true
                }
            }
        }
    }
}

