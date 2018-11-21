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
    
    public var thisWork: HomeWork! {
        didSet {
            setupAssignmentLabels()
        }
    }
    
    var assignmentNameLabel = UILabel()
    var assigneeLabel = UILabel()
    var dueDateLabel = UILabel()
    
    let layout = UICollectionViewFlowLayout()
    var pictureCollection: UICollectionView!
    var noteCollection: UICollectionView!
    
    let noteLabel = UILabel()
    let pictureLabel = UILabel()
    
    var imagePicker: UIImagePickerController!
    
    var thisWorkImages: [UIImage] = []
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.white
    
        setupPictureCollection()
        setupLabels()
        
        
        //register the collectoin view class
        pictureCollection.register(AssignmentCell.self, forCellWithReuseIdentifier: "cellId")
//        noteCollection.register(AssignmentCell.self, forCellWithReuseIdentifier: "cellId")
        
    }
    
    func setupLabels() {
        
//        noteLabel.frame = CGRect(x: 6, y: noteCollection.frame.origin.y - 28, width: 100, height: 24)
//        noteLabel.text = "Notes"
//        noteLabel.font = UIFont.systemFont(ofSize: 22)
//        noteLabel.textColor = UIColor.black.withAlphaComponent(0.8)
//        noteLabel.textAlignment = .left
//        self.view.addSubview(noteLabel)
        
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
        topBar.optionSet = ["New Picture", "New Note"]
        topBar.width = 200
        self.view.addSubview(topBar)
        
    }
    
    func setupAssignmentLabels() {
        
        print(thisWork)
        
        for imgId in thisWork.images {
            print(imgId)
            thisWorkImages.append(DataStorage.WorkImages.Local.fetch(imgId))
        }
        
        print("These are all of the images that I should have for my assignment", thisWorkImages)
        
        assignmentNameLabel.frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: 55)
        assignmentNameLabel.textColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        assignmentNameLabel.font = UIFont.systemFont(ofSize: 38)
        assignmentNameLabel.textAlignment = .center
        assignmentNameLabel.text = thisWork.assignmentName!
        self.view.addSubview(assignmentNameLabel)
        
        assigneeLabel.frame = CGRect(x: 0, y: 130, width: self.view.frame.width, height: 29)
        assigneeLabel.textColor = UIColor.black
        assigneeLabel.font = UIFont.systemFont(ofSize: 22)
        assigneeLabel.textAlignment = .center
        assigneeLabel.text = "Assigned By: \(thisWork.assignee!)"
        self.view.addSubview(assigneeLabel)
        
        dueDateLabel.frame = CGRect(x: 0, y: 157, width: self.view.frame.width, height: 29)
        dueDateLabel.textColor = UIColor.black.withAlphaComponent(0.8)
        dueDateLabel.font = UIFont.systemFont(ofSize: 22)
        dueDateLabel.textAlignment = .center
        dueDateLabel.text = "Due: \(thisWork.endDateString!)"
        self.view.addSubview(dueDateLabel)
    
        setupTabbar()
    }
    
    func setupPictureCollection() {
        
        layout.scrollDirection = .horizontal
        
        pictureCollection = UICollectionView(frame: CGRect(x: 0, y: self.view.frame.height - 193, width: self.view.frame.width, height: 165), collectionViewLayout: layout)
        pictureCollection.delegate = self
        pictureCollection.dataSource = self
        pictureCollection.backgroundColor = UIColor.white
        pictureCollection.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.view.addSubview(pictureCollection)
        
//        noteCollection = UICollectionView(frame: CGRect(x: 0, y: self.view.frame.height - 411, width: self.view.frame.width, height: 165), collectionViewLayout: layout)
//        noteCollection.delegate = self
//        noteCollection.dataSource = self
//        noteCollection.backgroundColor = UIColor.white
//        noteCollection.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
//        self.view.addSubview(noteCollection)
        
    }
    
    public func newPicture() {
        
        imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.delegate = self
        
        sourceFigure()
        
    }
    
    public func newNote() {
        print("Going to create a new note")
    }
    
    func sourceFigure() {
        let choice = UIAlertController(title: "New Picture Source", message: "Where would you like to import the new image from?", preferredStyle: .actionSheet)
        choice.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action) in
            self.imagePicker.sourceType = .camera
            choice.dismiss(animated: true, completion: nil)
            self.showPicker()
        }))
        choice.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action) in
            self.imagePicker.sourceType = .photoLibrary
            choice.dismiss(animated: true, completion: nil)
            self.showPicker()
        }))
        self.present(choice, animated: true, completion: nil)
    }
    
    func showPicker() {
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        if collectionView == pictureCollection {
            //Return the number of pictures in the homework assignment
            print("We are giving the picturw colection view this many images", thisWorkImages.count)
            return thisWorkImages.count + 1
        } else {
            //Return the number of notes in an assignment
            return 5
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == pictureCollection {
            if indexPath.row == thisWorkImages.count {
                newPicture()
            } else {
                let imageView = AssignmentImageView()
                imageView.thisWork = thisWork
                imageView.thisImage = thisWork.images[indexPath.row]
                self.present(imageView, animated: true, completion: nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("This is the indexpath.row that i am talkign about", indexPath.row)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! AssignmentCell
        if collectionView == pictureCollection {
            print(indexPath)
            if indexPath.row < thisWorkImages.count {
                cell.picture = thisWorkImages[indexPath.row]
            } else {
                let newImageName = "New" + UIColor.retrieveMainColorName()
                cell.picture = UIImage(named: newImageName)
            }
        } else {
            cell.title = "Hello world!"
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 134, height: 165)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            
            if topBar.isShowingOptions {
                topBar.optionFunction(touch.location(in: self.view))
            }
        }
    }
    
}

extension AssignmentView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            print("Is trying to save the image")
            //use pickedImage to go to the dataStorage, and save the picture to the assignment
            DataStorage.WorkImages.newImage(pickedImage, with: thisWork) { _ in
                
                self.thisWorkImages.append(pickedImage)
                self.pictureCollection.reloadData()
                
                print("Successfully saved the image and the workn\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
