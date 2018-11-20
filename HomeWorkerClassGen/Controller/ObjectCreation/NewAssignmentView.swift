//
//  NewObjectView.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 10/24/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit

class NewAssignmentViewController: NewOptionViewController {
    
    let assignmentNameField = UITextField()
    
    let titleStrings = ["New Assignment", "Choose A Due Date"]
    let buttonStrings = ["Set Assignment Name", "Set Due Date"]
    var subViews: [UIView] = []
    
    var optionSubviews: [NewOptionSubView] = []
    var currentDisplayOption = -1
    
    var classes: [String] = []
    
    var newName: String!
    var newDueDate: Date!
    var newClass: String!
    
    //Use this to hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLoad() {
        
        DataStorage.ClassStorage.fetch { foundClasses in
            for theClass in foundClasses {
                self.classes.append(theClass.name)
            }
        }
        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        
//        sleep(5)
        
        //make all of the subviews now, and add them all to the view outside of where we can see it
        let viewOne = NewOptionSubView()
        viewOne.titleString = "New Assignment"
        viewOne.buttonString = "Set Assignment Name"
        viewOne.parentViewController = self
        //Configure the center item
        assignmentNameField.layer.cornerRadius = 10
        assignmentNameField.placeholder = "Assignment Name"
        assignmentNameField.font = UIFont.systemFont(ofSize: 20)
        assignmentNameField.layer.borderColor = UIColor.black.withAlphaComponent(0.4).cgColor
        assignmentNameField.textAlignment = .center
        assignmentNameField.layer.borderWidth = 1
        viewOne.subViewAction = assignmentNameField
        viewOne.centerHeight = 47
        viewOne.frame = CGRect(x: self.view.frame.width + 30, y: (self.view.frame.height / 2) - (viewOne.figureHeight() / 2), width: self.view.frame.width - 60, height: viewOne.figureHeight())
        viewOne.postionItems()
        
        let viewTwo = NewOptionSubView()
        viewTwo.titleString = "New Choose A Due Date"
        viewTwo.buttonString = "Set Due Date"
        viewTwo.parentViewController = self
        //Configure the center item
        
        let datepicker = UIDatePicker()
        datepicker.datePickerMode = .date
        datepicker.minimumDate = Date(timeIntervalSinceNow: 0)
        datepicker.tintColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        datepicker.setValue(UIColor.retrieveMainColor(withAlpha: 1.0), forKey: "textColor")
        
        let subViewTwo = UIView()
        subViewTwo.layer.cornerRadius = 20
        subViewTwo.backgroundColor = UIColor.retrieveMainColor(withAlpha: 0.7)
        
        viewTwo.subViewAction = datepicker
        viewTwo.centerHeight = 200
        viewTwo.frame = CGRect(x: self.view.frame.width + 30, y: (self.view.frame.height / 2) - (viewTwo.figureHeight() / 2), width: self.view.frame.width - 60, height: viewTwo.figureHeight())
        viewTwo.postionItems()
        
        let viewThree = NewOptionSubView()
        viewThree.titleString = "And finally, A Class"
        viewThree.buttonString = "FINISH"
        viewThree.parentViewController = self
        //Configure the center item
        
        let classPicker = UIPickerView()
        classPicker.dataSource = self
        classPicker.delegate = self
        classPicker.setValue(UIColor.retrieveMainColor(withAlpha: 1.0), forKey: "textColor")
        
        viewThree.subViewAction = classPicker
        viewThree.centerHeight = 150
        viewThree.frame = CGRect(x: self.view.frame.width + 30, y: (self.view.frame.height / 2) - (viewThree.figureHeight() / 2), width: self.view.frame.width - 60, height: viewThree.figureHeight())
        viewThree.postionItems()
        
