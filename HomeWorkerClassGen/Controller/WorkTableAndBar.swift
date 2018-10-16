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
    
    var work: [HomeWork] = [HomeWork("Packer", "Laich", false, Date.distantFuture, "wufoewubw"), HomeWork("Reading", "Cousins", false, Date.distantFuture, "wufoewubw"), HomeWork("Chapter", "Blair", false, Date.distantFuture, "wufoewubw"), HomeWork("Origami", "Haven", false, Date.distantFuture, "wufoewubw"), HomeWork("To Kill A Mockingbird", "Chamoff", false, Date.distantFuture, "wufoewubw"), HomeWork("Diagram", "Tanquay", false, Date.distantFuture, "wufoewubw")]
    
    var table = UITableView()
    
    let refreshGesture = UIRefreshControl()
    
    var topBar: TabBar!
    
    override func viewDidLoad() {
        
        print("Did make it to the work view")
        self.view.backgroundColor = UIColor.white
        
        placeTableView()
        readyBar()
        print(self.view.frame)
    }
    
    func readyBar() {
        
        topBar = TabBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80), leftItem: true)
        topBar.optionSet = ["New Assignment", "New Class"]
        self.view.addSubview(topBar)
    }
    
    func placeTableView() {
        
        table.frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height - 80)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return work.count + 1
        //The work array is normally going to be empty. This would give it a count of 0. When we add one, it is going to be the one cell that will take up all of the room on the board, and say that you have no work. Else, it will be the one on the bottom
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if work.count - 1 >= indexPath.row {
            return 80
        } else {
            return self.view.frame.height - 80
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
    
}
