//
//  File.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 10/12/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit

class AssignmentView: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    //Use this to hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //All of the screen assets that you are going to need
    
    var topBar: TabBar!
    
    var assignmentNameLabel = UILabel()
    var assigneeLabel = UILabel()
    var dueDateLabel = UILabel()
    
    let layout = UICollectionViewFlowLayout()
    var pictureCollection: UICollectionView!
    var noteCollection: UICollectionView!
    
    let noteLabel = UILabel()
    let pictureLabel = UILabel()
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.white
        
        setupTabbar()
        setupAssignmentLabels()
        setupPictureCollection()
        setupLabels()
        
        //register the collectoin view class
        pictureCollection.register(AssignmentCell.self, forCellWithReuseIdentifier: "cellId")
        noteCollection.register(AssignmentCell.self, forCellWithReuseIdentifier: "cellId")
        
    }
    
    func setupLabels() {
        
        noteLabel.frame = CGRect(x: 6, y: noteCollection.frame.origin.y - 28, width: 100, height: 24)
        noteLabel.text = "Notes"
        noteLabel.font = UIFont.systemFont(ofSize: 22)
        noteLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        noteLabel.textAlignment = .left
        self.view.addSubview(noteLabel)
        
        pictureLabel.frame = CGRect(x: 6, y: pictureCollection.frame.origin.y - 28, width: 100, height: 24)
        pictureLabel.text = "Pictures"
        pictureLabel.font = UIFont.systemFont(ofSize: 22)
        pictureLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        pictureLabel.textAlignment = .left
        self.view.addSubview(pictureLabel)
        
    }
    
    func setupTabbar() {
        
        topBar = TabBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80), leftItem: false)
        topBar.parentView = self
        self.view.addSubview(topBar)
        
    }
    
    func setupAssignmentLabels() {
        
        assignmentNameLabel.frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: 55)
        assignmentNameLabel.textColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        assignmentNameLabel.font = UIFont.systemFont(ofSize: 38)
        assignmentNameLabel.textAlignment = .center
        assignmentNameLabel.text = "Assignment Name!"
        self.view.addSubview(assignmentNameLabel)
        
        assigneeLabel.frame = CGRect(x: 0, y: 130, width: self.view.frame.width, height: 29)
        assigneeLabel.textColor = UIColor.black
        assigneeLabel.font = UIFont.systemFont(ofSize: 22)
        assigneeLabel.textAlignment = .center
        assigneeLabel.text = "Assigned By: Instructor"
        self.view.addSubview(assigneeLabel)
        
        dueDateLabel.frame = CGRect(x: 0, y: 157, width: self.view.frame.width, height: 29)
        dueDateLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        dueDateLabel.font = UIFont.systemFont(ofSize: 22)
        dueDateLabel.textAlignment = .center
        dueDateLabel.text = "Due: MM/DD/YY"
        self.view.addSubview(dueDateLabel)
        
    }
    
    func setupPictureCollection() {
        
        layout.scrollDirection = .horizontal
        
        pictureCollection = UICollectionView(frame: CGRect(x: 0, y: self.view.frame.height - 193, width: self.view.frame.width, height: 165), collectionViewLayout: layout)
        pictureCollection.delegate = self
        pictureCollection.dataSource = self
        pictureCollection.backgroundColor = UIColor.white
        pictureCollection.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.view.addSubview(pictureCollection)
        
        noteCollection = UICollectionView(frame: CGRect(x: 0, y: self.view.frame.height - 411, width: self.view.frame.width, height: 165), collectionViewLayout: layout)
        noteCollection.delegate = self
        noteCollection.dataSource = self
        noteCollection.backgroundColor = UIColor.white
        noteCollection.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.view.addSubview(noteCollection)
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == pictureCollection {
            //Return the number of pictures in the homework assignment
            return 12
        } else {
            //Return the number of notes in an assignment
            return 5
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! AssignmentCell
        if collectionView == pictureCollection {
            cell.picture = UIImage(named: "dog1")
        } else {
            cell.title = "Hello world!"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 134, height: 165)
    }
    
}