        optionSubviews = [viewOne, viewTwo, viewThree]
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showNextOption()
    }
    
    override func showNextOption() {
        
        //If there is a new option, show the next one, and hide the last one.
        if currentDisplayOption == -1 {
            currentDisplayOption += 1
            self.view.addSubview(optionSubviews[currentDisplayOption])
            UIView.animate(withDuration: 0.4, animations: {
                self.optionSubviews[self.currentDisplayOption].frame = CGRect(x: 30, y: (self.view.frame.height / 2) - (self.optionSubviews[self.currentDisplayOption].figureHeight() / 2), width: self.view.frame.width - 60, height: self.optionSubviews[self.currentDisplayOption].figureHeight())
            }) { _ in
                print("What is going to happen next?")
            }
        } else if currentDisplayOption == 0 {
            //This means that the one thing showing right now is a text field that is asking for the name of the new assignment.
            let nameField = optionSubviews[currentDisplayOption].subViewAction as! UITextField
            
            if nameField.text != "" {
                //There is something in the text field. Save it
                
                self.newName = nameField.text
                
                //Hide this view, show the next one
                
                currentDisplayOption += 1
                self.view.addSubview(optionSubviews[currentDisplayOption])
                
                //hide the last one, show the next one
                UIView.animate(withDuration: 0.4, animations: {
                    self.optionSubviews[self.currentDisplayOption - 1].frame = CGRect(x: -self.view.frame.width, y: self.optionSubviews[self.currentDisplayOption - 1].frame.origin.y, width: self.optionSubviews[self.currentDisplayOption - 1].frame.width, height: self.optionSubviews[self.currentDisplayOption - 1].frame.height)
                    self.optionSubviews[self.currentDisplayOption].frame = CGRect(x: 30, y: (self.view.frame.height / 2) - (self.optionSubviews[self.currentDisplayOption].figureHeight() / 2), width: self.view.frame.width - 80, height: self.optionSubviews[self.currentDisplayOption].figureHeight())
                }) { _ in
                    print("What is going on here, im gone! I just hid one of the inbetween ones")
                }
                
                
            } else {
                //Shake the current view, and then highlight the field
                
                self.optionSubviews[currentDisplayOption].shake(count: 3, for: 0.2, withTranslation: 10)
                
            }
        } else if currentDisplayOption == 1 {
            
            let dateView = optionSubviews[currentDisplayOption].subViewAction as! UIDatePicker
            
            self.newDueDate = dateView.date
            
            currentDisplayOption += 1
            
            self.view.addSubview(optionSubviews[currentDisplayOption])
            
            UIView.animate(withDuration: 0.4, animations: {
                print(self.currentDisplayOption)
                self.optionSubviews[self.currentDisplayOption - 1].frame = CGRect(x: -self.view.frame.width, y: self.optionSubviews[self.currentDisplayOption - 1].frame.origin.y, width: self.optionSubviews[self.currentDisplayOption - 1].frame.width, height: self.optionSubviews[self.currentDisplayOption - 1].frame.height)
                self.optionSubviews[self.currentDisplayOption].frame = CGRect(x: 30, y: (self.view.frame.height / 2) - (self.optionSubviews[self.currentDisplayOption].figureHeight() / 2), width: self.view.frame.width - 80, height: self.optionSubviews[self.currentDisplayOption].figureHeight())
            }) { _ in
                print("What is going on here, im gone! I just hid one of the inbetween ones")
            }
            
        } else if currentDisplayOption == 2 {
            
            let newClassView = optionSubviews[currentDisplayOption].subViewAction as! UIPickerView
            
            self.newClass = classes[newClassView.selectedRow(inComponent: 0)]
            
            if self.newClass != "" {
                UIView.animate(withDuration: 0.4, animations: {
                    self.optionSubviews[self.currentDisplayOption].frame = CGRect(x: -self.view.frame.width, y: self.optionSubviews[self.currentDisplayOption].frame.origin.y, width: self.optionSubviews[self.currentDisplayOption].frame.width, height: self.optionSubviews[self.currentDisplayOption].frame.height)
                }) { _ in
                    
                    //We have all of the information(except for notifications) about how to make the new assignment.
                    let newAssignment = HomeWork(self.newName, self.newClass, true, self.newDueDate, "isdybiwusdioyrbfd")
                    
                    DataStorage.WorkObjects.save(newAssignment, completion: {
                        self.present(WorkView(), animated: true, completion: nil)
                    })
                }
            } else {
                optionSubviews[currentDisplayOption].shake(count: 3, for: 0.2, withTranslation: 10)
            }
            
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            let location = touch.location(in: self.view)
            if optionSubviews[currentDisplayOption].frame.contains(location) == false {
                //Eventually, here we will want to ask them if they want to disregard this current work they are making. This popup should show from the top, and take up the same amount of room that would be taken by this thing. Also should be able to be triggered by a downward pulling motion.
                self.present(WorkView(), animated: true, completion: nil)
            }
        }
    }
}

extension NewAssignmentViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return classes.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return classes[row]
    }
    
    
}
