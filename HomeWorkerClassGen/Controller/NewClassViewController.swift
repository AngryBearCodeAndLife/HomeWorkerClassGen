//
//  NewClassViewController.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 11/3/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit

class NewClassViewController: NewOptionViewController {
    
    let titleStrings = ["New Assignment", "Choose A Due Date"]
    let buttonStrings = ["Set Assignment Name", "Set Due Date"]
    var subViews: [UIView] = []
    
    var optionSubviews: [NewOptionSubView] = []
    var currentDisplayOption = -1
    
    let classes = ["Algebra I", "Biology", "Chemistry", "US History", "English"]
    
    var newName: String!
    var newDueDate: Date!
    var newClass: String!
    
    let whichClassView = NewOptionSubView()
    
    var classWithCode = true
    
    var decisionMade = false
    
    let lastView = NewOptionSubView()
    
    var classInformation: String!
    
    //Use this to hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showDecision()
    }
    
    private func showDecision() {
        whichClassView.titleString = "New Class"
        whichClassView.buttonString = "Enter Class Code"
        whichClassView.parentViewController = self
        //Configure the center item
        
        let newGenericClass = RoundedButtons()
        newGenericClass.borderColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        newGenericClass.borderRadius = 10
        newGenericClass.lineWidth = 2
        newGenericClass.setTitle("New Generic Class", for: .normal)
        newGenericClass.setTitleColor(UIColor.retrieveMainColor(withAlpha: 1.0), for: .normal)
        newGenericClass.titleLabel?.textColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        newGenericClass.addTarget(self, action: #selector(createGeneric), for: .touchUpInside)
        
        whichClassView.subViewAction = newGenericClass
        whichClassView.centerHeight = 32
        whichClassView.frame = CGRect(x: self.view.frame.width + 30, y: (self.view.frame.height / 2) - (whichClassView.figureHeight() / 2), width: self.view.frame.width - 60, height: whichClassView.figureHeight())
        whichClassView.postionItems()
        self.view.addSubview(whichClassView)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [], animations: {
            
            self.whichClassView.frame = CGRect(x: 30, y: (self.view.frame.height / 2) - (self.whichClassView.figureHeight() / 2), width: self.view.frame.width - 60, height: self.whichClassView.figureHeight())
            
        }) { _ in
            print("Done")
        }
        
    }
    
    override func showNextOption() {
        //This is is going to be called if we want to create a class based on a class code
        print("Going to creare a class with a code")
        
        if !decisionMade {
            showStringEnter()
        } else {
            //Hide the lastview
            
            let informationField = lastView.subViewAction as! UITextField
            classInformation = informationField.text
            
            UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [], animations: {
                
                self.lastView.frame = CGRect(x: -self.view.frame.width, y: self.lastView.frame.origin.y, width: self.lastView.frame.width, height: self.lastView.frame.height)
                
            }) { _ in
                self.createClassFinalStep()
                self.present(WorkView(), animated: true, completion: nil)
            }
            
        }
        
    }
    
    private func createClassFinalStep() {
        
        //Do the thing to create the class
        if classWithCode {
            //Send the networking request, or just write it so that the FirebaseActions has the methods to set this up
        } else {
            //Send the new generic class to the cloud under the acount uid, and then also store it locally.
        }
        
    }
    
    @objc private func createGeneric() {
        //Called to create a generic class
        print("GOing to create a class that is generic")
        
        classWithCode = false
        showStringEnter()
        
        
    }
    
    private func showStringEnter() {
        
        decisionMade = true
        
        lastView.titleString = classWithCode ? "Enter Code From Teacher" : "Enter Your Class Name"
        lastView.buttonString = classWithCode ? "Join Class" : "Create Class"
        lastView.parentViewController = self
        //Configure the center item
        
        let classInformationField = UITextField()
        classInformationField.placeholder = classWithCode ? "Class Code" : "Class Name"
        classInformationField.font = UIFont.systemFont(ofSize: 20)
        classInformationField.textColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        classInformationField.keyboardType = classWithCode ? UIKeyboardType.numberPad : UIKeyboardType.default
        
        lastView.subViewAction = classInformationField
        lastView.centerHeight = 47
        lastView.frame = CGRect(x: self.view.frame.width + 30, y: (self.view.frame.height / 2) - (lastView.figureHeight() / 2), width: self.view.frame.width - 60, height: lastView.figureHeight())
        lastView.postionItems()
        self.view.addSubview(lastView)
        
        UIView.animate(withDuration: 0.5, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 1.0, options: [], animations: {
            self.whichClassView.frame = CGRect(x: -self.view.frame.width, y: self.whichClassView.frame.origin.y, width: self.whichClassView.frame.width, height: self.whichClassView.frame.height)
            self.lastView.frame = CGRect(x: 30, y: (self.view.frame.height / 2) - (self.lastView.figureHeight() / 2), width: self.view.frame.width - 60, height: self.lastView.figureHeight())
            
        }) { _ in
            print("Done")
        }
        
    }
    
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self.view)
            
            var viewToTouch: UIView!
            
            if !decisionMade {
                viewToTouch = whichClassView
            } else {
                viewToTouch = lastView
            }
            
            if viewToTouch.frame.contains(location) == false {
                self.present(WorkView(), animated: true, completion: nil)
            }
        }
    }
}

