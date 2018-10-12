//
//  HomeWorkCell.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 9/27/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit

class HomeWorkCell: UITableViewCell {
    
    var homeWork: HomeWork! {
        didSet {
            //Call set function here
            guard let homework = homeWork else { return }
            setLabels(homework)
        }
    }
    
    //All of the labels
    var assignmentNameLabel = UILabel()
    var classLabel = UILabel()
    var dueDateLabel = UILabel()
    var timeLeftLabel = UILabel()
    
    //Variables that will be needed to detect and return a click
    var parentViewController: UIViewController!
    var destinationViewController: UIViewController!
    
    //The gesture recognizer that will tell me if it is selected
    let tap = UITapGestureRecognizer(target: self, action: #selector(showWorkPage))
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //change the styling and frames of all of these labels
        //Assignment label
        assignmentNameLabel.font = UIFont.systemFont(ofSize: 20)
        assignmentNameLabel.textAlignment = .left
        assignmentNameLabel.frame = CGRect(x: 12, y: 6, width: 180, height: 30)
        
        //Class Label
        classLabel.font = UIFont.systemFont(ofSize: 20)
        classLabel.textColor = UIColor.init(red: 139, green: 139, blue: 139, alpha: 1.0)
        classLabel.textAlignment = .left
        classLabel.frame = CGRect(x: 12, y: 42, width: 180, height: 30)
        
        //Due date label
        dueDateLabel.font = UIFont.systemFont(ofSize: 20)
        dueDateLabel.textColor = UIColor(red: 139, green: 139, blue: 139, alpha: 1.0)
        dueDateLabel.textAlignment = .right
        dueDateLabel.frame = CGRect(x: self.frame.width - 170, y: 6, width: 164, height: 30)
        
        //Time left label
        timeLeftLabel.font = UIFont.systemFont(ofSize: 20)
        timeLeftLabel.textAlignment = .right
        timeLeftLabel.frame = CGRect(x: self.frame.width - 136, y: 42, width: 130, height: 30)
        
        self.addGestureRecognizer(tap)
        
    }
    
    @objc private func showWorkPage() {
        
        parentViewController.present(destinationViewController, animated: true) {
            //THIS IS GOING TO HAVE TO CHNAGE TO BE CHANGING INTO THE SHOULD RELOAD VARIABLE TO BE ON
            //CANT DO THIS WITHOUT HAVING TO CREATE THAT CUSTOM VIEW CONTROLLER RIGHT NOW
            self.parentViewController.view.translatesAutoresizingMaskIntoConstraints = true
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //Function to change all of the labels in the cell, and to be able to return in
    private func setLabels(_ work: HomeWork) {
        assignmentNameLabel.text = work.assignmentName
        dueDateLabel.text = "Due: \(String(describing: work.endDateString))"
        classLabel.text = work.assignee
        
        //Turn the end date string into a date model so I can compare them
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        let endDate = dateFormatter.date(from: work.endDateString)
        
        let diffInDays = Calendar.current.dateComponents([.day], from: Date.init(), to: endDate!).day
        
        if diffInDays! >= 3 {
            timeLeftLabel.textColor = UIColor(red: 255/255, green: 201/255, blue: 119/255, alpha: 1.0)
        } else if diffInDays == 2 {
            timeLeftLabel.textColor = UIColor(red: 255/255, green: 160/255, blue: 119/255, alpha: 1.0)
        } else {
            timeLeftLabel.textColor = UIColor(red: 255/255, green: 27/255, blue: 27/255, alpha: 1.0)
        }
        
        timeLeftLabel.text = "\(String(describing: diffInDays)) Days Left"
        
    }
    
}
