//
//  ClassMangerView.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 11/23/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation
import UIKit

class ClassManagerView: UIViewController {
    
    //Use this to hide the status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    //File variables
    var myClasses: [Classes]!
    
    var topBar: TabBar!
    var table: UITableView!
    
    override func viewDidAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.white
    }
    
    override func viewDidLoad() {
        
        DataStorage.ClassStorage.fetch { theClasses in
            self.myClasses = theClasses
            print("These are the classes", theClasses)
            self.prepareTopbar()
        }
    }
    
    func prepareTopbar() {
        topBar = TabBar(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 80), leftItem: false)
        topBar.backView = SettingsPage()
        topBar.width = 200
        topBar.optionSet = []
        topBar.parentView = self
        self.view.addSubview(topBar)
        
        setupTable()
    }
    
    func setupTable() {
        
        table = UITableView()
        table.frame = CGRect(x: 0, y: 80, width: self.view.frame.width, height: self.view.frame.height - 80)
        table.dataSource = self
        table.delegate = self
        
        table.register(ClassCell.self, forCellReuseIdentifier: "classCell")
        table.register(PhotoCell.self, forCellReuseIdentifier: "finishThat")
        
        self.view.addSubview(table)
    }
    
}

extension ClassManagerView: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if indexPath.row != myClasses.count {
            //This means it is not the last one
            let delete = UITableViewRowAction(style: .destructive, title: "Destroy") { (action, indexPath) in
                // delete item at indexPath
                
                DataStorage.ClassStorage.delete(andWork: true, self.myClasses[indexPath.row].id, completion: {
                    self.myClasses.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                })
            }
            
            return [delete]

        } else {
            return []
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myClasses.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        print("Tyring to make a class cell")
        
        if indexPath.row < myClasses.count {
            let cell = table.dequeueReusableCell(withIdentifier: "classCell") as! ClassCell
            
            cell.width = self.view.frame.width
            cell.thisClass = myClasses[indexPath.row]
            
            return cell
        } else {
            let cell = table.dequeueReusableCell(withIdentifier: "finishThat") as! PhotoCell
            cell.viewWidth = self.view.frame.width
            cell.viewHeight = self.view.frame.height - 115
            cell.hasOtherWork = false
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row < myClasses.count {
            return 80
        } else {
            return self.view.frame.height - 115
        }
    }
}
