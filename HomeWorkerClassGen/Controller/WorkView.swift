//
//  WorkTableAndBar.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 10/8/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit

class WorkView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //THIS IS NOT GOING TO WORK, THE HOMEWORK IS GOING TO CRASH WHEN LOADED, BECAUSE IT DOES NOT HAVE A VALID END DATE STRING
    
    //Use this to hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
//    var work: [HomeWork] = [HomeWork("Packer", "Laich", false, Date.distantFuture, "wufoewubw"), HomeWork("Reading", "Cousins", false, Date.distantFuture, "wufoewubw"), HomeWork("Chapter", "Blair", false, Date.distantFuture, "wufoewubw"), HomeWork("Origami", "Haven", false, Date.distantFuture, "wufoewubw"), HomeWork("To Kill A Mockingbird", "Chamoff", false, Date.distantFuture, "wufoewubw"), HomeWork("Diagram", "Tanquay", false, Date.distantFuture, "wufoewubw")]
    
    var work: [HomeWork] = []
    
    var table = UITableView()
    
    let refreshGesture = UIRefreshControl()
    
    var topBar: TabBar!
    
    var middleBox = UIView()
    
    //Middle box items
    var organizeButton = UIButton()
    var statusLabel = UILabel()
    var isShowingMiddle = false
    var alphaOrganize: UIButton!
    var dateOrganize: UIButton!
    var classOrganize: UIButton!
    
    override func viewDidLoad() {
        
        self.view.backgroundColor = UIColor.white
        
        DataStorage.WorkObjects.fetch(completion: { homework in
            self.work = homework
            
            self.placeTableView()
            self.readyBar()
        })
        
    }
    
    func readyBar() {
        
        middleBox.frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: 35)
        middleBox.backgroundColor = UIColor.retrieveMainColor(withAlpha: 0.1)
        self.view.addSubview(middleBox)
        
        topBar = TabBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80), leftItem: true)
        topBar.optionSet = ["New Assignment", "New Class"]
        topBar.width = 200
        topBar.parentView = self
        self.view.addSubview(topBar)
        
        placeItemsMiddleBox()
    }
    
    func placeItemsMiddleBox() {
    
        organizeButton.frame = CGRect(x: 10, y: 2.5, width: 40, height: 30)
        organizeButton.layer.cornerRadius = 15
        organizeButton.backgroundColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        organizeButton.addTarget(self, action: #selector(organizeDropdown), for: .touchUpInside)
        middleBox.addSubview(organizeButton)
        
        alphaOrganize = UIButton(frame: organizeButton.frame)
        dateOrganize = UIButton(frame: organizeButton.frame)
        classOrganize = UIButton(frame: organizeButton.frame)
        
        statusLabel.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 30)
        statusLabel.textAlignment = .center
        statusLabel.textColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        statusLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.thin)
        statusLabel.text = "Last Update: 5 Min ago"
        middleBox.addSubview(statusLabel)
    }
    
    @objc func organizeDropdown() {
        
        if isShowingMiddle == false {
            //Need to create the new organize options here
            
            alphaOrganize.backgroundColor = UIColor.retrieveMainColor(withAlpha: 1.0)
            alphaOrganize.addTarget(self, action: #selector(organizeByName), for: .touchUpInside)
            alphaOrganize.layer.cornerRadius = 15
            alphaOrganize.setTitle("By Name", for: .normal)
            alphaOrganize.setTitleColor(UIColor.white.withAlphaComponent(0.0), for: .normal)
            
            dateOrganize.backgroundColor = UIColor.retrieveMainColor(withAlpha: 1.0)
            dateOrganize.addTarget(self, action: #selector(organizeByDate), for: .touchUpInside)
            dateOrganize.layer.cornerRadius = 15
            dateOrganize.setTitle("By Date", for: .normal)
            dateOrganize.setTitleColor(UIColor.white.withAlphaComponent(0.0), for: .normal)
            
            classOrganize.backgroundColor = UIColor.retrieveMainColor(withAlpha: 1.0)
            classOrganize.addTarget(self, action: #selector(organizeByClass), for: .touchUpInside)
            classOrganize.layer.cornerRadius = 15
            classOrganize.setTitle("By Class", for: .normal)
            classOrganize.setTitleColor(UIColor.white.withAlphaComponent(0.0), for: .normal)
            middleBox.addSubview(alphaOrganize)
            middleBox.addSubview(dateOrganize)
            middleBox.addSubview(classOrganize)
            
            UIView.animate(withDuration: 0.5, animations: {
                self.statusLabel.textColor = UIColor.retrieveMainColor(withAlpha: 0.0)
                let organizeFrameWidth = (self.view.frame.width - 90) / 3
                self.alphaOrganize.alpha = 1.0
                self.dateOrganize.alpha = 1.0
                self.classOrganize.alpha = 1.0
                self.alphaOrganize.frame = CGRect(x: 60, y: 2.5, width: organizeFrameWidth, height: 30)
                self.alphaOrganize.setTitleColor(UIColor.white, for: .normal)
                self.dateOrganize.frame = CGRect(x: 70 + organizeFrameWidth, y: 2.5, width: organizeFrameWidth, height: 30)
                self.dateOrganize.setTitleColor(UIColor.white, for: .normal)
                self.classOrganize.frame = CGRect(x: 80 + (organizeFrameWidth * 2), y: 2.5, width: organizeFrameWidth, height: 30)
                self.classOrganize.setTitleColor(UIColor.white, for: .normal)
            }) { _ in
                self.isShowingMiddle = true
            }
        } else {
            UIView.animate(withDuration: 0.5, animations: {
                self.statusLabel.textColor = UIColor.retrieveMainColor(withAlpha: 1.0)
                self.alphaOrganize.frame = self.organizeButton.frame
                self.dateOrganize.frame = self.organizeButton.frame
                self.classOrganize.frame = self.organizeButton.frame
                self.alphaOrganize.alpha = 0.0
                self.dateOrganize.alpha = 0.0
                self.classOrganize.alpha = 0.0
            }) { _ in
                self.isShowingMiddle = false
            }
        }
    }
    
    @objc func organizeByClass() {
        print("organizing by class")
        work = work.sorted(by: { $0.assignee < $1.assignee })
        let range = NSMakeRange(0, self.table.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.table.reloadSections(sections as IndexSet, with: .automatic)
        organizeDropdown()
    }
    
    @objc func organizeByDate() {
        
        print("Organizing by date")
        work = work.sorted(by: { WorkTools.turnToDate(dateString: $0.endDateString) < WorkTools.turnToDate(dateString: $1.endDateString) })
        let range = NSMakeRange(0, self.table.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.table.reloadSections(sections as IndexSet, with: .automatic)
        organizeDropdown()
    }
    
    @objc func organizeByName() {
        work = work.sorted(by: { $0.assignmentName < $1.assignmentName })
        let range = NSMakeRange(0, self.table.numberOfSections)
        let sections = NSIndexSet(indexesIn: range)
        self.table.reloadSections(sections as IndexSet, with: .automatic)
        organizeDropdown()
    }
    
//    A -> Z
    
    func placeTableView() {
        
        table.frame = CGRect(x: 0, y: 115, width: self.view.frame.width, height: self.view.frame.height - 115)
        table.delegate = self
        table.dataSource = self
        
        table.register(HomeWorkCell.self, forCellReuseIdentifier: "workCell")
        table.register(PhotoCell.self, forCellReuseIdentifier: "finishThat")
        
        if #available(iOS 10.0, *) {
            table.refreshControl = refreshGesture
        } else {
            table.addSubview(refreshGesture)
        }
        
        refreshGesture.addTarget(self, action: #selector(updateInformation(_:)), for: .valueChanged)
        refreshGesture.tintColor = UIColor.retrieveMainColor(withAlpha: 1.0)
        
        self.view.addSubview(table)
        
    }
    
    @objc func updateInformation(_ sender: Any) {
        //THIS WILL BE CALLED WHEN THE USER PULLS DOWN ON THE TABLE VIEW
        //SHOULD TRIGGER THE METHOD TO GO LOOKING FOR ANYWORK THAT MIGHT HAVE BEEN ASSIGNED SINCE THE LAST PULL
    }
    
    //EVRYTHING TO DO WITH THE TABLE VIEW
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row != self.work.count {
            //This means that the row that was selected was not the last one, aka the one with the picture on it
            let assignmentView = AssignmentView()
            assignmentView.thisWork = work[indexPath.row]
            self.present(assignmentView, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return work.count + 1
        //The work array is normally going to be empty. This would give it a count of 0. When we add one, it is going to be the one cell that will take up all of the room on the board, and say that you have no work. Else, it will be the one on the bottom
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if work.count - 1 >= indexPath.row {
            return 80
        } else {
            return self.view.frame.height - 115
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if work.count - 1 >= indexPath.row {
            //There is a work here, we should return a work cell
            let cell = table.dequeueReusableCell(withIdentifier: "workCell") as! HomeWorkCell
            cell.width = self.view.frame.width
            cell.homeWork = work[indexPath.row]
            cell.parentViewController = self
            //By doing this, it is going to set all of the labels on its own, no need to do that here
            return cell
        } else {
            let cell = table.dequeueReusableCell(withIdentifier: "finishThat") as! PhotoCell
            cell.viewWidth = self.view.frame.width
            cell.viewHeight = self.view.frame.height - 115
            if work.count > 0 {
                //There was some work
                cell.hasOtherWork = true
            } else {
                //There was no work at all, we need the cell to take up all of the space, and to show the no work
                cell.hasOtherWork = false
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        if indexPath.row != self.work.count {
            let delete = UITableViewRowAction(style: .destructive, title: "Destroy") { (action, indexPath) in
                // delete item at indexPath
                
                DataStorage.User.Work.delete(self.work[indexPath.row].uid, completion: { _ in
                    DataStorage.WorkObjects.Local.delete(self.work[indexPath.row].uid)
                    self.work.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                })
                
                
                //Eventually, this should show a little drop down message from the tab bar with an undo button for a few seconds
                
            }
            
            return [delete]
        } else {
            return []
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        for touch in touches {
            if topBar.isShowingOptions {
                topBar.optionFunction(touch.location(in: self.view))
            }
        }
    }
}
