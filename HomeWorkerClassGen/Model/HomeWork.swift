//
//  HomeWork.swift
//  HomeWorkerClassGen
//
//  Created by Ryan Topham on 9/27/18.
//  Copyright © 2018 Angry Bear Coding Studios. All rights reserved.
//

import Foundation

struct HomeWork: Codable {
    var assignmentName: String!
    var assignee: String!
    var wantsNotifications: Bool!
    var startDateString: String!
    var endDateString: String!
    var images: [String] = []
    var imageTitles: [String] = []
    var uid: String!
    
    var noteTitles: [String] = []
    var notes: [String] = []
    
    init(_ name: String, _ assigneeName: String, _ notifBool: Bool, _ endDate: Date, _ uid: String) {
        self.assignmentName = name
        self.assignee = assigneeName
        self.wantsNotifications = notifBool
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yy"
        
        let endString = dateFormatter.string(from: endDate)
        self.endDateString = endString
        
        let startString = dateFormatter.string(from: Date.init())
        self.startDateString = startString
        
        self.uid = uid
    }
    
    mutating func addAssocImage(id: String, title: String) {
        images.append(id)
        imageTitles.append(title)
    }
    
    mutating func addAssocNote(id: String, title: String) {
        notes.append(id)
        noteTitles.append(title)
    }
    
    func hasImages() -> Bool {
        if images != [] {
            return true
        } else {
            return false
        }
    }
    
    func hasNotes() -> Bool {
        if notes != [] {
            return true
        } else {
            return false
        }
    }
}
