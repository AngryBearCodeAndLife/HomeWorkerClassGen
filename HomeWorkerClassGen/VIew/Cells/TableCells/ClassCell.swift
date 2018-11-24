//
//  ClassCell.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 11/24/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit

class ClassCell: UITableViewCell {
    
    var thisClass: Classes! {
        didSet {
            setLabels()
        }
    }
    
    var width: CGFloat!
    
    var nameLabel = UILabel()
    var teacherLabel = UILabel()
    var assignmentCount = UILabel()
    var assignmentLabel = UILabel()
    
    func setLabels() {
        
        if thisClass.teacherCreated {
            //SHare the space on the right side with teacher
            nameLabel.frame = CGRect(x: 6, y: 6, width: width, height: 30)
            nameLabel.textAlignment = .left
            nameLabel.text = thisClass.name
            self.addSubview(nameLabel)
            
            teacherLabel.frame = CGRect(x: 6, y: 44, width: width, height: 30)
            teacherLabel.textAlignment = .left
            teacherLabel.text = "Ms. Blair"
            teacherLabel.textColor = UIColor.black.withAlphaComponent(0.7)
            self.addSubview(teacherLabel)
            
        } else {
            //Make the classname label take up most of the left side, there isnt a teacher to display
            nameLabel.frame = CGRect(x: 6, y: 12, width: width, height: 56)
            nameLabel.textAlignment = .left
            nameLabel.text = thisClass.name
            self.addSubview(nameLabel)
        }
        
        //Make the assignment labels on the other side
        
        //80-14=66
        //66/3 = 22
        
        var howManyAssignments = 0
        
        assignmentCount.frame = CGRect(x: width - 80, y: 6, width: 72, height: 44)
        assignmentCount.textAlignment = .center
        assignmentCount.font = UIFont.systemFont(ofSize: 40, weight: UIFont.Weight.ultraLight)
        DataStorage.WorkObjects.fetch { allWorks in
            for work in allWorks {
                if work.assignee == self.thisClass.name {
                    howManyAssignments += 1
                }
            }
            self.assignmentCount.text = "\(howManyAssignments)"
        }
        self.addSubview(assignmentCount)
        
        assignmentLabel.frame = CGRect(x: width - 80, y: 54, width: 72, height: 18)
        assignmentLabel.font = UIFont.systemFont(ofSize: 12, weight: .light)
        assignmentLabel.text = howManyAssignments != 1 ? "Assignments" : "Assignment"
        assignmentLabel.textAlignment = .center
        self.addSubview(assignmentLabel)
    }
    
}
