//
//  File.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 10/12/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit

class AssignmentView: UIViewController {
    
    var work: HomeWork! {
        didSet {
            //Run the function to set all of the things, and retrieve what I need
        }
    }
    
    //All of the labels and uicollectionviews that I am going to need
    
    var topBar = TabBar(frame: CGRect(), leftItem: false)
    
    var assignmentNameLabel = UILabel()
    var assignerLabel = UILabel()
    var dueLabel = UILabel()
    
    var notesLabel = UILabel()
    var picturesLabel = UILabel()
    
    var noteCollectionView = UICollectionView()
    var pictureCollectionView = UICollectionView()
    
    override func viewDidLoad() {
        setPositions()
    }
    
    private func setPositions() {
        topBar.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80)
        self.view.addSubview(topBar)
        
        // Assignment information labels
        assignmentNameLabel.text = work.assignmentName
        assignmentNameLabel.font = UIFont.systemFont(ofSize: 38)
        assignmentNameLabel.textColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        assignmentNameLabel.textAlignment = .center
        assignmentNameLabel.frame = CGRect(x: 0, y: 85, width: self.view.frame.width, height: 50)
        self.view.addSubview(assignmentNameLabel)
        
        assignerLabel.text = "Assigned By: Mr. Cousins" // NEED TO MAKE THIS NON HARD CODED
        assignerLabel.font = UIFont.systemFont(ofSize: 20)
        assignerLabel.textColor = UIColor.retrieveMainColor(withAlpha: 0.7)
        assignerLabel.textAlignment = .center
        assignerLabel.frame = CGRect(x: 0, y: 140, width: self.view.frame.width, height: 30)
        self.view.addSubview(assignerLabel)
        
    }
    
}
